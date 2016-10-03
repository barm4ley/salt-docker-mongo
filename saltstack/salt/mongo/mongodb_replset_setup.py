#!/usr/bin/env python

import __future__
import pymongo
import argparse

{% from "mongo/map.jinja" import mongo_creds as creds with context %}

USERNAME = '{{ creds.superuser.name }}'
PASSWORD = '{{ creds.superuser.password }}'

def get_replset_members(client):
    return [node[0] + ':' + str(node[1]) for node in client.nodes]


def make_replset_config(rs_name, rs_members):
    rs_config = {'_id': rs_name, 'members':[]}
    for i, name in enumerate(rs_members):
        rs_config['members'].append({'_id': i,
                                 'host': name})
    return rs_config


def init_replset(client, rs_name):
    conf = client.local.system.replset.find().count()
    if conf == 0:
        # replica doesn't exitst
        cfg = {
            '_id': rs_name,
            'members': [
                {'host': client.address[0] + ':' + str(client.address[1]),
                 '_id': 0,
                 'arbiterOnly': False}
            ]
        }
        client.admin.command("replSetInitiate", cfg)


def join_replset(primary, secondary_addr, rs_name):
    members = get_replset_members(primary)
    members.append(secondary_addr)

    cfg = primary.local.system.replset.find_one()

    max_id = max([member['_id'] for member in cfg['members']])

    new_member = {'arbiterOnly': False,
                  '_id': max_id + 1,
                  'hidden': False,
                  'votes': 1,
                  'host': secondary_addr,
                  'buildIndexes': True,
                  'tags': {},
                  'slaveDelay': 0,
                  'priority': 1.0}

    cfg['version'] += 1
    cfg['members'].append(new_member)

    primary.admin.command("replSetReconfig", cfg)


def authenticate(client):
    client.admin.authenticate(USERNAME, PASSWORD)
    client.local.authenticate(USERNAME, PASSWORD, source='admin')


def main():
    parser = argparse.ArgumentParser(description='MongoDB replica set configurator')
    parser.add_argument('--ip',
                        required=True)
    parser.add_argument('--rs-name',
                        required=True)
    parser.add_argument('--primary',
                        default=None)
    args = parser.parse_args()

    if not args.primary:
        client = pymongo.MongoClient(args.ip)
        authenticate(client)
        init_replset(client, args.rs_name)
    else:
        client = pymongo.MongoClient(args.primary)
        authenticate(client)
        join_replset(client, args.ip, args.rs_name)


if __name__ == '__main__':
    main()

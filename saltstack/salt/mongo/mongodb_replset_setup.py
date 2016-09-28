#!/usr/bin/env python

import __future__
import pymongo
import argparse


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
        print(cfg)
        client.admin.command("replSetInitiate", cfg)
        print("ReplSet initiated:")
        print(client.local.system.replset.find_one())
    else:
        print('ReplSet is already present:')
        print(client.local.system.replset.find_one())
    return client.local.system.replset.find_one()


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


    print(cfg)
    primary.admin.command("replSetReconfig", cfg)
    print("ReplSet reconfigured:")
    print(primary.local.system.replset.find_one())


def main():
    parser = argparse.ArgumentParser(description='MongoDB replica set configurator')
    parser.add_argument('--ip',
                        required=True)
    parser.add_argument('--rs-name',
                        required=True)
    parser.add_argument('--primary',
                        default=None)
    args = parser.parse_args()

    print(args)

    if not args.primary:
        client = pymongo.MongoClient(args.ip)
        init_replset(client, args.rs_name)
    else:
        client = pymongo.MongoClient(args.primary)
        join_replset(client, args.ip, args.rs_name)


if __name__ == '__main__':
    main()

#!/usr/bin/env python

import __future__
import pymongo
import socket
import argparse
import time


print('My name is ', socket.gethostname())

RS_NAME = 'test_replset'

DEFAULT_MONGO_PORT = '27017'

#SERVERS = ['mongo1', 'mongo2']
#SERVERS_IP = [socket.gethostbyname(svr) for svr in SERVERS]

this_host = socket.gethostname()


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


def parse_address(addr):
    lst = addr.split(':')
    return (lst[0], lst[1] if len(lst) > 1 else DEFAULT_MONGO_PORT)


def find_primary(addrs):
    for addr in addrs:
        host, port = parse_address(addr)
        try:
            client = pymongo.MongoClient(host=host, port=int(port))
            if client.is_primary:
                return client
            else:
                print('%s is not primary' % addr)
        except Exception as exc:
            print(exc)
    return None

def join_replset(primary, secondary_addr, rs_name):
    members = get_replset_members(primary)
    members.append(secondary_addr)

    #cfg = make_replset_config(rs_name, members)
    cfg = primary.local.system.replset.find_one()

    max_id = max([member['_id'] for member in cfg['members']])

    #new_id = cfg['members'][0]['_id'] + 1
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
    pri = '192.168.99.100:27017'
    sec = '192.168.99.100:27018'

    pri_client = pymongo.MongoClient(pri)
    init_replset(pri_client, RS_NAME)

    time.sleep(5)

    pri_client = find_primary([pri])
    join_replset(pri_client, sec, RS_NAME)


def main_1():
    parser = argparse.ArgumentParser(description='MongoDB replica set configurator')
    parser.add_argument('--member',
                        default=[],
                        #nargs='*',
                        action='append')
    parser.add_argument('--rs-name',
                        required=True)
    parser.add_argument('--new-member',
                        required=True)
    args = parser.parse_args()

    print(args)

    mems = args.member + [args.new_member]
    conf = make_replset_config(args.rs_name, mems)
    print(conf)

    client = pymongo.MongoClient(args.new_member)
    init_replset(client, args.rs_name)

    print(get_replset_members(client))


if __name__ == '__main__':
    main()

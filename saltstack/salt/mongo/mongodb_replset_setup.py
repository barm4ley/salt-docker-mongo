#!/usr/bin/env python

import __future__
import pymongo
import socket


print('My name is ', socket.gethostname())

rs_name = 'replset'

#SERVERS = ['mongo1', 'mongo2']
#SERVERS_IP = [socket.gethostbyname(svr) for svr in SERVERS]

client = pymongo.MongoClient()
this_host = socket.gethostname()

def init_replset(client, rs_name):
    conf = client.local.system.replset.find.count()
    if conf == 0:
        # replica doesn't exitst
        cfg = {
            '_id': rs_name,
            'members': [
                {'host': this_host,
                 '_id': 0,
                 'arbiterOnly': False}
            ]
        }
        client.admin.command("replSetInitiate", cfg)
        print("ReplSet initiated:")
        print(client.local.system.replset.find_one())
    else:
        print('ReplSet is already present:')
        print(client.local.system.replset.find_one())

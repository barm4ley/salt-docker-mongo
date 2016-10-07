#!/usr/bin/env python

{% from "mongo/map.jinja" import mongo with context %}

import __future__
import pymongo

USERNAME = '{{ mongo.creds.superuser.name }}'
PASSWORD = '{{ mongo.creds.superuser.password }}'

client = pymongo.MongoClient()

try:
    client.admin.add_user(USERNAME, PASSWORD, roles=[
        {'role':'userAdminAnyDatabase', 'db':'admin'},
        {'role':'clusterAdmin', 'db':'admin'},
        {'role':'readWrite', 'db':'local'}
    ])
    client.admin.authenticate(USERNAME, PASSWORD)
except Exception as e:
    print(e)

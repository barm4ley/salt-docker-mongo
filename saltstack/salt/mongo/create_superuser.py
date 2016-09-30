#!/usr/bin/env python

{% from "mongo/map.jinja" import mongo_creds as creds with context %}

import __future__
import pymongo

USERNAME = '{{ creds.superuser.name }}'
PASSWORD = '{{ creds.superuser.password }}'

client = pymongo.MongoClient()

try:
    client.admin.add_user(USERNAME, PASSWORD, roles=[{'role':'userAdminAnyDatabase', 'db':'admin'}])
    client.admin.authenticate(USERNAME, PASSWORD)
except Exception as e:
    print(e)

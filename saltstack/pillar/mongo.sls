mongo_image_options:
  name: mongo
  tag: latest

mongo_options:
  replset: CrAnReplSet
  auth: false
  dbpath: /opt/mongodata
  logpath: /var/log/mongodb

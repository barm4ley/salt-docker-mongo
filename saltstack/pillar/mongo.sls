mongo_image_options:
  name: mongo
  tag: latest

mongo_options:
  replset: CrAnReplSet
  dbpath: /opt/mongodata
  logpath: /var/log/mongodb

  primary_addr: '192.168.50.21'
  user: 999
  group: 999

  script_path: /opt/apps/mongodb

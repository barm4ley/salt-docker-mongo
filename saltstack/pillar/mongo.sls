
mongo:
  primary_addr: '192.168.50.21'
  user: 999
  group: 999

  script_path: /opt/apps/mongodb

  config:
    replset: CrAnReplSet
    dbpath: /opt/mongodata
    logpath: /var/log/mongodb

  image:
    name: mongo
    tag: latest

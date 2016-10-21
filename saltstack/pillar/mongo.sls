
mongo:
  primary_addr: '192.168.50.21'
  user: 999
  group: 999

  script_path: /opt/apps/mongodb

  backup:
    dir: /backup/mongo
    #file: cran_mongo_{{ None|strftime('%Y-%m-%d') }}.gz
    file: cran_mongo_{{ None|strftime('%Y-%m-%d-%H-%M') }}.gz
    last: cran_mongo_last.gz

  config:
    auth: False
    replset: CrAnReplSet
    dbpath: /mnt/data/mongo
    logpath: /var/log/mongodb

  image:
    name: mongo
    tag: latest

cran:
  config_dir: /config/cran

  bind_address: 0.0.0.0
  bind_port: 80

  image:
    name: maximunity/cran
    tag: latest

  env:
    EXTERNAL_URL_SERVER_NAME: crashes.hq.unity3d.com:80
    CRAN_LOG_COLLECTOR_ADDRESS: 192.168.99.100
    CRAN_LOG_COLLECTOR_PORT: 12201

    FOGBUGZ_SQL_DB: trial1
    FOGBUGZ_SQL_HOST: fogbugz-sql1.hq.unity3d.com
    FOGBUGZ_TICKET_FETCH_INTERVAL_MINS: 15
    FOGBUGZ_TICKET_UPDATE_INTERVAL_MINS: 15

    MONGODB_HOST: mongo.service.consul
    MONGODB_PORT: 27017
    MONGODB_REPLICASET: CrAnReplSet

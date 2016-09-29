base:
  '*':
    - default
    - creds.slack

  #'G@role:mongo':
  'mongo*':
    - registrator
    - service-discovery
    - mongo
    - creds.docker

  'consul':
    - consul

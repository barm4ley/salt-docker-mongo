base:
  '*':
    - default
    - service-discovery
    - creds.slack

  #'G@role:mongo':
  'mongo*':
    - registrator
    - mongo
    - creds.docker

  'consul':
    - consul

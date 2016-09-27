base:
  '*':
    - default
    - creds.slack

  #'G@role:mongo':
  'mongo*':
    - service-discovery
    - mongo
    - creds.docker

  'consul':
    - consul

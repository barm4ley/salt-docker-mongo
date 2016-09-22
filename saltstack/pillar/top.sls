base:
  '*':
    - default
    - creds.slack

  #'G@role:mongo':
  'mongo*':
    - service-discovery
    - creds.docker

  'consul':
    - consul

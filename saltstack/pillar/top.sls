base:
  '*':
    - default
    - creds.slack

  #'G@role:mongo':
  'mongo*':
    - creds.docker

  'consul':
    - consul

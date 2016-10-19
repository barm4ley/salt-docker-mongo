base:
  '*':
    - default
    - service-discovery
    - creds.slack
    - creds.docker
    - registrator

  #'G@role:mongo':
  'mongo*':
    - mongo
    - creds.mongo

  'consul':
    - consul

  'cran*':
    - creds.cran
    - cran
    - haproxy

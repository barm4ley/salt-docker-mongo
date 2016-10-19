base:
  '*':
    - common
    - pip
    - docker

  #'G@role:mongo':
  'mongo*':
    - registrator
    - mongo
    #- slack.test
  'consul':
    - consul
    - consul.start

  'cran*':
    - registrator
    - cran
    - cran.start
    - haproxy

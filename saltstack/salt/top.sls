base:
  '*':
    - common
  #'G@role:mongo':
  'mongo*':
    - pip
    - docker
    - registrator
    - mongo.docker
    #- slack.test
  'consul':
    - consul

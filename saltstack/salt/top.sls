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
    - consul_docker

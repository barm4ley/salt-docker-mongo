base:
  '*':
    - common
  #'G@role:mongo':
  'mongo*':
    - pip
    - docker
    - registrator
    - mongo
    #- slack.test
  'consul':
    - consul

base:
  '*':
    - common
  'G@roles:dockermongo':
    - pip
    - docker
    - mongo.docker
    - slack.test


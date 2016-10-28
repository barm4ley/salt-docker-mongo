base:
  '*':
    - common
    - pip
    - docker

  'env:prod':
    - match: grain
    - registrator

  'roles:cran-mongo':
    - match: grain
    - mongo.create_users
    - mongo.start

  'roles:toolsmith-sd':
    - match: grain
    - consul.start

  'roles:cran-web':
    - match: grain
    - cran.web.start

  'roles:cran-fetcher-updater':
    - match: grain
    - cran.fetcher.start

  'roles:cran-lb':
    - match: grain
    - haproxy.start

  'roles:cran-keepalived':
    - match: grain
    - keepalived.start

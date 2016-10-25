base:
  '*':
    - common
    - pip
    - docker

  'env:prod':
    - match: grain
    - registrator

  'roles: mongo':
    - match: grain
    - mongo

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

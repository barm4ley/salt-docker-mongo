base:
  '*':
    - default
    - service-discovery
    - creds.slack
    - creds.docker
    - registrator

  'G@env:prod and G@roles:cran-mongo':
    - match: compound
    - mongo
    - creds.mongo

  'G@env:prod and G@roles:toolsmith-sd':
    - match: compound
    - consul

  'G@env:prod and ( G@roles:cran-web or G@roles:cran-fetcher-updater )':
    - match: compound
    - creds.cran
    - cran

  'G@env:stg and ( G@roles:cran-web or G@roles:cran-fetcher-updater )':
    - match: compound
    - creds.cran
    - cran

  'G@env:prod and G@roles:cran-lb':
    - match: compound
    - haproxy

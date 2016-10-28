base:
  '*':
    - default
    - service-discovery
    - slack
    - creds.slack
    - creds.docker
    - registrator

  'roles:cran-mongo':
    - match: grain
    - creds.mongo
    - mongo

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

  'roles:cran-lb':
    - match: grain
    - haproxy

  'roles:cran-keepalived':
    - match: grain
    - creds.keepalived
    - keepalived


reconfig_haproxy:
  local.state.apply:
    - tgt: 'G@env:stg and G:cran-mongo'
    - arg:
      - cran.start
    - queue: True
    - concurrent: True
    - kwarg:
      queue: True
      concurrent: True
      saltenv: base

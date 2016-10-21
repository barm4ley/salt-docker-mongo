
reconfig_haproxy:
  local.state.apply:
    - tgt: 'cran*'
    - arg:
      - haproxy.config
    - queue: True
    - concurrent: True
    - kwarg:
      queue: True
      concurrent: True
      saltenv: base

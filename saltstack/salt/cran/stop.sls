{% from "docker/helpers.jinja" import stop_container with context %}

{{ stop_container('cran') }}
{{ stop_container('fetcher_updater') }}


send_cran_stopped_event:
  event.send:
    - name: docker/cran/{{ saltenv }}/stopped
    - require:
      - dockerng: stop_cran_container

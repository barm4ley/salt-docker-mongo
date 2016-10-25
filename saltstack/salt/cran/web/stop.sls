{% from "docker/helpers.jinja" import stop_container with context %}

{{ stop_container('cran') }}

send_cran_stopped_event:
  event.send:
    - name: docker/cran/{{ env }}/stopped
    - require:
      - dockerng: stop_cran_container

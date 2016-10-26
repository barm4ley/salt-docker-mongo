{% from "map.jinja" import env with context %}
{% from "map.jinja" import slack with context %}
{% from "docker/helpers.jinja" import stop_container with context %}

{{ stop_container('cran') }}

send_cran_stopped_event:
  event.send:
    - name: docker/cran/{{ env }}/stopped
    - require:
      - dockerng: stop_cran_container


{% if slack.notifications_enabled %}
stop_cran_container_slack_message:
  slack.post_message:
    - channel: '#{{ slack.channel }}'
    - from_name: {{ slack.from_name }}
    - api_key: {{ slack.api_key }}
    - message: 'CrAn Web (env: `{{ env }}`) is stopped on `{{ grains['fqdn'] }}`'
    - onchanges:
      - dockerng: stop_cran_container

remove_cran_container_slack_message:
  slack.post_message:
    - channel: '#{{ slack.channel }}'
    - from_name: {{ slack.from_name }}
    - api_key: {{ slack.api_key }}
    - message: 'CrAn Web (env: `{{ env }}`) is removed from `{{ grains['fqdn'] }}`'
    - onchanges:
      - dockerng: remove_cran_container
{% endif %}

{% from "map.jinja" import env with context %}
{% from "map.jinja" import slack with context %}
{% from "keepalived/map.jinja" import keepalived with context %}
{% from "docker/helpers.jinja" import stop_container with context %}


{{ stop_container(keepalived.image.container_name) }}


{% if slack.notifications_enabled %}
stop_keepalived_container_slack_message:
  slack.post_message:
    - channel: '#{{ slack.channel }}'
    - from_name: {{ slack.from_name }}
    - api_key: {{ slack.api_key }}
    - message: 'Keepalived (env: `{{ env }}`) is stopped on `{{ grains['fqdn'] }}`'
    - onchanges:
      - dockerng: stop_{{ keepalived.image.container_name }}_container

remove_keepalived_container_slack_message:
  slack.post_message:
    - channel: '#{{ slack.channel }}'
    - from_name: {{ slack.from_name }}
    - api_key: {{ slack.api_key }}
    - message: 'Keepalived (env: `{{ env }}`) is removed from `{{ grains['fqdn'] }}`'
    - onchanges:
      - dockerng: remove_{{ keepalived.image.container_name }}_container
{% endif %}

{% from "map.jinja" import env with context %}
{% from "map.jinja" import slack with context %}
{% from "haproxy/map.jinja" import haproxy with context %}
{% from "docker/helpers.jinja" import stop_container with context %}

{{ stop_container(haproxy.image.container_name) }}

{% if slack.notifications_enabled %}
stop_{{ haproxy.image.container_name }}_container_slack_message:
  slack.post_message:
    - channel: '#{{ slack.channel }}'
    - from_name: {{ slack.from_name }}
    - api_key: {{ slack.api_key }}
    - message: 'HAProxy (env: `{{ env }}`) is stopped on `{{ grains['fqdn'] }}`'
    - onchanges:
      - dockerng: stop_{{ haproxy.image.container_name }}_updater_container

remove_{{ haproxy.image.container_name }}_container_slack_message:
  slack.post_message:
    - channel: '#{{ slack.channel }}'
    - from_name: {{ slack.from_name }}
    - api_key: {{ slack.api_key }}
    - message: 'HAProxy (env: `{{ env }}`) is removed from `{{ grains['fqdn'] }}`'
    - onchanges:
      - dockerng: remove_{{ haproxy.image.container_name }}_container
{% endif %}

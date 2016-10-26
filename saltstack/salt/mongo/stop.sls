{% from "map.jinja" import env with context %}
{% from "map.jinja" import slack with context %}
{% from "mongo/map.jinja" import mongo with context %}
{% from "docker/helpers.jinja" import stop_container with context %}

include:
  - mongo.unschedule_backup

{{ stop_container(mongo.image.container_name) }}


{% if slack.notifications_enabled %}
stop_mongo_container_slack_message:
  slack.post_message:
    - channel: '#{{ slack.channel }}'
    - from_name: {{ slack.from_name }}
    - api_key: {{ slack.api_key }}
    - message: 'MongoDB (env: `{{ env }}`) is stopped on `{{ grains['fqdn'] }}`'
    - onchanges:
      - dockerng: stop_{{ mongo.image.container_name }}_container

remove_mongo_container_slack_message:
  slack.post_message:
    - channel: '#{{ slack.channel }}'
    - from_name: {{ slack.from_name }}
    - api_key: {{ slack.api_key }}
    - message: 'MongoDB (env: `{{ env }}`) is removed from `{{ grains['fqdn'] }}`'
    - onchanges:
      - dockerng: remove_{{ mongo.image.container_name }}_container
{% endif %}

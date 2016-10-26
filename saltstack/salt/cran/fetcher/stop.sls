{% from "map.jinja" import env with context %}
{% from "map.jinja" import slack with context %}
{% from "docker/helpers.jinja" import stop_container with context %}

{{ stop_container('fetcher_updater') }}

{% if slack.notifications_enabled %}
stop_cran_fetcher_updater_container_slack_message:
  slack.post_message:
    - channel: '#{{ slack.channel }}'
    - from_name: {{ slack.from_name }}
    - api_key: {{ slack.api_key }}
    - message: 'CrAn Fetcher/Updater (env: `{{ env }}`) is stopped on `{{ grains['fqdn'] }}`'
    - onchanges:
      - dockerng: stop_fetcher_updater_container

remove_cran_updater_container_slack_message:
  slack.post_message:
    - channel: '#{{ slack.channel }}'
    - from_name: {{ slack.from_name }}
    - api_key: {{ slack.api_key }}
    - message: 'CrAn Fetcher/Updater (env: `{{ env }}`) is removed from `{{ grains['fqdn'] }}`'
    - onchanges:
      - dockerng: remove_fetcher_updater_container
{% endif %}

{% from "map.jinja" import sd with context %}
{% from "map.jinja" import env with context %}
{% from "map.jinja" import slack with context %}
{% from "cran/map.jinja" import cran with context %}

include:
  - docker
  - cran

run_cran_fetcher_updater_container:
  dockerng.running:
    - name: fetcher_updater
    - image: {{ cran.image.name }}:{{ cran.image.tag }}
    - hostname: cran-{{ env }}.fetcher-updater
    - restart_policy: always
    - dns:
      - {{ sd.address }}
      - 8.8.8.8
    - environment:
      {% for name, val in cran.env.iteritems() %}
      - {{ name }}: "{{ val }}"
      {% endfor %}
    - cmd: python -m cran.manage sync_with_fogbugz

{% if slack.notifications_enabled %}
run_cran_fetcher_updater_container_slack_message:
  slack.post_message:
    - channel: '#{{ slack.channel }}'
    - from_name: {{ slack.from_name }}
    - api_key: {{ slack.api_key }}
    - message: 'CrAn Fetcher/Updater (env: `{{ env }}`) is (re)started on `{{ grains['fqdn'] }}`'
    - onchanges:
      - dockerng: run_cran_fetcher_updater_container
{% endif %}

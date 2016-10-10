{% from "docker/helpers.jinja" import stop_container with context %}

{{ stop_container('cran') }}
{{ stop_container('fetcher_updater') }}

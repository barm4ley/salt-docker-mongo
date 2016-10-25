{% from "docker/helpers.jinja" import stop_container with context %}

{{ stop_container('fetcher_updater') }}

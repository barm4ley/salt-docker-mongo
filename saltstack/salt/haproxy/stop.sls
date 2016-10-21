{% from "haproxy/map.jinja" import haproxy with context %}
{% from "docker/helpers.jinja" import stop_container with context %}

{{ stop_container(haproxy.image.container_name) }}

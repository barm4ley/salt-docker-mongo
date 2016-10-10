{% from "consul/map.jinja" import consul with context %}
{% from "docker/helpers.jinja" import stop_container with context %}

{{ stop_container(consul.image.name) }}

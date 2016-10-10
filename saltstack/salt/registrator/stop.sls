{% from "registrator/map.jinja" import registrator_image_options as image with context %}
{% from "docker/helpers.jinja" import stop_container with context %}

{{ stop_container(image.name) }}

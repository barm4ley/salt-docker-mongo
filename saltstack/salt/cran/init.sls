{% from "cran/map.jinja" import cran with context %}

include:
  - docker
  - pip


download_cran_image:
  dockerng.image_present:
    - name: {{ cran.image.name }}:{{ cran.image.tag }}
    - require:
      - pip: docker_python_api

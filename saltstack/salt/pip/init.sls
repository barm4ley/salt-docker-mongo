
python_pip_install:
  pkg.installed:
    - name: python-pip

python_pip_update:
  cmd.run:
    - name: 'easy_install -U pip'
    - require:
      - pkg: python_pip_install

#sls

include:
  - .jdk

zookeeper_source:
  file.managed:
    - name: /opt/zookeeper-3.4.5.tar.gz
    - source: salt://zookeeper/files/zookeeper-3.4.5.tar.gz
  cmd.run:
    - name: tar -xf /opt/zookeeper-3.4.5.tar.gz
    - cwd: /opt
    - unless: file /opt/zookeeper-3.4.5
    - require:
      - file: zookeeper_source

zookeeper_data:
  file.directory:
    - name: /opt/zookeeper-3.4.5/data
    - require:
      - cmd: zookeeper_source

zookeeper_conf:
  file.managed:
    - name: /opt/zookeeper-3.4.5/conf/zoo.cfg
    - source: salt://zookeeper/templates/zoo.cfg
    - template: jinja
    - require:
      - cmd: zookeeper_source

zookeeper_init:
  file.managed:
    - name: /etc/init.d/zookeeper
    - mode: 777
    - source: salt://zookeeper/files/zookeeper-init

zookeeper_service:
  service:
    - name: zookeeper
    - running
    - require:
      - file: zookeeper_init
      - file: zookeeper_conf
      - file: zookeeper_data
      - alternatives: java


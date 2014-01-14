#sls
{% set jdk_version = salt['pillar.get']('jdk:version', '1.7.0_21') %}

jdkbasedirectories:
  file.directory:
    - name: /usr/lib/jvm/releases/
    - makedirs: True

jdkextract:
  file.managed:
    - name: /usr/lib/jvm/releases/jdk{{ jdk_version }}.gz
    - source: salt://zookeeper/files/jdk{{ jdk_version }}.gz
    - mode: 777
    - require:
      - file: jdkbasedirectories
  cmd.run:
    - name: tar xf jdk{{ jdk_version }}.gz
    - cwd: /usr/lib/jvm/releases/
    - unless: file /usr/lib/jvm/releases/jdk{{ jdk_version }}/bin
    - require:
      - file: jdkextract

{% set alts = ['java', 'javac', 'javaws', 'jar', 'jps'] -%}
{% for alt in alts %}
{{ alt }}:
  alternatives.install:
    - link: /usr/bin/{{ alt }}
    - path: /usr/lib/jvm/releases/jdk{{ jdk_version }}/bin/{{ alt }}
    - priority: 1
    - require:
      - cmd: jdkextract
{% endfor %}

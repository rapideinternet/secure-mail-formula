
{% if salt['pillar.get']('secure-mail:domain-name') is defined and salt['pillar.get']('secure-mail:domain-name')|length %}
sm-install-cert:
  cmd.run:
    - name: "/usr/src/certbot/certbot-auto certonly -n -m certs@rapide.nl --quiet --agree-tos --expand --webroot -w /var/www/default/httpdocs -d {{ salt['pillar.get']('secure-mail:domain-name') }}"
    - unless: ls /etc/letsencrypt/live/{{ salt['pillar.get']('secure-mail:domain-name') }}
    - require:
      - cmd: letsencrypt_source
      
/usr/local/bin/update-certs:
  file.managed:
    - source: salt://secure-mail/files/update-certs
    - template: jinja
    - require:
      - cmd: sm-install-cert
{% else %}
  /usr/local/bin/update-certs:
    file.managed:
      - source: salt://secure-mail/files/update-certs-normal
      - template: jinja
{% endif %}

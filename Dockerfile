FROM bitnami/openresty:1.19.9-1

USER 0
RUN install_packages gettext-base

COPY serverblocks/00_logformat.conf /opt/bitnami/openresty/nginx/conf/server_blocks/
RUN chown -R 1001 /opt/bitnami/openresty/nginx/conf/server_blocks/
COPY docker-entrypoint.d /docker-entrypoint.d/
COPY docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

USER 1001

ENTRYPOINT ["/docker-entrypoint.sh", "/opt/bitnami/scripts/openresty/entrypoint.sh"]

CMD ["/opt/bitnami/scripts/openresty/run.sh"]
Image based on bitnami/openresty but with envsubst enabled.

Sensible defaults:

| ENV | default |
|--|--|
| NGINX_ENVSUBST_TEMPLATE_DIR       | /opt/bitnami/openresty/nginx/conf/server_block_templates  |
| NGINX_ENVSUBST_TEMPLATE_SUFFIX | .conf  |
| NGINX_ENVSUBST_OUTPUT_DIR           | /opt/bitnami/openresty/nginx/conf/server_blocks   |


Mount openresty/nginx server blocks in $NGINX_ENVSUBST_TEMPLATE_DIR
It will substitute the env variables and put the files in $ NGINX_ENVSUBST_OUTPUT_DIR

Then openresty wil start

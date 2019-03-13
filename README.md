# nginx-proxy-redirect

An nginx reverse proxy and redirect server, configured for common purposes via YAML config file.

It is expected that you will run this behind Traefik for automated SSL via Let's Encrypt.

The YAML file represents one or more `server` blocks and one or more `location` blocks within each `server` block.

Each location can be configured to reverse proxy, 301 permanent redirect, or 302 temporary redirect.

    - server_name:             # Nginx `server_name` directive
      client_max_body_size:    # Nginx `client_max_body_size` diretive.
      locations:
      - rule:                  # Nginx `location` directive.                                     Default: /
        url:                   # Nginx `proxy_pass` or `return` directive.
        permanent:             # Return 301 permanent (true) or 302 temporary (false) redirect.  Default: false
        proxy:                 # Reverse proxy (true) or redirect (false).                       Default: false

Locations and redirect URLs can include regular expressions and capture groups. Order matters when using regular expressions.

Append `$uri` to your redirect URL for a "soft" redirect, or use a regular expression location with capture groups.

See the following nginx docs:

- [$uri](http://nginx.org/en/docs/http/ngx_http_core_module.html#var_uri)
- [client_max_body_size](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_max_body_size)
- [location](http://nginx.org/en/docs/http/ngx_http_core_module.html#location)
- [proxy_pass](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass)
- [return](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html#return)
- [server_name](http://nginx.org/en/docs/http/ngx_http_core_module.html#server_name)

You can also configure nginx with the following environment variables:

- `CLIENT_MAX_BODY_SIZE='10m'`
- `WORKER_PROCESSES='auto'`

Some nginx config is hard coded:

- Gzip is enabled for common text formats.
- Websockets are supported.
- Log to stdout/stderr.
- Pass headers: `X-Forwarded-Proto`.
- Set headers: `Host`, `X-Forwarded-For`.
- Get real IP from trusted proxies (with private IP addresses).

Example config and Docker Compose files are provided for testing. In production, you would bind mount your own `config.yml` file to `/opt/nginx-proxy-redirect/config.yml`.

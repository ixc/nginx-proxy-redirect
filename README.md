# nginx-proxy-redirect

An nginx reverse proxy and redirect server, configured for common purposes with a simplified `config.yml` file.

It is expected that you will run this behind [Traefik](https://traefik.io/) for automated SSL via Let's Encrypt.

The `config.yml` file represents one or more templated `server` blocks and one or more templated `location` blocks within each `server` block.


## The `config.yml` file

Each location can be configured to reverse proxy, 301 permanent redirect, or 302 temporary redirect.

    - server_name:             # Nginx `server_name` directive
      client_max_body_size:    # Nginx `client_max_body_size` diretive.
      locations:
      - rule:                  # Nginx `location` directive.                                     Default: /
        url:                   # Nginx `proxy_pass` or `return` directive.
        permanent:             # Return 301 permanent (true) or 302 temporary (false) redirect.  Default: false
        proxy:                 # Reverse proxy (true) or redirect (false).                       Default: false
        proxy_host:            # Set Host header for proxy requests.                             Default: $http_host

Keys with default values can be omitted.

Locations and redirect URLs can include regular expressions and capture groups. Order matters when using regular expressions.

Append `$uri` to your redirect URL for a "soft" redirect, or use a regular expression location with capture groups to strip or rewrite part of the location from the redirect URL.


## Environmental config

You can configure nginx with the following environment variables:

- `CLIENT_MAX_BODY_SIZE='10m'` - A default value, declared in the `http` block. Can be overridden in each `server` block via `config.yml`.
- `WORKER_PROCESSES='1'` - A value of `auto` will run one worker process per available CPU core.


## Hard coded config

Some nginx config is hard coded:

- Log to stdout/stderr.
- Gzip is enabled for common text formats.
- Websockets are supported.
- Pass headers: `X-Forwarded-Proto`.
- Set headers: `Host`, `X-Forwarded-For`.
- Get real IP from trusted proxies (with private IP addresses).


## Custom config

Additional nginx configs are included from `data/conf.d/*.conf`, at the end of the `http` block. Use this to create custom `server` blocks with arbitrary config, if the proxy and redirect config templates are insufficient.


## nginx docs

Here are some quick links to the nginx docs for directives you can configure via `config.yml`:

- [$uri](http://nginx.org/en/docs/http/ngx_http_core_module.html#var_uri)
- [client_max_body_size](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_max_body_size)
- [location](http://nginx.org/en/docs/http/ngx_http_core_module.html#location)
- [proxy_pass](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass)
- [return](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html#return)
- [server_name](http://nginx.org/en/docs/http/ngx_http_core_module.html#server_name)
- [worker_processes](http://nginx.org/en/docs/ngx_core_module.html#worker_processes)


## Examples

Example `config.yml` and `docker-compose.yml` files are provided for testing. In production, you should provide your configs in a bind mounted directory to `/opt/nginx-proxy-redirect/data`.

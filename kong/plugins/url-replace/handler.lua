

local plugin = {
  PRIORITY = -1, -- set the plugin priority, which determines plugin execution order
  VERSION = "0.0.1", -- version in X.Y.Z format. Check hybrid-mode compatibility requirements.
}


function plugin:access(plugin_conf)
  pld_path = ngx.var.upstream_uri
  kong.log.debug("old path:" .. pld_path)
  kong.log.debug("regex:" .. plugin_conf.match_regex .. ", value: " .. plugin_conf.replace_val)
  pld_path = pld_path:gsub(plugin_conf.match_regex, plugin_conf.replace_val)
  kong.log.debug("new path:" .. pld_path)
  ngx.var.upstream_uri = pld_path

end

return plugin

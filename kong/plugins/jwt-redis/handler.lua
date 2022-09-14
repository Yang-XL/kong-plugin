local plugin = {
  PRIORITY = -1, -- set the plugin priority, which determines plugin execution order
  VERSION = "0.0.1", -- version in X.Y.Z format. Check hybrid-mode compatibility requirements.
}


function plugin:access(plugin_conf)
  local o_p = ngx.var.upstream_uri
  kong.log.debug("original ->", o_p, "")
  kong.log.debug("match_regex ->", plugin_conf.match_regex, "; replace_val -> ", plugin_conf.replace_val)
  o_p = o_p:gsub(plugin_conf.match_regex, plugin_conf.replace_val)
  kong.log.debug("New Path ->", o_p)
  ngx.var.upstream_uri = o_p
end

return plugin

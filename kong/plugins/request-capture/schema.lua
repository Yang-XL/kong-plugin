local typedefs = require "kong.db.schema.typedefs"


local PLUGIN_NAME = "kong-plugin-request-capture"


local schema = {
  name = PLUGIN_NAME,
  fields = {
    { consumer = typedefs.no_consumer },
    { protocols = typedefs.protocols_http },
    { config = {
      type = "record",
      fields = {
        { request_path = typedefs.path { required = true } },
        { request_up_path = typedefs.router_paths  { required = true, default = "Bye-World" } },
      },
    },
    },
  },
}

return schema

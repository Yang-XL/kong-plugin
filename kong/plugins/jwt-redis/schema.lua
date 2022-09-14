local typedefs = require 'kong.db.schema.typedefs'

return {
  name = "kong-plugin-jwt-redis",
  fields = {
    { consumer = typedefs.no_consumer, },
    {
      config = {
        type = "record",
        fields = {
          { match_regex = { required = true, type = "string" }, },
          { replace_val = { required = true, type = "string" } }
        }
      }
    }
  }
}

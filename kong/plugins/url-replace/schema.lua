local typedefs = require 'kong.db.schema.typedefs'

return {
  name = "kong-plugin-url-rewrite",
  fields = {
    { consumer = typedefs.no_consumer, },
    {
      config = {
        type = "record",
        fields = {
          { scop = { required = true, type = "array", elements = { type = "string", one_of = { "Healder", "Path", "Query" } } } },
          { match = { required = true, type = "string" }, },
          { replace_val = { required = true, type = "string" } }
        }
      }
    }
  }
}

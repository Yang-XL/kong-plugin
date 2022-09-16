local typedefs = require 'kong.db.schema.typedefs'

--默认都需要授权
--

return {
  name = "kong-plugin-jwt-redis-auth",
  fields = {
    { consumer = typedefs.no_consumer, },
    {
      config = {
        type = "record",
        fields = {
          { redis_hosts = { required = false, type = "array", elements = typedefs.host_with_optional_port }, },
          { redis_db = { required = false, type = "integer" }, },
          { redis_auth = { required = false, type = "string" }, },
          { jwt_secret = { required = true, type = "string" }, },
          { jwt_secret_base64 = { required = true, type = "boolean", default = false }, },
          { authorization_head_key = { required = true, type = "string", default = "Authorization" }, },
        }
      }
    }
  }
}

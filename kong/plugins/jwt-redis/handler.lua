local cjson = require("cjson")
local jwt = require("resty.jwt")
local validators = require "resty.jwt-validators"
local plugin = {
  PRIORITY = 1000, -- set the plugin priority, which determines plugin execution order
  VERSION = "0.0.1", -- version in X.Y.Z format. Check hybrid-mode compatibility requirements.
}


-- 可以验证指定的属性
local claim_spec = {
  -- validators.set_system_leeway(15), -- time in seconds
  -- exp = validators.is_not_expired(),
  -- iat = validators.is_not_before(),
  -- iss = validators.opt_matches("^http[s]?://yourdomain.auth0.com/$"),
  -- sub = validators.opt_matches("^[0-9]+$"),
  -- name = validators.equals_any_of({ "John Doe", "Mallory", "Alice", "Bob" }),
}

--解码Jwt
local function jwt_decode(token, secret)
  return jwt:verify(secret, token, claim_spec)
end

--- base 64 decode
-- @param input String to base64 decode
-- @return Base64 decoded string
local function base64_decode(input)
  return dec(input)
end

function plugin:access(plugin_conf)
  local bearer_token = kong.request.get_header(plugin_conf.authorization_head_key)

  if bearer_token == nil then
    kong.response.exit(ngx.HTTP_UNAUTHORIZED, "auth is nil")
  end

  kong.log.debug(bearer_token)
  local _, _, token = string.find(bearer_token, "Bearer%s+(.+)")
  kong.log.debug(token)

  local jwt_obj = {}
  local s       = plugin_conf.jwt_secret
  if plugin_conf.jwt_secret_base64 then
    s = base64_decode(plugin_conf.jwt_secret)
  end

  jwt_obj = jwt_decode(token, s)

  if not jwt_obj["verified"] then
    kong.response.exit(ngx.HTTP_FORBIDDEN, jwt_obj["reason"])
  end

  kong.response.exit(ngx.HTTP_OK, cjson.encode(jwt_obj))
end



local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

-- encoding
function enc(data)
    return ((data:gsub('.', function(x)
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

-- decoding
function dec(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(7-i) or 0) end
        return string.char(c)
    end))
end

return plugin

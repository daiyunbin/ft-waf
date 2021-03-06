--
-- Created by IntelliJ IDEA.
-- User: lee_xin
-- Date: 18/8/1
-- Time: 下午6:06
-- To change this template use File | Settings | File Templates.
local redis = require("resty.rediscli-ft")
local cjson = require("cjson.safe")
local data = ngx.req.get_body_data()
local reqbody = cjson.decode(data)
local  ruletype = reqbody["type"]
local  value = reqbody["value"]
local rdskey = ruletype..''
local red = redis.new()
waf = require("waf")
local util = require("util")
    local score = util.cacheInc();
    local res, err = red:exec(
        function(red)
            return red:zadd(rdskey ,tonumber(''..score),value)
        end
    )
local output = {}
if not err then
    output['status']= 1
    waf.load_rules()
else
    ngx.log(ngx.ERR,cjson.encode(err))
    output['status']= 0

end



ngx.print(cjson.encode(output))
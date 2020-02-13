local M = {}
 
local tconcat = table.concat  
local tinsert = table.insert  
local srep = string.rep
local outputfile = "/tmp/luci.log"
 
local function local_print(str)
    local dbg = io.open(outputfile, "a+")
    local str = str or ""
    if dbg then
        dbg:write(str..'\n')
        dbg:close()
    end
end
 
function M.print(...)
    local dbg = io.open(outputfile, "a+")
    local last = false
    if dbg then
        dbg:write(os.date("[%H:%M:%S]: "))
        for _, o in ipairs({...}) do
            if last then dbg:write("\t") end
            last = true
            dbg:write(tostring(o))
        end
        dbg:write("\n")
        dbg:close()
    end
end
 
function M.print_r(data, depth)  
    local depth = depth or 3
    local cstring = ""; 
    local top_flag = true
 
    local function table_len(t)
    local i = 0
    for k, v in pairs(t) do
        i = i + 1
    end
    return i
    end
 
    local function tableprint(data,cstring, local_depth)
        if data == nil then 
            local_print("core.print data is nil");
        end 
 
        local cs = cstring .. "\t";

        if top_flag then
            local_print(cstring .."{");
            top_flag = false
        end

        if(type(data)=="table") then
            for k, v in pairs(data) do
        if type(v) ~= "table" then
            if type(v) == "string" then
                        local_print(cs..tostring(k).." = ".."'"..tostring(v).."'");
            else
                        local_print(cs..tostring(k).." = "..tostring(v));
            end
        elseif table_len(v) == 0 then
            local_print(cs..tostring(k).." = ".."{}")
        elseif local_depth < depth then
                    local_print(cs..tostring(k).." = {");
                      tableprint(v,cs,local_depth+1);
        else
            local_print(cs..tostring(k).." = ".."{*}")
        end
            end 
        else
            local_print(cs..tostring(data));
        end 
        local_print(cstring .."}");
    end 
 
    local_print(os.date("[%H:%M:%S]: "))
    tableprint(data,cstring,0);
end
 
return M


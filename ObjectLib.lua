-- CREATED BY Elektrum, The only thing you are asked to keep when modifing is those two first line. Thanks
-- THERE IS NO COPYRIGHT YOU CAN MODIFIE IT AT OUR OWN RISK. And you can use it however you want.
--------Version 1.1--------

local Object = {}
Object.isClass = function() return true end
Object.fields = {}
Object.__index = Object

function Object:initFields(o, fields) 
    for k,v in pairs(self.fields) do
        if fields[k] ~= nil then 
            o[k]=fields[k] 
        elseif type(v) == "table" then
            if v.isClass and v:isClass() then
                o[k]=v:new()
            else
                o[k]={}
            end
        else
            o[k]=v
        end
    end
end


function Object:new(fields)
    local o = {}
    Object:initFields(o, fields)
    return setmetatable(o, Object)
end

-- transform the table given in argument into a class. It also return the new class 
function newClass(table, super)

    table.__index = table
    table.super = super or Object
    setmetatable(table,table.super)
    
    -- the constructor of the new class
    function table:__call(fields)
        local o = table.super.__call(table, fields)
        Object.initFields(table, o, fields)
        setmetatable(o,table)
        if o.OnNew ~= nil then o:OnNew() end
        return o
    end

    return table
end

return Object

--variables for saftey check functions
mods_added = {MOD_NAME}
duplicate_ids = {}

--thanks google :)
function merge_tables(t1,t2)
    for i=1,#t2 do
       t1[#t1+1] = t2[i]
    end
    return t1
end

function get_seconds_passed()
    return seconds_passed
end


function safety_check_name(arg1)
    for _,v in pairs(mods_added) do --if this mod id has already called then we ignore it
        if v == arg1 then
            api_log(COMMAND_REGISTRY, "A mod tried to add commands with duplicate mod id")
            return false
        end
    end
    table.insert(mods_added, arg1) --let's remember this mod_id

    if type(arg1) ~= "string" then
        api_log(COMMAND_REGISTRY, "A mod tried to add commands but mod_id is not a string.")
        return false
    elseif #arg1 > 50 or #arg1 < 1 then --Just in case
        api_log(COMMAND_REGISTRY, "A mod tried to add commands but mod_id must be between 1-50 characters")
        return false
    end
 
    return true
end

function safety_check_list(arg1, arg2)
   if type(arg2) ~= "table" then
        api_log(COMMAND_REGISTRY, arg1 .. " Tried to add commands but commands_list is not a table!")
        return false
    else
        -- checks each data field is a string
        for i = 1,#arg2 do
            cur = arg2[i]
            if type(cur["command_name"]) ~= "string" then
                log_missing(arg1, #arg2, i, "name.")
                return false
            elseif type(cur["mod_id"]) ~= "string" then
                log_missing(arg1, #arg2, i, "mod_id")
                return false
            elseif type(cur["desc"]) ~= "string" then
                log_missing(arg1, #arg2, i, "description")
                return false
            elseif type(cur["parameters"]) ~= "string" then
                log_missing(arg1, #arg2, i, "parameters field")
                return false
            elseif type(cur["parameters_desc"]) ~= "string" then
                log_missing(arg1, #arg2, i, "parameters_desc field")
                return false
            end
        end
        for i = 1,#arg2 do
            -- then checks if any field is too long or missing incorrectly empty
            cur = arg2[i]
            if #cur["command_name"] > 50 or #cur["command_name"] < 2 then
                log_bad_characters(arg1, #arg2, i, "name")
                return false
            elseif #cur["mod_id"] > 50 or #cur["mod_id"] < 1 then
                log_bad_characters(arg1, #arg2, i, "mod_id")
                return false
            elseif #cur["desc"] > 300 or #cur["desc"] < 1 then
                log_bad_characters(arg1, #arg2, i, "description")
                return false
            elseif #cur["parameters"] > 100 then
                log_bad_characters(arg1, #arg2, i, "parameters")
                return false
            elseif #cur["parameters_desc"] > 300 then
                log_bad_characters(arg1, #arg2, i, "parameters description")
                return false
            end   
        end
    return true
    end
end

--shorthand functions for long api_logs
function log_missing(mod_id, command_count, command_number, arg)
    api_log(COMMAND_REGISTRY, mod_id .. " Tried to add " .. command_count .. " commands but command #" .. command_number .. " is missing a " .. arg)
end
function log_bad_characters(mod_id, command_count, command_number, arg)
    api_log(COMMAND_REGISTRY, mod_id .. " Tried to add " .. command_count .. " commands but command #" .. command_number .. "'s " .. arg .. " is too long or too short")
end
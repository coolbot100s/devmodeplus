-- Functions for all commands added by the mod.

-- seriously need to make this more readable. will put most of it in helpers.lua soon.
function help_command(args)
    if args[1] == nil then -- /help
        if #pages == 0 or pages == nil then --This will be irrelavent as soon i start adding commands oop
            api_log(HELP_STRING, "[]     Here's a list of commands!     []")
            for i = 1,combined_command_count do
                local cur = combined_command_list[i]
                api_log(HELP_STRING, cur["command_name"])
            end
            api_log(HELP_STRING, "[]Do /help {command} for more details![]")
        else                                            -- multible pages exist but no pg# given
            page_number = 1
            api_log(HELP_STRING, "[Pg." .. page_number .. " of " .. #pages .. "]  Here's a list of commands! Do /help {command} for more details. [Pg." .. page_number .. " of " .. #pages .. "]")
            for i = 1,PAGE_LIMIT do
                local cur = pages[page_number][i]
                api_log(HELP_STRING, cur["command_name"])
            end
            api_log(HELP_STRING, "[Pg." .. page_number .. " of " .. #pages .. "]  /help pg {#} to see other pages, /help verbose to see details of all commands. [Pg." .. page_number .. " of " .. #pages .. "]")
        end
    elseif args[1] == "pg" then -- /help {pg}
        if type(tonumber(args[2])) == "number" and tonumber(args[2]) > 0 and tonumber(args[2]) <= #pages then
            page_number = tonumber(args[2])
            api_log(HELP_STRING, "[Pg." .. page_number .. " of " .. #pages .. "]  Here's a list of commands! Do /help {command} for more details. [Pg." .. page_number .. " of " .. #pages .. "]")
            for i = 1,PAGE_LIMIT do
                local cur = pages[page_number][i]
                api_log(HELP_STRING, cur["command_name"])
            end
            api_log(HELP_STRING, "[Pg." .. page_number .. " of " .. #pages .. "]  /help pg {#} to see other pages, /help verbose to see details of all commands. [Pg." .. page_number .. " of " .. #pages .. "]")
        else
            api_log(HELP_STRING, "Page not found")
        end
    elseif args[1] == "verbose" then
        if type(tonumber(args[2])) ~= "number" then
            page_number = 1
            api_log(HELP_STRING, "[Pg." .. page_number .. " of " .. #verbose_pages .. "]  Here's details on the commands! [Pg." .. page_number .. " of " .. #verbose_pages .. "]")
            for i = 1,VERBOSE_PAGE_LIMIT do
                local cur = verbose_pages[page_number][i]
                api_log(HELP_STRING, "------------------------------------")
                api_log(HELP_STRING, cur["mod_id"] .. ": " .. cur["command_name"] .. " " .. cur["parameters"])
                api_log(HELP_STRING, "Description: " .. cur["desc"])
                if cur["parameters_desc"] ~= "" then
                    api_log(HELP_STRING, cur["parameters_desc"])
                end
            end
            api_log(HELP_STRING, "------------------------------------")
            api_log(HELP_STRING, "[Pg." .. page_number .. " of " .. #verbose_pages .. "]  /help verbose {#} to see other pages. [Pg." .. page_number .. " of " .. #verbose_pages .. "]")
        elseif tonumber(args[2]) > 0 and tonumber(args[2]) <= #verbose_pages then
            page_number = tonumber(args[2])
            api_log(HELP_STRING, "[Pg." .. page_number .. " of " .. #verbose_pages .. "]  Here's details on the commands! [Pg." .. page_number .. " of " .. #verbose_pages .. "]")
            for i = 1,VERBOSE_PAGE_LIMIT do
                local cur = verbose_pages[page_number][i]
                api_log(HELP_STRING, "------------------------------------")
                api_log(HELP_STRING, cur["mod_id"] .. ": " .. cur["command_name"] .. " " .. cur["parameters"])
                api_log(HELP_STRING, "Description: " .. cur["desc"])
                if cur["parameters_desc"] ~= "" then
                    api_log(HELP_STRING, cur["parameters_desc"])
                end
            end
            api_log(HELP_STRING, "------------------------------------")
            api_log(HELP_STRING, "[Pg." .. page_number .. " of " .. #verbose_pages .. "]  /help verbose {#} to see other pages. [Pg." .. page_number .. " of " .. #verbose_pages .. "]") -- for some reason doens't work when displaying the last verbose page??
        else
            api_log(HELP_STRING, "Page not found")
        end
    else
        for i = 1,combined_command_count do  -- /help {command}
            local cur = combined_command_list[i]
            if string.find(cur["command_name"], args[1], 2) then --search for arg1 in the combined_command_list
                api_log(HELP_STRING, "------------------------------------")
                api_log(HELP_STRING, cur["mod_id"] .. ": " .. cur["command_name"] .. " " .. cur["parameters"])
                api_log(HELP_STRING, "Description: " .. cur["desc"])
                if cur["parameters_desc"] ~= "" then
                    api_log(HELP_STRING, cur["parameters_desc"])
                end
                api_log(HELP_STRING, "------------------------------------")
                break
            end
            if i == combined_command_count then
                api_log(HELP_STRING, "Command not found, check your spelling! if this command exists but does not show up, than DevmodePlus was unable to register it. Report this to your mod author.")
            end
        end
    end
end

function echo_command(args)
    api_log("ECHO", table.concat(args, " "))
end

function time_passed_command()
    api_log("Secconds", get_seconds_passed())
end

-- this command will generate useful information later, for now it's just links.
function dmp_info_command()
    api_log("INFO", "DevmodePlus was created by coolbot! Find them at https://coolbot.carrd.co/ You can find more information at https://github.com/coolbot100s/devmodeplus ????")
end

function eval_command(args)
    local func, err = load("return " .. table.concat(args, " "))
    if func then
        local status, response = pcall(func)
        if status then
            api_log("Eval", response)
        else
            api_log("Eval", "Failed to Execute: " .. response)
        end
    else
        api_log("Eval", "Failed to Compile: " .. err)
    end
end
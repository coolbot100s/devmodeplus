function help_command(args)
    if args[1] == nil then -- /help
        api_log(HELP_STRING, "[]     Here's a list of commands!     []")
        for i = 1,combined_command_count do
            local cur = combined_command_list[i]
            api_log(HELP_STRING, cur["command_name"])
        end
        api_log(HELP_STRING, "[]Do /help {command} for more details![]")
    else
        for i = 1,combined_command_count do  -- /help {something}
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
                api_log(HELP_STRING, "Command not found")
            end
        end
    end
end

function echo_command(args)
    text = ""
    count = #args
    for i = 1,count do
        text = text .. " " .. args[i]
    end
    api_log("ECHO", text)
end

function time_passed_command()
    api_log("Secconds", get_seconds_passed())
end

function dmp_info_command()
    api_log("INFO", "DevmodePlus was created by coolbot! Find them at https://coolbot.carrd.co/ contact me to report bugs or if you're having issues adding your commands to the /help command 💜")
end
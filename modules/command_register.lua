--variables for api_log()
HELP_STRING = "HELP"
GENERIC_RESPONSE = "Response"
COMMAND_REGISTRY = "devmode_extentions"
VMID = "Apico"

--variables for seperating pages of commands when there's too many.
PAGE_LIMIT = 27
VERBOSE_PAGE_LIMIT = 10

pages = {}
verbose_pages = {}


-- list of vanilla commands that skip registration but need to be here for the /help command
vanilla_command_list = {
    {
        command_name = "/gimme",
        mod_id = VMID,
        desc = "gives an item based on the given oid",
        parameters = "{iod} {amount}",
        parameters_desc = "{oid} - oid ref from https://wiki.apico.buzz/wiki/OID_Reference, can also be a bee with 'bee.common' -- {amount} - optional amount, defaults to max"
    },
    {
        command_name = "/time",
        mod_id = VMID,
        desc = "sets the time of day",
        parameters = "{time}",
        parameters_desc = "{time} - can be 'day', 'night', 'dawn', 'dusk', 'dawnm', 'duskm'"
    },
    {
        command_name = "/weather",
        mod_id = VMID,
        desc = "sets the weater",
        parameters = "{toggle}",
        parameters_desc = "{toggle} - can be 'on' or 'off'"
    },
    {
        command_name = "/debug",
        mod_id = VMID,
        desc = "toggles debug mode. in debug mode you'll see the GM debug overlay and there's some additional key commands: In beehives/apiaries you can use CTRL to immediately finish the production meter, and ALT to immediately finish the lifespan meter. In barrels you can use ALT/CTRL to fill the barrel to max with whatever liquid is inside",
        parameters = "",
        parameters_desc = ""
    },
    {
        command_name = "/fps",
        mod_id = VMID,
        desc = "limits the number of frames (GM is capped at 60)",
        parameters = "{frames}",
        parameters_desc = "{frames} - number of frames"
    },
    {
        command_name = "/tp",
        mod_id = VMID,
        desc = "will teleport you to a player with the same name if found",
        parameters = "{name}",
        parameters_desc = "{name} - name or part of a name to find (case sensitive)"
    },
    {
        command_name = "/disco",
        mod_id = VMID,
        desc = "will trigger the discovery popup for a given species (sadly not a real disco boo)",
        parameters = "{species}",
        parameters_desc = "{species} - species api name, i.e. 'common'"
    },
    {
        command_name = "/devland",
        mod_id = VMID,
        desc = "will take you to the dev hideout (spoilers, obvs)",
        parameters = "",
        parameters_desc = ""
    },
    {
        command_name = "/bees",
        mod_id = VMID,
        desc = "will spawn 200 bee particles from the player position (its fun ok)",
        parameters = "",
        parameters_desc = ""
    },
    {
        command_name = "/door",
        mod_id = VMID,
        desc = "will trigger whether the hivemother door has been opened in this world or not (spoilers, obvs)",
        parameters = "{val}",
        parameters_desc = "{val} - either 1 or 0 (bool)"
    },
    {
        command_name = "/dream",
        mod_id = VMID,
        desc = "will take you to the hivemother's dream, triggering cutscene if you haven't been there yet (spoilers, obvs)",
        parameters = "",
        parameters_desc = ""
    },
    {
        command_name = "/ready",
        mod_id = VMID,
        desc = "will mark all quests as ready to hand in and discover all species (except hallowed/sacred/glitched)",
        parameters = "",
        parameters_desc = ""
    },
    {
        command_name = "/buff",
        mod_id = VMID,
        desc = "will buff the player with a given spice",
        parameters = "{spice}",
        parameters_desc = "{spice} - spice oid to use, i.e. 'spice1' for speed"
    }
}
vanilla_command_count = #vanilla_command_list

-- list of commands added by my mod that will be registered in bulk
command_list = {
    {
        command_name = "/help",
        command_script = "help_command",
        mod_id = MOD_NAME,
        desc = "Displays a list of commands, to see more info on each command type '/help {command_name}' to see a detailed list of ALL commands type '/help verbose'",
        parameters = "{command}",
        parameters_desc = "{command} - Input the name of a command to get details. leave blank to get a list of all commands."
    },
    {
        command_name = "/echo",
        command_script = "echo_command",
        mod_id = MOD_NAME,
        desc = "Any text entered as a parameter is repeated back in the console.",
        parameters = "{text}",
        parameters_desc = "{text} - can be any text you wish to have repeated back in the console"
    },
    {
        command_name = "/time_passed",
        command_script = "time_passed_command",
        mod_id = MOD_NAME,
        desc = "Logs time passed in seconds.",
        parameters = "",
        parameters_desc = ""
    },
    {
        command_name = "/dmp_info",
        command_script = "dmp_info_command",
        mod_id = MOD_NAME,
        desc = "Info about DevmodePlus",
        parameters = "",
        parameters_desc = ""
    }
}
command_count = #command_list

combined_command_list = merge_tables(command_list, vanilla_command_list)
combined_command_count = #combined_command_list

--Register my own commands with the api. called at init()
function register_commands()
    for i = 1,command_count do
        local cur = command_list[i]
        api_define_command(cur["command_name"], cur["command_script"])
    end
    update_pages()
    api_log(COMMAND_REGISTRY, "DevmodePlus Registered " .. command_count .. " new commands!")
end

-- creates lists of pages for /help and /help verbose
function update_pages()
    pages = {}
    if combined_command_count > PAGE_LIMIT then
        pages_added = 0
        for  i = 1,math.ceil(combined_command_count / PAGE_LIMIT)  do
            page = {}
            for _ = 1,PAGE_LIMIT do
                i = _ + pages_added * PAGE_LIMIT
                if i <= combined_command_count then
                    table.insert(page,combined_command_list[i])
                end -- I could but a break here to make it 0.00002ms faster ig TODO
            end
            pages_added = pages_added + 1
            table.insert(pages,page)
        end
    end
    verbose_pages()
    if combined_command_count > VERBOSE_PAGE_LIMIT then
        pages_added = 0
        for  i = 1,math.ceil(combined_command_count / VERBOSE_PAGE_LIMIT)  do
            page = {}
            for _ = 1,VERBOSE_PAGE_LIMIT do
                i = _ + pages_added * VERBOSE_PAGE_LIMIT
                if i <= combined_command_count then
                    table.insert(page,combined_command_list[i])
                end
            end
            pages_added = pages_added + 1
            table.insert(pages,page)
        end
    end
end


-- Called by other mods to add commands to /help. See below for how to use!
function add_my_commands(arg1, arg2)
    if safety_check_name(arg1) == true and safety_check_list(arg1, arg2) == true then --modules/helpers.lua
        combined_command_list = merge_tables(combined_command_list, arg2)
        combined_command_count = #combined_command_list
        update_pages()
        api_log(COMMAND_REGISTRY, arg1 .. " " .. "Added " .. #arg2 .. " commands! use /help for more info")
    end
end


--- EXAMPLE USAGE ---
-- Allow commands from your mods to show up in /help!
-- This does NOT register your commands with the api so you will need to do that first for your commands to work. https://wiki.apico.buzz/wiki/Modding_API#api_define_command()
-- Other functionality and more hooks planned soon :) contact me if you have questions https://coolbot.carrd.co/
-- NOTE: at this time the log can only display 30 lines at a time as such fields have size restrictions as to not take up too much real-estate.
--
--command_list = {                              -- Create a table containing your commands, it can be anything you like but should ONLY contain tables with the data for your commands.
--    {
--    command_name = "/tppos",                  -- Command name must be the same as the command name you registered (includeing the /) in order to be saearched correctly. must be between 2-50 characters.
--    mod_id = MOD_NAME,                        -- Should be the same as your mod_id, IN THE FUTURE this field will be optional but you may choose to include as an override, must be between 1-50 characters.
--    desc = "teleport to a set of x/y coords", -- Must be between 1-300 characters
--    parameters = "{x} {y}",                   -- must be less than 100 characters total.
--    parameters_desc = "{x} - x position to move to {y} - y position to move to"
--    }, 
--    {
--    command_name = "/ping",
--    mod_id = MOD_NAME,
--    desc = "replies with pong :)'",
--    parameters = "",                      -- All fields must be present for each command in the list, if a command does not have any parameters leave both fields blank like so.
--    parameters_desc = ""                  -- If 0 characters this field will not display (that's good!) must be less than 300 characters.
--    },
--
--}
--
--function catalog_my_commands_with_devmodeplus()          -- You can add any additional logic you like to this function or skip it and call devmodeplus directly but it's reccomended you follow the format below. You should call this function on ready() and after your commands are registered with the api.                             
--    if api_mod_exists("devmodeplus") then                -- check to see if devmodeplus is installed
--        api_mod_call("devmodeplus", "add_my_commands", {MOD_NAME, command_list} ) -- Then use the api to call the above function, passing in a name or id for your mod and list of commands which you want to be visible in /help
--    end
--end
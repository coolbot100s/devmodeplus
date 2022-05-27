--this is my mod_id
MOD_NAME = "devmodeplus"

-- checks for button function
disabled_on_load = false
turned_on = false

seconds_passed = 0

function register()
    return {
        name = MOD_NAME,
        hooks = {"clock"},
        modules = {"command_register", "commands", "helpers"}
    }    
end
function init()
    api_library_add_book("devmode_button", "toggle_devmode", "sprites/button.png")
    register_commands() --modules/command_register.lua
    return "Success"
end

-- Called by the devmode button when pressed
function toggle_devmode()
    if turned_on == false then
        api_set_devmode(true)
        turned_on = true
        api_log("dev_mode", "Enabled! use '/' to start typing commands. Use /help for a list of known commands!")
    else
        api_set_devmode(false)
        turned_on = false
        api_log("dev_mode", "Disabled!")
    end
end

function clock()
    -- Keep track of time :)
    seconds_passed = seconds_passed + 1

    -- Makes sure that devmode is disabled after the first game second so that the button can turn it off and on correctly.
    if disabled_on_load == false then
        api_set_devmode(false) -- If you want devmode to be on when you load up a new world without needing to press the button, change this to true (note that the button will lie when pressed)
        disabled_on_load = true
    end
end

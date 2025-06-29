-- url-input.lua
-- Simple and reliable URL input methods for mpv

local msg = require 'mp.msg'

-- Function to validate URL
function is_valid_url(str)
    if not str or str == "" then return false end
    
    local url_patterns = {
        "^https?://",
        "^ftp://",
        "^ftps://",
        "youtube%.com/",
        "youtu%.be/",
        "twitch%.tv/",
        "vimeo%.com/",
        "dailymotion%.com/",
        "reddit%.com/",
        "streamable%.com/",
        "imgur%.com/"
    }
    
    for _, pattern in ipairs(url_patterns) do
        if str:match(pattern) then
            return true
        end
    end
    
    return false
end

-- Function to show console input instructions
function open_url_console()
    mp.osd_message("Console URL Input:", 1)
    mp.add_timeout(1, function()
        mp.osd_message("1. Press ` (backtick) to open console", 3)
    end)
    mp.add_timeout(4, function()
        mp.osd_message("2. Type: script-message play-url <URL>", 3)
    end)
    mp.add_timeout(7, function()
        mp.osd_message("Example: script-message play-url https://youtube.com/watch?v=VIDEO_ID", 4)
    end)
    
    msg.info("=== URL INPUT INSTRUCTIONS ===")
    msg.info("1. Press ` (backtick) to open console")
    msg.info("2. Type: script-message play-url <your_url>")
    msg.info("3. Press Enter")
    msg.info("Example: script-message play-url https://www.youtube.com/watch?v=QpaqXo_hFIo")
end

-- Function to play URL from script message
function play_url_from_message(url)
    if not url or url == "" then
        mp.osd_message("Error: No URL provided", 3)
        msg.warn("No URL provided to play-url command")
        return
    end
    
    -- Clean up URL (remove quotes, whitespace)
    url = url:gsub("^%s*['\"]?", ""):gsub("['\"]?%s*$", "")
    
    if not is_valid_url(url) then
        mp.osd_message("Error: Invalid URL format", 3)
        msg.warn("Invalid URL: " .. url)
        return
    end
    
    mp.osd_message("Loading: " .. url:sub(1, 50) .. (url:len() > 50 and "..." or ""), 2)
    msg.info("Loading URL: " .. url)
    mp.commandv("loadfile", url, "replace")
end

-- Function to add URL to playlist
function add_url_to_playlist(url)
    if not url or url == "" then
        mp.osd_message("Error: No URL provided", 3)
        return
    end
    
    url = url:gsub("^%s*['\"]?", ""):gsub("['\"]?%s*$", "")
    
    if not is_valid_url(url) then
        mp.osd_message("Error: Invalid URL format", 3)
        return
    end
    
    mp.osd_message("Added to playlist: " .. url:sub(1, 40) .. (url:len() > 40 and "..." or ""), 2)
    msg.info("Adding to playlist: " .. url)
    mp.commandv("loadfile", url, "append-play")
end

-- Register script messages
mp.register_script_message("play-url", play_url_from_message)
mp.register_script_message("add-url", add_url_to_playlist)

-- Key binding for showing instructions
mp.add_key_binding("ctrl+o", "open-url-console", open_url_console)

msg.info("URL input script loaded successfully!")
msg.info("Usage:")
msg.info("  - Press Ctrl+O for instructions")
msg.info("  - Console: script-message play-url <URL>")
msg.info("  - Console: script-message add-url <URL> (for playlist)")
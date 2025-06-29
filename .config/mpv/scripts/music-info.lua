-- music-info.lua
-- Enhanced music information display for mpv

local msg = require 'mp.msg'

-- Function to get formatted track info
function get_track_info()
    local metadata = mp.get_property_native("metadata") or {}
    local filename = mp.get_property("filename") or "Unknown"
    local duration = mp.get_property("duration")
    local position = mp.get_property("time-pos")
    
    -- Extract metadata with fallbacks
    local title = metadata.title or metadata.TITLE or filename:gsub("%.%w+$", "")
    local artist = metadata.artist or metadata.ARTIST or "Unknown Artist"
    local album = metadata.album or metadata.ALBUM or "Unknown Album"
    local date = metadata.date or metadata.DATE or metadata.year or metadata.YEAR or ""
    local track = metadata.track or metadata.TRACK or ""
    local genre = metadata.genre or metadata.GENRE or ""
    
    -- Format duration and position
    local duration_str = duration and mp.format_time(duration) or "Unknown"
    local position_str = position and mp.format_time(position) or "0:00"
    
    -- Build info string
    local info = "♪ Now Playing:\n\n"
    info = info .. "Title: " .. title .. "\n"
    info = info .. "Artist: " .. artist .. "\n"
    info = info .. "Album: " .. album .. "\n"
    
    if date ~= "" then
        info = info .. "Year: " .. date .. "\n"
    end
    
    if track ~= "" then
        info = info .. "Track: " .. track .. "\n"
    end
    
    if genre ~= "" then
        info = info .. "Genre: " .. genre .. "\n"
    end
    
    info = info .. "\nTime: " .. position_str .. " / " .. duration_str .. "\n"
    
    -- Playlist info
    local playlist_count = mp.get_property_number("playlist-count", 0)
    local playlist_pos = mp.get_property_number("playlist-pos", 0)
    
    if playlist_count > 1 then
        info = info .. "Track: " .. (playlist_pos + 1) .. " of " .. playlist_count .. "\n"
    end
    
    -- Audio info
    local audio_codec = mp.get_property("audio-codec-name") or ""
    local audio_bitrate = mp.get_property("audio-bitrate")
    local audio_samplerate = mp.get_property("audio-params/samplerate")
    
    if audio_codec ~= "" then
        info = info .. "\nFormat: " .. audio_codec:upper()
        if audio_bitrate then
            info = info .. " @ " .. math.floor(audio_bitrate/1000) .. " kbps"
        end
        if audio_samplerate then
            info = info .. " / " .. audio_samplerate .. " Hz"
        end
    end
    
    return info
end

-- Function to show track info
function show_track_info()
    local info = get_track_info()
    mp.osd_message(info, 5)
end

-- Function to show minimal track info
function show_minimal_info()
    local metadata = mp.get_property_native("metadata") or {}
    local filename = mp.get_property("filename") or "Unknown"
    
    local title = metadata.title or metadata.TITLE or filename:gsub("%.%w+$", "")
    local artist = metadata.artist or metadata.ARTIST or "Unknown Artist"
    
    local info = "♪ " .. artist .. " - " .. title
    mp.osd_message(info, 3)
end

-- Function to show playlist info
function show_playlist_info()
    local playlist_count = mp.get_property_number("playlist-count", 0)
    local playlist_pos = mp.get_property_number("playlist-pos", 0)
    
    if playlist_count <= 1 then
        mp.osd_message("No playlist", 2)
        return
    end
    
    local info = "Playlist: " .. (playlist_pos + 1) .. " / " .. playlist_count .. "\n\n"
    
    -- Show current and next few tracks
    local playlist = mp.get_property_native("playlist", {})
    local start = math.max(0, playlist_pos - 2)
    local end_pos = math.min(playlist_count - 1, playlist_pos + 5)
    
    for i = start, end_pos do
        local entry = playlist[i + 1] -- Lua is 1-indexed
        if entry then
            local marker = (i == playlist_pos) and "► " or "  "
            local title = entry.title or entry.filename:gsub("%.%w+$", "")
            info = info .. marker .. (i + 1) .. ". " .. title .. "\n"
        end
    end
    
    mp.osd_message(info, 5)
end

-- Auto-show track info on track change
function on_track_change()
    mp.add_timeout(0.5, show_minimal_info)
end

-- Key bindings
mp.add_key_binding("t", "show-track-info", show_track_info)
mp.add_key_binding("T", "show-minimal-info", show_minimal_info)
mp.add_key_binding("shift+p", "show-playlist-info", show_playlist_info)

-- Auto-show on track change
mp.observe_property("playlist-pos", "number", on_track_change)

msg.info("Music info script loaded!")
msg.info("Controls: T (minimal info), Shift+T (full info), Shift+P (playlist)")
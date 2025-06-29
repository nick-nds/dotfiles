-- visualizer.lua
-- Audio visualizer for mpv music player

local msg = require 'mp.msg'

-- Visualizer state
local visualizer_enabled = false
local current_visualizer = "showcqt"

-- Available visualizers
local visualizers = {
    showcqt = {
        name = "CQT Spectrum",
        filter = "lavfi=[aformat=channel_layouts=stereo,showcqt=s=1280x720:fps=30:sono_v=17:bar_v=2]"
    },
    showspectrum = {
        name = "Spectrum",
        filter = "lavfi=[aformat=channel_layouts=stereo,showspectrum=s=1280x720:fps=30:slide=scroll:mode=combined:color=rainbow]"
    },
    showwaves = {
        name = "Waveform",
        filter = "lavfi=[aformat=channel_layouts=stereo,showwaves=s=1280x720:fps=30:mode=cline:colors=cyan|magenta]"
    },
    avectorscope = {
        name = "Vector Scope",
        filter = "lavfi=[aformat=channel_layouts=stereo,avectorscope=s=1280x720:fps=30:draw=dot:scale=cbrt]"
    },
    showfreqs = {
        name = "Frequency",
        filter = "lavfi=[aformat=channel_layouts=stereo,showfreqs=s=1280x720:fps=30:mode=bar:cmode=combined]"
    }
}

-- Function to toggle visualizer
function toggle_visualizer()
    if visualizer_enabled then
        disable_visualizer()
    else
        enable_visualizer()
    end
end

-- Function to enable visualizer
function enable_visualizer()
    if not mp.get_property("video") or mp.get_property("video") == "no" then
        local filter = visualizers[current_visualizer].filter
        mp.command("vf add " .. filter)
        visualizer_enabled = true
        mp.osd_message("Visualizer: " .. visualizers[current_visualizer].name .. " ON", 2)
        msg.info("Enabled visualizer: " .. visualizers[current_visualizer].name)
    else
        mp.osd_message("Visualizer only works with audio files", 2)
    end
end

-- Function to disable visualizer
function disable_visualizer()
    mp.command("vf clr")
    visualizer_enabled = false
    mp.osd_message("Visualizer OFF", 2)
    msg.info("Disabled visualizer")
end

-- Function to cycle through visualizers
function cycle_visualizer()
    local visualizer_names = {}
    for name, _ in pairs(visualizers) do
        table.insert(visualizer_names, name)
    end
    table.sort(visualizer_names)
    
    local current_index = 1
    for i, name in ipairs(visualizer_names) do
        if name == current_visualizer then
            current_index = i
            break
        end
    end
    
    current_index = current_index % #visualizer_names + 1
    current_visualizer = visualizer_names[current_index]
    
    if visualizer_enabled then
        disable_visualizer()
        enable_visualizer()
    else
        mp.osd_message("Next visualizer: " .. visualizers[current_visualizer].name, 2)
    end
end

-- Function to show visualizer info
function show_visualizer_info()
    local status = visualizer_enabled and "ON" or "OFF"
    local info = "Visualizer: " .. status .. "\n"
    info = info .. "Current: " .. visualizers[current_visualizer].name .. "\n\n"
    info = info .. "Available visualizers:\n"
    
    for name, data in pairs(visualizers) do
        local marker = (name == current_visualizer) and "● " or "○ "
        info = info .. marker .. data.name .. "\n"
    end
    
    info = info .. "\nControls:\n"
    info = info .. "V - Toggle visualizer\n"
    info = info .. "Shift+V - Cycle visualizers\n"
    info = info .. "Ctrl+V - Show this info"
    
    mp.osd_message(info, 5)
end

-- Auto-enable visualizer for audio files
function auto_enable_visualizer()
    -- Check if this is an audio-only file
    mp.add_timeout(1, function()
        if not mp.get_property("video") or mp.get_property("video") == "no" then
            local filename = mp.get_property("filename") or ""
            local audio_extensions = {".mp3", ".flac", ".wav", ".ogg", ".m4a", ".aac", ".opus", ".wma"}
            
            for _, ext in ipairs(audio_extensions) do
                if filename:lower():match(ext .. "$") then
                    enable_visualizer()
                    break
                end
            end
        end
    end)
end

-- Key bindings
mp.add_key_binding("v", "toggle-visualizer", toggle_visualizer)
mp.add_key_binding("V", "cycle-visualizer", cycle_visualizer)
mp.add_key_binding("ctrl+v", "visualizer-info", show_visualizer_info)

-- Auto-enable for audio files
mp.register_event("file-loaded", auto_enable_visualizer)

msg.info("Audio visualizer loaded!")
msg.info("Controls: V (toggle), Shift+V (cycle), Ctrl+V (info)")
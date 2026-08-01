return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- use latest release, remove to use latest commit
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false, -- this will be removed in 4.0.0
    notes_subdir = "0 Inbox",
    new_notes_location = "notes_subdir",
    attachments = {
      folder = "attachments",
    },
    templates = {
      folder = "Templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      substitutions = {}
    },
    workspaces = {
      {
        name = "personal",
        path = "~/ObsidianNotes",
      }
    },
    -- Optional, customize how note IDs are generated given an optional title.
    ---@param title string|?
    ---@return string
    note_id_func = function(title)
      -- Create note IDs in a clean format. If title is given, use it as the ID.
      -- If title is nil, use the timestamp.
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        -- If title is nil, just use the timestamp.
        return tostring(os.time())
      end
    end,
  },
}

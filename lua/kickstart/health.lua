--[[
--
-- This file is not required for your own configuration,
-- but helps people determine if their system is setup correctly.
--
--]]

local check_version = function()
  local verstr = tostring(now.version())
  if not now.version.ge then
    now.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
    return
  end

  if now.version.ge(now.version(), '0.10-dev') then
    now.health.ok(string.format("Neovim version is: '%s'", verstr))
  else
    now.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
  end
end

local check_external_reqs = function()
  -- Basic utils: `git`, `make`, `unzip`
  for _, exe in ipairs { 'git', 'make', 'unzip', 'rg' } do
    local is_executable = now.fn.executable(exe) == 1
    if is_executable then
      now.health.ok(string.format("Found executable: '%s'", exe))
    else
      now.health.warn(string.format("Could not find executable: '%s'", exe))
    end
  end

  return true
end

return {
  check = function()
    now.health.start 'kickstart.nvim'

    now.health.info [[NOTE: Not every warning is a 'must-fix' in `:checkhealth`

  Fix only warnings for plugins and languages you intend to use.
    Mason will give warnings for languages that are not installed.
    You do not need to install, unless you want to use those languages!]]

    local uv = now.uv or now.loop
    now.health.info('System Information: ' .. now.inspect(uv.os_uname()))

    check_version()
    check_external_reqs()
  end,
}

#!lua
--
-- Copyright (C) 2009  Jordan Uggla
-- Copyright (C) 2009  Free Software Foundation, Inc.
--
-- GRUB is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- GRUB is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with GRUB.  If not, see <http://www.gnu.org/licenses/>.
--

-- Attempts to find, and add menu entries to load, any grub.cfg files

function add_entry( device, fs, uuid )
  local root = "(" .. device .. ")"
  local cfg_path

  local prefix = grub.getenv("prefix")
  if prefix:find( root ) then --We are at the device super grub disk is on
    return --Don't add a recursive menu entry
  end

  if grub.file_exist( root .. "/boot/grub/grub.cfg" ) then
    cfg_path = root .. "/boot/grub/grub.cfg"
  elseif grub.file_exist( root .. "/grub/grub.cfg" ) then
    cfg_path = root .. "/grub/grub.cfg"
  else
    return
  end

  local issue
  if grub.file_exist( root .. "/etc/issue" ) then
    local issue_file = grub.file_open( root .. "/etc/issue" )
    issue = grub.file_getline( issue_file )

    if grub.file_exist( "/etc/hostname" ) then
      local hostname_file = grub.file_open( root .. "/etc/hostname" )
      local hostname = grub.file_getline( hostname_file )

      --Replace "\n" in issue with the actual hostname
      issue = issue:gsub( "\\n" , hostname )
    end

    issue = issue:gsub( "\\." , "" ) --Remove any remaining escape sequences
  end

  if issue then
    title = "Load grub.cfg from " .. issue .. " (device " .. root .. ")"
  else
    title = "Load grub.cfg from " .. root
  end
  
  --Some commands, like save_env, require that $prefix be set properly
  local new_prefix = cfg_path:gsub( "/grub.cfg$" , "" )

  local command_list = "prefix=" .. new_prefix ..
                       "\nexport prefix" ..
                       "\nconfigfile " .. cfg_path

  grub.add_menu( command_list , title )
end

grub.enum_device( add_entry )

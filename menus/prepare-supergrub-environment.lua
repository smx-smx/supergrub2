#!lua
-- This file is part of Super GRUB2 Disk.
--
-- Copyright (C) 2010 Jordan Uggla
--
-- Super GRUB Disk is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- Super GRUB Disk is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with Super GRUB Disk.  If not, see <http://www.gnu.org/licenses/>.
--

-- Prepare envoronment variables needed by some of the scripts

prefix = grub.getenv("prefix")
prefix_device, prefix_path = prefix:match("^%((.-)%)(.*)")
grub.setenv("prefix_path", prefix_path)
grub.setenv("prefix_device", prefix_device)
grub.run("probe --fs-uuid --set=prefix_uuid $prefix_device")
script_path = prefix_path:match("^.*grub") --Strip architecture
grub.setenv("script_path", script_path)
script_prefix = "(" .. prefix_device .. ")" .. script_path
grub.setenv("script_prefix", script_prefix)


for i,var in pairs( { "prefix_device","prefix_uuid","prefix_path","script_path",
                      "script_prefix" } ) do
  grub.run("export " .. var)
end

#!lua

isofolder = grub.getenv ("isofolder")
if (isofolder == nil) then
  isofolder = "/boot/isos"
end

function enum_file (name)
  local title = string.match (name, "(.*)%.[iI][sS][oO]")

  if (title) then
    local source = "set isofile=" .. isofolder .. "/" .. name ..
      "\nsource /boot/grub/bootiso.lua"

    grub.add_menu (source, title)
  end
end

grub.enum_file (enum_file, isofolder)

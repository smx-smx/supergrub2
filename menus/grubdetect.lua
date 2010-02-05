#!lua

function add_entry( device, fs, uuid )
  local root = "(" .. device .. ")"
  local multiboot_kernel

  if grub.file_exist( root .. "/multiboot.img" ) then
    multiboot_kernel = "/multiboot.img"
  elseif grub.file_exist( root .. "/boot/multiboot.img" ) then
    multiboot_kernel = "/boot/multiboot.img"
  elseif grub.file_exist( root .. "/grub/core.img" ) then
    multiboot_kernel = "/grub/core.img"
  elseif grub.file_exist( root .. "/boot/grub/core.img" ) then
    multiboot_kernel = "/boot/grub/core.img"
  else
    return
  end

  local command = "set root=" .. root .. "\nmultiboot " .. multiboot_kernel
  local title = "Load " .. multiboot_kernel .. " from " .. root

  grub.add_menu( command, title )
end

grub.enum_device( add_entry )

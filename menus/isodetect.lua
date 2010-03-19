#!lua

-- Detects the live system type and boots it
function iso_entry (isofile, langcode)
  if not mount_iso (isofile) then
    return false
  end
  if not langcode then
    langcode = "us"
  end
  local basename = basename (isofile)
  local loop_device = "(" .. basename .. ")"
  -- grml
  if (dir_exist (loop_device .. "/boot/grml")) then
    linux_entry (
      isofile,
      loop_device .. "/boot/grml/linux26", 
      loop_device .. "/boot/grml/initrd.gz",
      "findiso=" .. isofile .. " apm=power-off quiet boot=live nomce"
    )
  -- Parted Magic
  elseif (dir_exist (loop_device .. "/pmagic")) then
    linux_entry (
      isofile,
      loop_device .. "/pmagic/bzImage", 
      loop_device .. "/pmagic/initramfs",
      "iso_filename=" .. isofile .. 
        " edd=off noapic load_ramdisk=1 prompt_ramdisk=0 rw" .. 
        " sleep=10 loglevel=0 keymap=" .. langcode
    )
  -- Sidux
  elseif (dir_exist (loop_device .. "/sidux")) then
    linux_entry (
      isofile,
      find_file (loop_device .. "/boot", "vmlinuz%-.*%-sidux%-.*"), 
      find_file (loop_device .. "/boot", "initrd%.img%-.*%-sidux%-.*"),
      "fromiso=" .. isofile .. " boot=fll quiet"
    )
  -- Slax
  elseif (dir_exist (loop_device .. "/slax")) then
    linux_entry (
      isofile,
      loop_device .. "/boot/vmlinuz", 
      loop_device .. "/boot/initrd.gz",
      "from=" .. isofile .. " ramdisk_size=6666 root=/dev/ram0 rw"
    )
  -- Tinycore
  elseif (grub.file_exist (loop_device .. "/boot/tinycore.gz")) then
    linux_entry (
      isofile,
      loop_device .. "/boot/bzImage", 
      loop_device .. "/boot/tinycore.gz"
    )
  -- Ubuntu and Casper based Distros
  elseif (dir_exist (loop_device .. "/casper")) then
    linux_entry (
      isofile,
      loop_device .. "/casper/vmlinuz", 
      find_file (loop_device .. "/casper", "initrd%..z"),
      "boot=casper iso-scan/filename=" .. isofile .. 
        " quiet splash noprompt" .. 
        " keyb=" .. langcode .. 
        " debian-installer/language=" .. langcode .. 
        " console-setup/layoutcode?=" .. langcode .. 
        " --"
    )
  else
    error_entry (isofile, "Unsupported ISO type")
  end
end

-- Help function to get just the filename from a path
function basename (path)
  return path:match (".*/(.-)$")
end

-- Help function to show an error
function error_entry (isofile, msg)
  local title = isofile .. " Is not supported."

  local full_msg =
  "Error: " .. msg .. "\n\\nThe iso file " .. isofile .. " is not supported " ..
  "by Super GRUB2 disk. The most likely reason is that the iso is not loop " ..
  "bootable. An iso must be specifically designed to read its root " ..
  "filesystem from an iso file rather than looking for it in your CDROM " ..
  "drive. It is impossible to boot an iso file not specifically designed " ..
  "this way with GRUB or any other bootloader\n\\n" ..
  "If you believe that this iso file is loop bootable it is mounted as " ..
  "(" .. basename (isofile) .. ") so you can view its contents in the " ..
  "grub shell and try to boot it yourself. If there are any distributions " ..
  "that you know are loop bootable but are not currently supported by this " ..
  "script please check that you are using the latest version of Super GRUB2 " ..
  "Disk then send the commands required to boot the iso to " ..
  "supergrub-english@lists.berlios.de so support can be added."

  local commands = 'echo -e "' .. full_msg .. '"\nread'

  grub.add_menu (commands, title)
end

-- Help function to search for a file
function find_file (folder, match)
  local filename

  local function enum_file (name)
    if (filename == nil) then
      filename = string.match (name, match)
    end
  end

  grub.enum_file (enum_file, folder)

  if (filename) then
    return folder .. "/" .. filename
  else
    return nil
  end
end

-- Help function to check if a directory exist
function dir_exist (dir)
  return (grub.run("test -d '" .. dir .. "'") == 0)
end

-- Adds a menu entry for a GNU/Linux live system
function linux_entry (isofile, linux, initrd, params)
  local commands = ""
  local title = "Boot " .. isofile
  if (linux and grub.file_exist (linux)) then
    if (initrd and grub.file_exist (initrd)) then
      if (params) then
        commands = commands .. "linux " .. linux .. " " .. params .. "\n"
      else
        commands = commands .. "linux " .. linux .. "\n"
      end
      commands = commands .. "initrd " .. initrd .. "\n"
    else
      error_entry (isofile, "cannot find initrd file '" .. initrd .. "'")
    end
    grub.add_menu (commands, title)
  else
    error_entry (isofile, "cannot find linux file '" .. initrd .. "'")
  end
end

-- Mounts the iso file
function mount_iso (isofile)
  local result = false

  if (isofile == nil) then
    error_entry (isofile, "variable 'isofile' is undefined")
  elseif (not grub.file_exist (isofile)) then
    error_entry (isofile, "Cannot find isofile '" .. isofile .. "'")
  else
    local basename = basename (isofile)
    local err_no, err_msg = grub.run ("loopback " .. basename .. " " .. isofile)
    if (err_no ~= 0) then
      error_entry (isofile, "Cannot load ISO: " .. err_msg)
    else
      result = true
    end
  end

  return result
end

langcode = grub.getenv("lang")
isofolder = grub.getenv("isofolder")
if (isofolder == nil) then
  isofolder = "/boot/isos"
end

function enum_file (name)

  if string.find (name, ".*%.[iI][sS][oO]") then
    local isofile = isofolder .. "/" .. name
    iso_entry (isofile, langcode)
  end
end

grub.enum_file (enum_file, isofolder)

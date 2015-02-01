#!/bin/bash

# Grub2 Build for Super Grub2 Disk - Install all grub releases

SG2D_DIR="$(pwd)"

source grub-build-config


# Check if configure script exists or not.
# If anyone of them does not exist exit with an error.

for n_build_dir in "${!SG2D_GRUB_BUILD_DIRS_ARR[@]}"; do

	if [ ! -x "${SG2D_GRUB_BUILD_DIRS_ARR[n_build_dir]}/configure" ] ; then
		echo -e -n "Install all grub releases refuses to continue\n" 1>&2 ;
		echo -e -n "'${SG2D_GRUB_BUILD_DIRS_ARR[n_build_dir]}/configure' does not exist\n" 1>&2 ;
		echo -e -n "Have you run: ./grub-build-001-prepare-build.sh ?\n" 1>&2 ;
		echo -e -n "and: ./grub-build-002-clean-and-update.sh ?\n" 1>&2 ;
		echo -e -n "and: ./grub-build-003-build-all.sh ?\n" 1>&2 ;
		exit 2
	fi

done

cd "${SG2D_GRUB_BUILD_PREFIX}"

for n_build_dir in "${!SG2D_GRUB_BUILD_DIRS_ARR[@]}"; do
	cd "${SG2D_GRUB_BUILD_DIRS_ARR[n_build_dir]}"
	if make install > "${SG2D_GRUB_LOG_PREFIX}_make_install.log" 2>&1 ; then
		echo -e -n "make install run OK on: ${SG2D_GRUB_BUILD_DIRS_ARR[n_build_dir]}\n"
	else
		echo -e -n "make install had a PROBLEM on: ${SG2D_GRUB_BUILD_DIRS_ARR[n_build_dir]}\n" 1>&2
		echo -e -n "You can check its log: ${SG2D_GRUB_LOG_PREFIX}_make_install.log\n" 1>&2
		echo -e -n "Skipping to next installation if applicable\n" 1>&2
	fi

done



cd "${SG2D_DIR}"


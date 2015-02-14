#!/bin/bash

# Grub2 Build for Super Grub2 Disk - Prepare build dir

SG2D_DIR="$(pwd)"
TMP_GRUB2_GIT_CLONE_DIR="${SG2D_DIR}/tmp_grub2_clone_dir"

# Git check

if git --version > /dev/null 2>&1 ; then
	:
else
	echo -e -n "Git was not found. Git is needed\n";
	echo -e -n "Aborting\n";
	exit 3

fi

source grub-build-config

# Check if build directories exists or not.
# If anyone of them exists exit with an error.

for n_build_dir in "${!SG2D_GRUB_BUILD_DIRS_ARR[@]}"; do

	if [ -d "${SG2D_GRUB_BUILD_DIRS_ARR[n_build_dir]}" ] ; then
		echo -e -n "Prepare build refuses to continue\n";
		echo -e -n "'${SG2D_GRUB_BUILD_DIRS_ARR[n_build_dir]}' already exists\n";
		exit 2
	fi

done


# Temp directory for cloning grub repo
if [ -d "${TMP_GRUB2_GIT_CLONE_DIR}" ] ; then
	rm -rf "${TMP_GRUB2_GIT_CLONE_DIR}"
fi

mkdir "${TMP_GRUB2_GIT_CLONE_DIR}"
git clone "${GIT_REPO}" "${TMP_GRUB2_GIT_CLONE_DIR}"
cd "${TMP_GRUB2_GIT_CLONE_DIR}"
git checkout "${GRUB2_COMMIT}"
cd "${SG2D_DIR}"

# Fill build directories with fetched git clone
mkdir --parents "${SG2D_GRUB_BUILD_PREFIX}"
for n_build_dir in "${!SG2D_GRUB_BUILD_DIRS_ARR[@]}"; do
	if cp -a "${TMP_GRUB2_GIT_CLONE_DIR}" "${SG2D_GRUB_BUILD_DIRS_ARR[n_build_dir]}" ; then
		:
	else
		echo -e -n "Something went wrong when running:\n"
		echo -e -n "cp -a '${TMP_GRUB2_GIT_CLONE_DIR}' '${SG2D_GRUB_BUILD_DIRS_ARR[n_build_dir]}'\n"
		echo -e -n "Aborting\n"
		exit 4
	fi
done

# Remove tmp grub2 git clone directory

rm -rf "${TMP_GRUB2_GIT_CLONE_DIR}"


cd "${SG2D_DIR}"
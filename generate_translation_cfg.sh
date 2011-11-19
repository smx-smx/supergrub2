#!/bin/bash

TRANSLATIONS_DIRECTORY="translations"
TRANSLATION_CFG_DIRECTORY="menus"
TRANSLATION_CFG_FILE="language.cfg"
TRANSLATION_CFG_PATH=${TRANSLATION_CFG_DIRECTORY}/${TRANSLATION_CFG_FILE}
TRANSLATION_CFG_ENTRY_HEADER_PATH="language_template_entry_header.cfg"
TRANSLATION_CFG_ENTRY_FOOTER_PATH="language_template_entry_footer.cfg"
TRANSLATIONS_EXPORT_CFG_PATH="translations_export.cfg"

for n_trans_dir in ${TRANSLATIONS_DIRECTORY}/* ; do
  n_trans_dir_useful=`basename ${n_trans_dir}`
  source ${n_trans_dir}/${n_trans_dir_useful}.sh
  source ${TRANSLATION_CFG_ENTRY_HEADER_PATH}
  cat ${n_trans_dir}/${n_trans_dir_useful}.cfg
  cat ${TRANSLATIONS_EXPORT_CFG_PATH}
  cat ${TRANSLATION_CFG_ENTRY_FOOTER_PATH}
  
done > ${TRANSLATION_CFG_PATH}
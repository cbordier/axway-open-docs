#!/bin/bash
#
# Description:
#   This script is used to update the develop branch name!
#

SCRIPT_DIR=`dirname $0`
NEW_BRANCH_NAME=$1
OLD_BRANCH_NAME=$2
PROJECT_ROOT=$(cd ${SCRIPT_DIR}/..;pwd)

FILES=(
    ".github/workflows/ciworkflow.yml"
    ".github/workflows/merge_to_develop.yml"
    "layouts/partials/page-meta-links.html"
    "static/admin/config.js"
    )

if [[ -z "${NEW_BRANCH_NAME}" ]];then
    echo "[ERROR] Please use the new dev branch name as an argument to the script."
    echo "[ERROR] e.g. bash update_dev_branch_name.sh developmar21"
    exit 1
else
    # this is assuming the first file in the array is the ciworkflow.yml file
    OLD_BRANCH_NAME=`cat ${PROJECT_ROOT}/${FILES[0]}| grep branches | tail -n 1 | sed -e "s| ||g" | sed -e "s|.*,\(.*\)]|\1|g"`
    if [[ -z "${OLD_BRANCH_NAME}" ]];then
        echo "[ERROR] Failed to determine the current dev branch name!"
        exit 1
    fi
    echo "[INFO] Changing dev branch name from [${OLD_BRANCH_NAME}] to [${NEW_BRANCH_NAME}]!"
    #sleep 5
fi

for file in ${FILES[@]};do
    if [[ -f "${PROJECT_ROOT}/${file}" ]];then
        echo "[INFO] Updating [${file}] ..."
        sed -i "s|${OLD_BRANCH_NAME}|${NEW_BRANCH_NAME}|g" ${PROJECT_ROOT}/${file}
    else
        echo "[WARN] Skipping [${file}]!"
    fi
done

echo "[INFO]"
echo "[INFO] Remember to verify the changes before committing!!"

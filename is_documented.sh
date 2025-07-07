#! /bin/bash
# Script_name     : is_documented.sh
# Author          : Intro_SW
# Description     : Apply doxygen checks for current file
# Version         : v0.2

# Current checks and filters:
# - filename supplied in the \file statement does not exists (analysis stopped)
# - function is not documented (main is filtered)
# - return type is not documented
# - parameters are not documented
# - found unknown command warning is filtered (e.g., @ in email)
# - macro definition warning is filtered (e.g., constants)


set -e            # Exit immediately if a command exits with a non-zero status, care with grep
# Main
: ${1?"Usage: $0 C_FILE"}
#  Script exits here if command-line parameter absent, with following error message.

# Error handling
C_FILE="$1"
if [ ! -f ${C_FILE} ]; then
    echo "File ${C_FILE} not found! Aborting..."
    exit 1
fi

# Check extension...
if [ "${C_FILE: -2}" != ".c" ]; then
    echo "No C extension in $C_FILE. Aborting..."
    exit 1
fi

# LOCAL VARS
CMD="/usr/local/bin/is-documented/doxygen"
FLAGS="/usr/local/bin/is-documented/config.cfg"
IS_OK=true

# Array of prefixes for easy processing
PREFIXES=("" "" "" "" "" "")
if [ "$2" = "prefix" ]; then
   PREFIXES=("FILE:" "FUNCTION:" "PARAMS:" "RETURN:" "HEADER:" "TODO: ")
fi

# Change file to process in config file via ENV VAR
export IS_INPUT_FILE=${C_FILE}

RESULT=$($CMD $FLAGS 2>&1)
#~ echo "$RESULT"

# Coloured output
RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

# Check there is standard doxygen header from template: @file, @version, @author (@brief can be in functions)
FOUND=$(grep -e "@file" -e "@version" -e "@author"  ${C_FILE}) || true
if [ -z "$FOUND" ]; then
      IS_OK=false
      echo ""
      echo -ne "${RED}==> ${PREFIXES[4]} File comments are not present in ${C_FILE}${ENDCOLOR} "
      echo "(Have you used the provided template?) Aborting..."
      exit 1
fi

FOUND=$(grep "@brief TODO" ${C_FILE}) || true
if [ -n "$FOUND" ]; then
      IS_OK=false
      echo ""
      echo -e "${RED}==> The following file comments should be completed in ${C_FILE}${ENDCOLOR}"
      echo "    ${PREFIXES[5]}TODO detected in the general brief"
fi

# filename supplied in the \file statement does not exists (analysis stopped)
FOUND=$(echo "$RESULT" | grep "\file statement" | grep -v "file tag!" | sed -e 's/^/    '"${PREFIXES[0]}"'/') || true
if [ -n "$FOUND" ]; then
      IS_OK=false
      echo ""
      echo -e "${RED}==> The following @file statement does not exists in ${C_FILE}${ENDCOLOR}"
      echo "$FOUND"
      echo "    Please, fix the issue and run the tool again"
fi

# - function is not documented (main is filtered)
FOUND=$(echo "$RESULT" | grep "(function)" | grep -v "main" | sed -e 's/^/    '"${PREFIXES[1]}"'/') || true
if [ -n "$FOUND" ]; then
      IS_OK=false
      echo ""
      echo -e "${RED}==> The following functions are not documented in ${C_FILE}${ENDCOLOR}"
      echo "$FOUND"
fi

# - parameters are not documented
FOUND=$(echo "$RESULT" | grep -e "parameter of" -e "parameter '" -e  "parameters of" | grep -v "main" | sed -e 's/^/    '${PREFIXES[2]}'/') || true
if [ -n "$FOUND" ]; then
      IS_OK=false
      echo ""
      echo -e "${RED}==> The following parameters are not documented in ${C_FILE}${ENDCOLOR}"
      echo "$FOUND"
fi

# - return type is not documented
FOUND=$(echo "$RESULT" | grep "return type" | grep -v "main" | sed -e 's/^/    '${PREFIXES[3]}'/') || true
if [ -n "$FOUND" ]; then
      IS_OK=false
      echo ""
      echo -e "${RED}==> The following return types are not documented in ${C_FILE}${ENDCOLOR}"
      echo "$FOUND"
fi

if test "${IS_OK}" = true;  then
    echo ""
    echo -e "    ${GREEN}${C_FILE} looks good!${ENDCOLOR}"
fi

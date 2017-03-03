#!/bin/bash

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

ctrl_c() {
  echo ""
  echo ""
  h2 "Terminated"
  h2 "type ${GREEN}${BOLD}EXIT ${NC}for close app or press ENTER to show NOTE"
  echo ""
}

#main task
main() {
  echo ""
  h1 "WordPress Theme builder | Version 1.0.0"

  while true; do

  echo -e ""
  echo -e "  NOTE:"
  echo -e "  [1] - [INIT]  - Initial project."
  echo -e "  [2] - [DEV]   - Run gulp on dev mode."
  echo -e "  [3] - [BUILD] - Make current build and compress to *.zip file."
  echo -e "  [0] - [Exit]  - say goodbye =)"
  echo -e ""
  read -p "  What do you want to do? " service
  echo -e ""

  # # serviceString to lowerCase
  service=${service:-'_'}
  SERVICE="${service,,}"

  # Go away
  if [ $SERVICE = "init" ] || [ $SERVICE = "initial" ] || [ $SERVICE = "1" ] ; then
    echo ""
    read -p "  Are you sure you want to initialize new theme? [YES] " newtheme
    NEWTHEME=${newtheme:-'empty'}
    NEWTHEME="${NEWTHEME,,}"
    if [ $NEWTHEME = "yes" ] || [ $NEWTHEME = "y" ] ; then
      npm install
      read -p "  Theme Name:  " theme_name
      NAME=${theme_name:-'reatlat'}
      NAME_S=${NAME// /_}
      NAME_S=${NAME_S//-/_}
      read -p "  Theme Slug:  " theme_slug
      SLUG=${theme_slug:-'reatlat-net'}
      SLUG=${SLUG,,}
      SLUG=${SLUG// /-}
      SLUG_S=${SLUG//-/_}
      read -p "  Author:      " theme_author
      AUTHOR=${theme_author:-'Alex Zappa a.k.a. re[at]lat'}
      read -p "  Author URL:  " theme_author_url
      AUTHOR_URL=${theme_author_url:-'https://reatlat.net/'}
      read -p "  Description: " theme_desc
      DESC=${theme_desc:-'This theme was builded with WP-Theme-builder'}
      read -p "  Theme Tags:  " theme_tags
      TAGS='underscores, reatlat, '${theme_author_tags}
      mkdir -p dev
      mkdir -p temp
      mkdir -p release
      mkdir -p build
      mkdir -p source
      mkdir -p source/images
      mkdir -p source/fonts
      mkdir -p source/favicons
      mkdir -p source/scripts
      mkdir -p source/scripts/vendor
      mkdir -p source/styles
      mkdir -p source/others
      touch source/style.css
      echo '/*' > source/style.css
      echo 'Theme Name: '$NAME >> source/style.css
      echo 'Theme URI: http://underscores.me/' >> source/style.css
      echo 'Author: '$AUTHOR >> source/style.css
      echo 'Author URI: '$AUTHOR_URL >> source/style.css
      echo 'Description: '$DESC >> source/style.css
      echo 'Version: 1.0.0' >> source/style.css
      echo 'License: GNU General Public License v2 or later' >> source/style.css
      echo 'License URI: LICENSE' >> source/style.css
      echo 'Text Domain: '$SLUG >> source/style.css
      echo 'Tags: '$TAGS >> source/style.css
      echo '' >> source/style.css
      echo 'This theme, like WordPress, is licensed under the GPL.' >> source/style.css
      echo 'Use it to make something cool, have fun, and share what you`ve learned with others.' >> source/style.css
      echo '' >> source/style.css
      echo $NAME' is based on Underscores http://underscores.me/, (C) 2012-2016 Automattic, Inc.' >> source/style.css
      echo 'Underscores is distributed under the terms of the GNU GPL v2 or later.' >> source/style.css
      echo '' >> source/style.css
      echo 'Normalizing styles have been helped along thanks to the fine work of' >> source/style.css
      echo 'Nicolas Gallagher and Jonathan Neal http://necolas.github.io/normalize.css/' >> source/style.css
      echo '*/' >> source/style.css

      touch gulpfile.coffee
      echo "###" > gulpfile.coffee
      echo "# General settings" >> gulpfile.coffee
      echo "###" >> gulpfile.coffee
      echo "theme           = {}" >> gulpfile.coffee
      echo "theme.name      = '"$NAME"'" >> gulpfile.coffee
      echo "theme.name_s    = '"$NAME_S"'" >> gulpfile.coffee
      echo "theme.desc      = '"$DESC"'" >> gulpfile.coffee
      echo "theme.slug      = '"$SLUG"'" >> gulpfile.coffee
      echo "theme.slug_s    = '"$SLUG_S"'" >> gulpfile.coffee
      echo "theme.author    = '"$AUTHOR"'" >> gulpfile.coffee
      echo "theme.authorUrl = '"$AUTHOR_URL"'" >> gulpfile.coffee
      echo "" >> gulpfile.coffee
      cat include/example-gulpfile.coffee >> gulpfile.coffee
      gulp init
      h1 "DONE"
    fi
  fi

  if [ $SERVICE = "dev" ] || [ $SERVICE = "development" ] || [ $SERVICE = "2" ] ; then
    echo ""
    h2 "You run DEV watch task."
    gulp dev
    echo ""
  fi

  if [ $SERVICE = "build" ] || [ $SERVICE = "release" ] || [ $SERVICE = "3" ] ; then
    echo ""
    h2 "You run BUILD release task."
    gulp build
    echo ""
  fi

  # Go away
  if [ $SERVICE = "exit" ] || [ $SERVICE = "quit" ] || [ $SERVICE = "0" ] ; then
    echo ""
    h2 "See you later,"
    h2 "Have a nice day ;)"
    echo ""
    break
  fi

  # Command failed
  if [ $SERVICE = "_" ] || [ $SERVICE != "init" ] && [ $SERVICE != "dev" ] && [ $SERVICE != "build" ] && [ $SERVICE != "exit" ] && [ $SERVICE != "quit" ] && [ $SERVICE != "0" ] && [ $SERVICE != "1" ] && [ $SERVICE != "2" ] && [ $SERVICE != "3" ] ; then
    echo ""
    ISSUE "Ooops... " "Something wrong" "Command missing, try type again"
    echo ""
  fi

  done
}


# Helpers
# --------------

RED='\033[0;31m'
LRED='\033[1;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
PURPLE='\033[0;34m'
CYAN='\033[0;36m'
LBLUE='\033[1;34m'
BOLD='\E[1m'
WHITE='\033[1;37m'
NC='\033[0m'

h1() {
  local len=$(($(tput cols)-1))
  local input=$*
  local size=$(((len - ${#input})/2))

  for ((i = 0; i < len; i++)); do echo -ne "${PURPLE}${BOLD}="; done; echo ""
  for ((i = 0; i < size; i++)); do echo -n " "; done; echo -e "${NC}${BOLD}$input"
  for ((i = 0; i < len; i++)); do echo -ne "${PURPLE}${BOLD}="; done; echo -e "${NC}"
}

h2() {
  echo -e "${ORANGE}${BOLD}==>${NC}${BOLD} $*${NC}"
}

h3() {
  printf "%b " "${CYAN}${BOLD}  ->${NC} $*"
}

h3warn() {
  printf "%b " "${RED}${BOLD}  [!]|${NC} $*" && echo ""
}

STATUS() {
  local status=$1
  if [[ $1 == 'SKIP' ]]; then
    echo ""
    return
  fi
  if [[ $status != 0 ]]; then
    echo -e "${RED}✘${NC}"
    return
  fi
  echo -e "${GREEN}✓${NC}"
}

ISSUE() {
  echo -e "${ORANGE}${BOLD}==> $1 ${ORANGE}($2): $3.${NC}"
}

ERROR() {
  echo -e "${RED}${BOLD}==> ERROR ${RED}(Line $1): $2.${NC}"
  exit 1;
}

loglevel() {
  [[ "$VERBOSE" == "false" ]] && return
  local IN
  while read -r IN; do
    echo "$IN"
  done
}

status_vodka() {
  echo -e " ${GREEN}               "
  echo " Happy VODKA Day"
  echo "        _       "
  echo "       ]=[      "
  echo "    .-'(P)'-.   "
  echo "    |absolut|   "
  echo -e "    | ${WHITE}~~~~~${GREEN} |   "
  echo -e "    | ${LBLUE}~~~~~${GREEN} |   "
  echo -e "    | ${LRED}~~~~~${GREEN} |   "
  echo "    '_______'   "
  echo -e " ${NC}               "
}

main

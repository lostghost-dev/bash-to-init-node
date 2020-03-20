#!/usr/bin/env bash

# colors defined
RED='\033[0;31m'
NC='\033[0m' # no color
GREEN='\033[0;32m'
LCYAN='\033[1;36m'
YELLOW='\033[0;33m'

# check Node
function checkNode(){
    node -v &> /dev/null
}

# Checks for existing eslintrc file
function checkEslint(){
    if [ -f ".eslintrc.js" -o -f ".eslintrc.yaml" -o -f ".eslintrc.yml" -o -f ".eslintrc.json" -o -f ".eslintrc" ]; then
        ls -a .eslint* | xargs -n 1 basename
        echo
        return 1
    fi
}

function checkPrettier(){
    # Checks for existing prettierrc files
    if [ -f ".prettierrc.js" -o -f "prettier.config.js" -o -f ".prettierrc.yaml" -o -f ".prettierrc.yml" -o -f ".prettierrc.json" -o -f ".prettierrc.toml" -o -f ".prettierrc" ]; then
        ls -a | grep "prettier*" | xargs -n 1 basename
        echo
        return 1
    fi
}

# check if node is installed
if checkNode; then
    echo
    echo -e "${GREEN}Sweet! Node is available${NC}"
else
    echo
    echo -e "${RED}Node isnt installed, Please install and try again${NC}"
    exit 1
fi

# check for eslint files
if checkEslint; then
    echo
    echo -e "${GREEN}Working Directory seems clean! Marching Forward${NC}"
else
    echo
    echo -e "${RED}Ancient eslint files found!${NC}"
    exit 1
fi

# check for eslint files
if checkPrettier; then
    echo
    echo -e "${GREEN}Working directory is pretty${NC}"
else
    echo
    echo -e "${RED}Working directory is dirty!${NC}"
    exit 1
fi

# ----------------------
# Perform Configuration
# ----------------------
echo
echo -e "${GREEN}Configuring your development environment... ${NC}"
if [ ! -f ./package.json ]; then
    npm init -y &> /dev/null
fi

echo
echo -e "1/5 ${LCYAN}ESLint & Prettier Installation... ${NC}"
echo
npm i -D eslint prettier

echo
echo -e "2/5 ${YELLOW}Conforming to Airbnb's JavaScript Style Guide... ${NC}"
echo
npx install-peerdeps --dev eslint-config-airbnb

echo
echo -e "3/5 ${LCYAN}Making ESlint and Prettier play nice with each other... ${NC}"
echo "See https://github.com/prettier/eslint-config-prettier for more details."
echo
npm i -D eslint-plugin-prettier eslint-config-prettier eslint-plugin-node eslint-config-node babel-eslint

echo
echo -e "4/5 ${YELLOW}Building your .eslintrc.json file...${NC}"
touch .eslintrc.json

echo '{
  "extends": ["airbnb", "prettier", "plugin:node/recommended"],
  "plugins": ["prettier"],
  "env": {
    "browser": true,
    "commonjs": true,
    "es6": true,
    "jest": true,
    "node": true
  },
  "rules": {
    "prettier/prettier": "error",
    "no-unused-vars": "warn",
    "no-console": "off",
    "func-names": "off",
    "no-process-exit": "off",
    "object-shorthand": "off",
    "class-methods-use-this": "off"
  }
}'> .eslintrc.json

echo
echo -e "5/5 ${YELLOW}Building your .prettierrc.json file... ${NC}"
touch .prettierrc
echo '{ "singleQuote": true }' > .prettierrc

echo
echo -e "${GREEN}Finished setting up!${NC}"
echo
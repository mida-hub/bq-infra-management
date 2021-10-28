#!/bin/bash

function yaml_to_json() {
    ruby -rjson -ryaml -e 'print YAML.load(STDIN.read).to_json'
}

function is_not_file_exist() {
    if [ ! -e $1 ]; then
        echo "$1 is not found"
        exit 1
    fi
}

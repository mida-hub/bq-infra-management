#!/bin/bash

function yaml_to_json() {
    ruby -rjson -ryaml -e 'print YAML.load(STDIN.read).to_json'
}

function file_not_exists_then_error() {
    if [ ! -e $1 ]; then
        echo "$1 is not found"
        exit 1
    fi
}

function file_not_exists_then_exit {
    if [ ! -e $1 ]; then
        echo "$1 is not found"
        exit 0
    fi
}

function run_command(){
    echo $1
    eval $1
}

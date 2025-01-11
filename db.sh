#!/bin/bash

DB_PATH="./databases"
mkdir -p $DB_PATH



function show_menu() {
    echo "=============================="
    echo "Database Management System"
    echo "=============================="
    echo "1. Create Database"
    echo "2. List Databases"
    echo "3. Connect to Database"
    echo "4. Delete Database"
    echo "5. Exit"
    read -p "Enter your choice [1-5]: " choice
    declare -g choice
}

function create_database() {
    read -p "Enter database name: " dbname
    if [[ $dbname =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
        if [[ -d "$DB_PATH/$dbname" ]]; then
        echo "Database '$dbname' already exists."
    else
        mkdir "$DB_PATH/$dbname"
        echo "Database '$dbname' created."
    fi
    else
        echo "Invalid database name."
    fi
}

function list_database(){
    echo "Available Databases:"
    ls $DB_PATH
}

function connect_database() {
    read -p "Enter database name to connect: " dbname
    if [[ -d "$DB_PATH/$dbname" ]]; then
        echo "Connecting to database $dbname..."
        if [[ -x "./table" ]]; then
            ./table "$DB_PATH/$dbname"
        else
            echo "Error: 'table' script not found or not executable."
        fi
    else
        echo "Database does not exist."
    fi
}

function delete_database(){
    read -p "Enter database name to delete: " dbname
    if [[ -d "$DB_PATH/$dbname" ]]; then
        read -p "Are you sure you want to delete $dbname? (y/n): " confirm
        if [[ $confirm == "y" || $confirm == "Y" ]]; then
        rm -r "$DB_PATH/$dbname"
        echo "Database '$dbname' deleted."
    else
        echo "Operation cancelled."
    fi
    else
        echo "Database does not exist."
    fi
}

function exit (){
    echo "Exiting Database Management System. Goodbye!"
    exit 0
}


while true; do
    show_menu
    case $choice in
        1)create_database;;
        2)list_database;;
        3)connect_database;;
        4)delete_database;;
        5)exit;;
        *)echo "Invalid choice. Please try again.";;
    esac
done
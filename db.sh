#!/bin/bash

DB_PATH="./databases"
mkdir -p "$DB_PATH"

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

function list_database() {
    if [[ -z "$(ls -A "$DB_PATH")" ]]; then
        echo "No databases available."
    else
        echo "Available Databases:"
        ls "$DB_PATH"
    fi
}

function connect_database() {
    read -p "Enter database name to connect: " dbname
    if [[ -d "$DB_PATH/$dbname" ]]; then
        echo "Connecting to database $dbname..."
        if [[ -x "./table.sh" ]]; then
            echo "Table script found. Running it now..."
            echo "$DB_PATH/$dbname"
            echo $DB_PATH/$dbname
            ./table.sh "$DB_PATH/$dbname"
        else
            echo "Error: 'table' script not found or not executable."
            echo "Make sure 'table' exists in the same directory as 'db' and is executable."
        fi
    else
        echo "Database '$dbname' does not exist."
    fi
}


function delete_database() {
    read -p "Enter database name to delete: " dbname
    if [[ -d "$DB_PATH/$dbname" ]]; then
        read -p "Are you sure you want to delete $dbname? (y/n): " confirm
        if [[ $confirm =~ ^[yY]$ ]]; then
            rm -r "$DB_PATH/$dbname"
            echo "Database '$dbname' deleted."
        else
            echo "Operation cancelled."
        fi
    else
        echo "Database does not exist."
    fi
}

function exit_system() {
    echo "Exiting Database Management System. Goodbye!"
    exit 0
}



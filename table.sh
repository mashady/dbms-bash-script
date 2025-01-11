#!/bin/bash

DB_PATH=$1


function show_menu() {
    echo "=============================="
    echo "Table Management for $(basename $DB_PATH)"
    echo "=============================="
    echo "1. Create Table"
    echo "2. List Tables"
    echo "3. Drop Table"
    echo "4. Insert Row"
    echo "5. Show Data"
    echo "6. Delete Row"
    echo "7. Update Cell"
    echo "8. Exit to Main Menu"
    read -p "Enter your choice [1-8]: " choice
}

function create_table() {
    read -p "Enter table name: " table
            if [[ $table =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
                if [[ -f "$DB_PATH/$table.meta" ]]; then
                    echo "Table '$table' already exists."
                else
                    read -p "Enter number of columns: " col_count
                    for ((i=1; i<=col_count; i++)); do
                        read -p "Enter name for column $i: " colname
                        read -p "Enter type for column $colname (String/Integer): " coltype
                        echo "$colname:$coltype" >> "$DB_PATH/$table.meta"
                    done
                    touch "$DB_PATH/$table.data"
                    echo "Table '$table' created."
                fi
            else
                echo "Invalid table name."
            fi
}

function list_tables() {
    echo "Available Tables:"
    ls $DB_PATH | grep ".meta" | sed 's/.meta//'
}

function drop_table() {
    read -p "Enter table name to drop: " table
        if [[ -f "$DB_PATH/$table.meta" ]]; then
            read -p "Are you sure? (y/n): " confirm
            if [[ $confirm == "y" ]]; then
                rm "$DB_PATH/$table.meta" "$DB_PATH/$table.data"
                echo "Table '$table' dropped."
            fi
        else
            echo "Table does not exist."
        fi
}

function insert_row() {
    read -p "Enter table name to insert into: " table
    if [[ -f "$DB_PATH/$table.meta" ]]; then
        columns=()
        while IFS=: read -r colname coltype; do
            columns+=("$colname")
        done < "$DB_PATH/$table.meta"

        values=""
        for col in "${columns[@]}"; do
            read -p "Enter value for column '$col': " value
            values+="$value,"
        done
        values=${values%,}

        echo "$values" >> "$DB_PATH/$table.data"
        echo "Row inserted into table '$table'."
    else
        echo "Table does not exist."
    fi
}

function show_data() {
    read -p "Enter table name to display data: " table
    if [[ -f "$DB_PATH/$table.data" ]]; then
        echo "Data for table '$table':"
        cat "$DB_PATH/$table.data"
    else
        echo "Table does not have any data."
    fi
}

function delete_row() {
    read -p "Enter table name to delete row from: " table
    if [[ -f "$DB_PATH/$table.data" ]]; then
        echo "Current data in table '$table':"
        cat "$DB_PATH/$table.data"
        read -p "Enter row number to delete: " row_num
        sed -i "${row_num}d" "$DB_PATH/$table.data"
        echo "Row $row_num deleted from table '$table'."
    else
        echo "Table does not exist or has no data."
    fi
}

function update_cell() {
    read -p "Enter table name to update cell: " table
    if [[ -f "$DB_PATH/$table.data" ]]; then
        echo "Current data in table '$table':"
        cat "$DB_PATH/$table.data"
        read -p "Enter row number to update: " row_num
        read -p "Enter column number to update: " col_num
        read -p "Enter new value for the cell: " new_value

        sed -i "${row_num}s/\([^\|]*\)\{${col_num}\}/$new_value/" "$DB_PATH/$table.data"
        echo "Cell updated in table '$table'."
    else
        echo "Table does not exist or has no data."
    fi
}

function back(){
    echo "Returning to main menu."
    exit 0
            
}

while true; do
    show_menu

    case $choice in
        1)create_table;;
        2)list_tables;;
        3)drop_table;;
        4)insert_row;;
        5)show_data;;
        6)delete_row;;
        7)update_cell;;
        8)back;;
        *)echo "Feature not implemented yet.";;
    esac
done

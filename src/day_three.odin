package src

import "core:fmt"
import "core:strconv"
import "core:strings"

Snippet :: struct {
    start : int,
    length : int,
}

day_three_part_one :: proc () {
    input, _ := strings.remove_all(read_text_file("./res/day_three_input.txt"), "\n")

    ledger : [dynamic]Snippet

    for char, index in input {
        switch (char) {
            case '.':
                continue
            case '0'..='9':
                continue
        }

        append(&ledger, ..get_local_numbers(&input, index)[:])
    }
}

get_local_numbers :: proc (input : ^string, target : int) -> []Snippet {
    dimension :: 140

    if target < 0 {
        return nil
    }

    if target > dimension {
        //if 
    }

    return nil
}
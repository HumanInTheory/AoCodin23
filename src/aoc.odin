package src

import "core:os"
import "core:strings"

main :: proc () {
    day_seven_part_two()
}

read_text_file :: proc (filename : string) -> string {
    data, success := os.read_entire_file_from_filename(filename)

    if !success {
        return ""// :(
    }

    text_data, error := strings.clone_from_bytes(data)

    if error != .None {
        return ""
    }

    return text_data
}
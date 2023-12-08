package src

import "core:fmt"
import "core:os"
import "core:strings"
import "core:time"

main :: proc () {
    t_start := time.now()
    day_eight_part_one()
    t_end := time.now()
    fmt.println("Time:", time.duration_milliseconds(time.diff(t_start, t_end)))
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
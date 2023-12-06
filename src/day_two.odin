package src

/*
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
*/

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

day_two_part_one :: proc () {
    red_max := 12
    green_max := 13
    blue_max := 14

    total := 5050

    data, success := os.read_entire_file_from_filename("./res/day_two_input.txt")

    if !success {
        return // :(
    }

    text_data, error := strings.clone_from_bytes(data)

    if error != .None {
        return
    }

    for line in strings.split_lines_iterator(&text_data) {
        split_line := strings.split(line, " ")

        iterator: for i := 2; i < len(split_line); i += 2 {
            switch(split_line[i + 1]) {
                case "red":
                    fallthrough
                case "red,":
                    fallthrough
                case "red;":
                    if strconv.atoi(split_line[i]) > red_max {
                        fmt.println("Red over:", strconv.atoi(split_line[i]), "game:", strconv.atoi(split_line[1]))
                        total -= strconv.atoi(split_line[1])
                        break iterator
                    }
                case "green":
                    fallthrough
                case "green,":
                    fallthrough
                case "green;":
                    if strconv.atoi(split_line[i]) > green_max {
                        fmt.println("Green over:", strconv.atoi(split_line[i]), "game:", strconv.atoi(split_line[1]))
                        total -= strconv.atoi(split_line[1])
                        break iterator
                    }
                case "blue":
                    fallthrough
                case "blue,":
                    fallthrough
                case "blue;":
                    if strconv.atoi(split_line[i]) > blue_max {
                        fmt.println("Blue over:", strconv.atoi(split_line[i]), "game:", strconv.atoi(split_line[1]))
                        total -= strconv.atoi(split_line[1])
                        break iterator
                    }
            }
        }
    }

    fmt.println(total)
}

day_two_part_two :: proc () {
    total := 0

    data, success := os.read_entire_file_from_filename("./res/day_two_input.txt")

    if !success {
        return // :(
    }

    text_data, error := strings.clone_from_bytes(data)

    if error != .None {
        return
    }

    for line in strings.split_lines_iterator(&text_data) {
        red_max := 0
        green_max := 0
        blue_max := 0

        split_line := strings.split(line, " ")

        for i := 2; i < len(split_line); i += 2 {
            switch(split_line[i + 1]) {
                case "red":
                    fallthrough
                case "red,":
                    fallthrough
                case "red;":
                    red_max = max(red_max, strconv.atoi(split_line[i]))
                case "green":
                    fallthrough
                case "green,":
                    fallthrough
                case "green;":
                    green_max = max(green_max, strconv.atoi(split_line[i]))
                case "blue":
                    fallthrough
                case "blue,":
                    fallthrough
                case "blue;":
                    blue_max = max(blue_max, strconv.atoi(split_line[i]))
            }
        }

        total += red_max * green_max * blue_max
    }

    fmt.println(total)
}
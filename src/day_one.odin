package src

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

search :: "0123456789"
search_text : []string : {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"} 

day_one_part_one :: proc () {
    calibration_sum : int = 0

    data, success := os.read_entire_file_from_filename("./res/day_one_input.txt")

    if !success {
        return // :(
    }

    text_data, error := strings.clone_from_bytes(data)

    if error != .None {
        return
    }

    for substring in strings.split_iterator(&text_data, "\n") {
        digits : [2]u8
        digits[0] = substring[strings.index_any(substring, search)]
        digits[1] = substring[strings.last_index_any(substring, search)]

        calibration_sum += strconv.atoi(string(digits[0:]))
    }

    fmt.println(calibration_sum)
    return
}

day_one_part_two :: proc () {
    calibration_sum : int = 0

    data, success := os.read_entire_file_from_filename("./res/day_one_input.txt")

    if !success {
        return // :(
    }

    text_data, error := strings.clone_from_bytes(data)

    if error != .None {
        return
    }

    for substring in strings.split_iterator(&text_data, "\n") {
        first_index, first_width := strings.index_multi(substring, search_text)
        last_index, last_width := last_index_multi(substring, search_text)
        if last_index == -1 {
            fmt.println(substring)
        }

        digits : [2]u8

        if first_width == 1 {
            digits[0] = substring[first_index]
        }
        else {
            digits[0] = word_to_digit(string(substring[first_index : first_index + first_width]))
        }
        
        if last_width == 1 {
            digits[1] = substring[last_index]
        }
        else {
            digits[1] = word_to_digit(string(substring[last_index:last_index + last_width]))
        }
        temp := strconv.atoi(string(digits[0:]))

        if temp < 10 || temp > 99 {
            fmt.println(substring, string(digits[0:]), temp)
        }

        calibration_sum += temp
    }

    fmt.println(calibration_sum)
    return
}

word_to_digit :: proc (s : string) -> u8 {
    switch(s) {
        case "zero":
            return 48
        case "one":
            return 49
        case "two":
            return 50
        case "three":
            return 51
        case "four":
            return 52
        case "five":
            return 53
        case "six":
            return 54
        case "seven":
            return 55
        case "eight":
            return 56
        case "nine":
            return 57
        case:
            return 48
    }
}

// idk why Odin core:strings doesn't have this
last_index_multi :: proc(s: string, substrs: []string) -> (idx: int, width: int) {
	idx = -1
	if s == "" || len(substrs) <= 0 {
		return
	}
	// disallow "" substr
	for substr in substrs {
		if len(substr) == 0 {
			return
		}
	}

	highest_index := -1
	found := false
	for substr in substrs {
		if i := strings.last_index(s, substr); i >= 0 {
			if i > highest_index {
				highest_index = i
				width = len(substr)
				found = true
			}
		}
	}

	if found {
		idx = highest_index
	}
	return
}
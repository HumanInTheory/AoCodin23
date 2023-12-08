package src

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"

hand_type :: enum {
    High_Card,
    One_Pair,
    Two_Pair,
    Three_Of_A_Kind,
    Full_House,
    Four_Of_A_Kind,
    Five_Of_A_Kind,
}

hand :: struct {
    type : hand_type,
    source : string,
    bid : int,
}

card_list : string : "23456789TJQKA"
joker_list : string : "J23456789TQKA"

day_seven_part_one :: proc () {
    input := read_text_file("./res/day_seven_input.txt")

    hands : [dynamic]hand

    for line in strings.split_lines_iterator(&input) {
        append(&hands, parse_hand(line))
    }

    quick_sort(hands[:], 0, len(hands) - 1)

    total := 0
    for h, index in hands {
        total += h.bid * (index + 1)
    }

    fmt.println(total)
}

day_seven_part_two :: proc () {
    input := read_text_file("./res/day_seven_input.txt")

    hands : [dynamic]hand

    for line in strings.split_lines_iterator(&input) {
        append(&hands, parse_hand_jokers(line))
    }

    quick_sort(hands[:], 0, len(hands) - 1)

    total := 0
    for h, index in hands {
        if strings.contains_rune(h.source, 'J') {
            fmt.println(h.type, h.source)
        }
        total += h.bid * (index + 1)
    }

    fmt.println(total)
}

parse_hand :: proc (s : string) -> hand {
    temp := strings.split(s, " ")
    result : hand = {.High_Card, temp[0], strconv.atoi(temp[1])}

    card_map := make(map[rune]int)
    defer delete(card_map)
    for codepoint, index in result.source {
        card_map[codepoint] += 1
    }

    loop: for key, value in card_map {
        switch {
            case value == 5:
                result.type = .Five_Of_A_Kind
                break loop
            case value == 4:
                result.type = .Four_Of_A_Kind
                break loop
            case value == 3 && result.type == .One_Pair:
                result.type = .Full_House
                break loop
            case value == 3:
                result.type = .Three_Of_A_Kind
                continue
            case value == 2 && result.type == .Three_Of_A_Kind:
                result.type = .Full_House
                break loop
            case value == 2 && result.type == .One_Pair:
                result.type = .Two_Pair
                break loop
            case value == 2:
                result.type = .One_Pair
                continue
        }
    }

    return result
}

parse_hand_jokers :: proc (s : string) -> hand {
    temp := strings.split(s, " ")
    result : hand = {.High_Card, temp[0], strconv.atoi(temp[1])}

    card_map := make(map[rune]int)
    defer delete(card_map)
    for codepoint, index in result.source {
        card_map[codepoint] += 1
    }

    jokers := card_map['J']
    
    max_value := 0
    max_key : rune
    for key, value in card_map {
        if key == 'J' {
            continue
        }

        if value > max_value {
            max_value = value
            max_key = key
        }
    }
    card_map[max_key] += jokers

    loop: for key, value in card_map {
        if key == 'J' {
            continue
        }

        switch {
            case value == 5:
                result.type = .Five_Of_A_Kind
                break loop
            case value == 4:
                result.type = .Four_Of_A_Kind
                break loop
            case value == 3 && result.type == .One_Pair:
                result.type = .Full_House
                break loop
            case value == 3:
                result.type = .Three_Of_A_Kind
                continue
            case value == 2 && result.type == .Three_Of_A_Kind:
                result.type = .Full_House
                break loop
            case value == 2 && result.type == .One_Pair:
                result.type = .Two_Pair
                break loop
            case value == 2:
                result.type = .One_Pair
                continue
        }
    }

    return result
}

quick_sort :: proc (list : []hand, left, right : int) {
    if (left >= right) {
        return
    }

    mid := partition(list, left, right)

    quick_sort(list, left, mid - 1)
    quick_sort(list, mid + 1, right)
}

partition :: proc (list : []hand, left, right : int) -> int {
    pivot : hand = list[right]
    i : int = left - 1
    for j : int = left; j <= right - 1; j+= 1 {
        if compare_hands(list[j], pivot) == 1 {
            i += 1
            slice.swap(list, i, j)
        }
    }
    slice.swap(list, i + 1, right)
    return i + 1
}

compare_hands :: proc (left, right : hand) -> int {
    if left.type > right.type {
        return -1
    }

    if left.type < right.type {
        return 1
    }

    card_comp : int

    for codepoint, index in left.source {
        //card_comp = compare_cards(codepoint, cast(rune)right.source[index])
        card_comp = compare_cards_jokers(codepoint, cast(rune)right.source[index])
        if card_comp != 0 {
            return card_comp
        }
    }

    return 0
}

compare_cards :: proc (left, right : rune) -> int {
    if strings.index_rune(card_list, left) > strings.index_rune(card_list, right) {
        return -1
    }

    if strings.index_rune(card_list, left) < strings.index_rune(card_list, right) {
        return 1
    }

    return 0
}

compare_cards_jokers :: proc (left, right : rune) -> int {
    if strings.index_rune(joker_list, left) > strings.index_rune(joker_list, right) {
        return -1
    }

    if strings.index_rune(joker_list, left) < strings.index_rune(joker_list, right) {
        return 1
    }

    return 0
}
package src

import "core:fmt"
import "core:strings"

node :: struct {
    left : string,
    right : string,
}

day_eight_part_one :: proc () {
    input := read_text_file("./res/day_eight_input.txt")

    input_lines := strings.split_lines(input)

    directions := input_lines[0]

    node_map : map[string]node
    for i := 2; i < len(input_lines); i += 1 {
        node_input := strings.split_multi(input_lines[i], {" = (", ", ", ")"})
        node_map[node_input[0]] = {node_input[1], node_input[2]}
    }

    current_node := "AAA"
    move_count := 0
    outer_loop: for {
        for codepoint in directions {
            switch codepoint {
                case 'L':
                    current_node = node_map[current_node].left
                case 'R':
                    current_node = node_map[current_node].right
            }

            move_count += 1

            if current_node == "ZZZ" {
                break outer_loop
            }
        }
    }

    fmt.println(move_count)
}

day_eight_part_two :: proc () {
    input := read_text_file("./res/day_eight_input.txt")

    input_lines := strings.split_lines(input)

    directions := input_lines[0]

    node_map : map[string]node
    start_nodes : [dynamic]string
    for i := 2; i < len(input_lines); i += 1 {
        node_input := strings.split_multi(input_lines[i], {" = (", ", ", ")"})
        node_map[node_input[0]] = {node_input[1], node_input[2]}

        if node_input[0][2] == 65 {
            append(&start_nodes, node_input[0])
        }
    }

    total_move_count := 1
    for start_node, index in start_nodes {
        current_node := start_node
        move_count := 0
        search_loop: for {
            for codepoint in directions {
                switch codepoint {
                    case 'L':
                        current_node = node_map[current_node].left
                    case 'R':
                        current_node = node_map[current_node].right
                }

                move_count += 1

                if current_node[2] == 90 {
                    break search_loop
                }
            }
        }
        total_move_count = lcm(total_move_count, move_count)
        fmt.println(index, total_move_count)
    }

    fmt.println(total_move_count)
}

lcm :: proc (a, b : int) -> int {
    return (a * b) / gcd(a, b)
}

gcd :: proc (a, b : int) -> int {
    remainder := 0
    x := a
    y := b
    for y != 0 {
        remainder = x % y
        x = y
        y = remainder
    }
    return x
}
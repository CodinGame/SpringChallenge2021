use std::io;
use std::fmt;

macro_rules! parse_input {
    ($x:expr, $t:ident) => ($x.trim().parse::<$t>().unwrap())
}

struct Tree {
    cell_index : i32,
    size : i32,
    is_mine : bool,
    is_dormant : bool,
}

type Forest = Vec<Tree>;

fn get_forest() -> Forest {
    let mut forest = vec![];
    let mut input_line = String::new();
    io::stdin().read_line(&mut input_line).unwrap();
    let number_of_trees = parse_input!(input_line, i32); // the current amount of trees
    for i in 0..number_of_trees as usize {
        let mut input_line = String::new();
        io::stdin().read_line(&mut input_line).unwrap();
        let inputs = input_line.split(" ").collect::<Vec<_>>();
        let cell_index = parse_input!(inputs[0], i32); // location of this tree
        let size = parse_input!(inputs[1], i32); // size of this tree: 0-3
        let is_mine = parse_input!(inputs[2], i32) == 1; // 1 if this is your tree
        let is_dormant = parse_input!(inputs[3], i32) == 1; // 1 if this tree is dormant
        forest.push(Tree{cell_index, size, is_mine, is_dormant});
    }
    forest
}

enum Action {
    Grow(i32),
    Seed(i32,i32),
    Complete(i32),
    Wait,
}

impl From<&String> for Action {
    fn from(s: &String) -> Self {
        let inputs = s.split(" ").collect::<Vec<_>>();
        match inputs[0] {
            "GROW" => Action::Grow(parse_input!(inputs[1], i32)),
            "SEED" => Action::Seed(parse_input!(inputs[1], i32),parse_input!(inputs[2], i32)),
            "COMPLETE" => Action::Complete(parse_input!(inputs[1], i32)),
            "WAIT" => Action::Wait,
            _ => {panic!("Wrong action input"); Action::Wait},
        }
    }
}

impl fmt::Display for Action {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}",
            match self {
                Action::Grow(i) => format!("GROW {}", i),
                Action::Seed(i,j) => format!("SEED {} {}", i,j),
                Action::Complete(i) => format!("COMPLETE {}", i),
                Action::Wait => String::from("WAIT"),
            }
        )
    }
}

type ActionList = Vec<Action>;

fn get_actionlist() -> ActionList {
    let mut action_list = vec![];
    let mut input_line = String::new();
    io::stdin().read_line(&mut input_line).unwrap();
    let number_of_possible_actions = parse_input!(input_line, i32); // all legal actions
    for i in 0..number_of_possible_actions as usize {
        let mut input_line = String::new();
        io::stdin().read_line(&mut input_line).unwrap();
        let possible_action = input_line.trim_matches('\n').to_string(); // try printing something from here to start with
        action_list.push(Action::from(&possible_action));
    }
    action_list
}

struct GameContext {
    day : i32,
    nutrients : i32,
    sun : i32,
    score : i32,
    op_sun : i32,
    op_score : i32,
    op_is_waiting : bool,
}

fn get_game_context() -> GameContext {
    let mut input_line = String::new();
    io::stdin().read_line(&mut input_line).unwrap();
    let day = parse_input!(input_line, i32); // the game lasts 24 days: 0-23
    let mut input_line = String::new();
    io::stdin().read_line(&mut input_line).unwrap();
    let nutrients = parse_input!(input_line, i32); // the base score you gain from the next COMPLETE action
    let mut input_line = String::new();
    io::stdin().read_line(&mut input_line).unwrap();
    let inputs = input_line.split(" ").collect::<Vec<_>>();
    let sun = parse_input!(inputs[0], i32); // your sun points
    let score = parse_input!(inputs[1], i32); // your current score
    let mut input_line = String::new();
    io::stdin().read_line(&mut input_line).unwrap();
    let inputs = input_line.split(" ").collect::<Vec<_>>();
    let op_sun = parse_input!(inputs[0], i32); // opponent's sun points
    let op_score = parse_input!(inputs[1], i32); // opponent's score
    let op_is_waiting = parse_input!(inputs[2], i32) == 1; // whether your opponent is asleep until the next day

    GameContext{day, nutrients, sun, score, op_sun, op_score, op_is_waiting}
}

struct Cell {
    index : i32,
    richness : i32,
    neighbors_ids : Vec<i32>,
}

type Area = Vec<Cell>;

fn get_area() -> Area {
    let mut area = vec![];
    let mut input_line = String::new();
    io::stdin().read_line(&mut input_line).unwrap();
    let number_of_cells = parse_input!(input_line, i32); // 37
    for i in 0..number_of_cells as usize {
        let mut input_line = String::new();
        let mut neighbors_ids = vec![];
        io::stdin().read_line(&mut input_line).unwrap();
        let inputs = input_line.split(" ").collect::<Vec<_>>();
        let index = parse_input!(inputs[0], i32); // 0 is the center cell, the next cells spiral outwards
        let richness = parse_input!(inputs[1], i32); // 0 if the cell is unusable, 1-3 for usable cells
        let neigh_0 = parse_input!(inputs[2], i32); // the index of the neighbouring cell for each direction
        let neigh_1 = parse_input!(inputs[3], i32);
        let neigh_2 = parse_input!(inputs[4], i32);
        let neigh_3 = parse_input!(inputs[5], i32);
        let neigh_4 = parse_input!(inputs[6], i32);
        let neigh_5 = parse_input!(inputs[7], i32);
        for i in 2..8 {
            neighbors_ids.push(parse_input!(inputs[i], i32));
        }
        area.push(Cell {index, richness, neighbors_ids})
    }
    area
}
/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
fn main() {
    let area = get_area();

    // game loop
    loop {
        let mut answer = String::from("WAIT");

        let context = get_game_context(); // Get input context
        let forest = get_forest(); // Get input forest
        let action_list = get_actionlist(); // List of possible actions

        for s in action_list {
            eprintln!("Action : {}", s);
        }


        // GROW cellIdx | SEED sourceIdx targetIdx | COMPLETE cellIdx | WAIT <message>
        println!("{}", answer);
    }
}

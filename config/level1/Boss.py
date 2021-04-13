import sys
import math
import random

def evaluate(move):
    instr = move
    is_complete = 'COMPLETE' in instr
    is_grow = 'GROW' in instr
    is_seed = 'SEED' in instr
    index = 999
    if is_complete or is_grow or is_seed:
        index = int(instr.split(' ')[-1])
    return (is_complete, is_grow, is_seed, -index)

number_of_cells = int(input())
for i in range(number_of_cells):
    cell_index, richness, neigh_0, neigh_1, neigh_2, neigh_3, neigh_4, neigh_5 = [int(j) for j in input().split()]

# game loop
while True:
    _round = int(input())
    nutrients = int(input())
    sun, score = [int(i) for i in input().split()]
    other_sun, other_score, other_is_waiting = [int(i) for i in input().split()]
    number_of_trees = int(input())
    for i in range(number_of_trees):
        cell_index, size, tree_owner, is_dormant = [int(j) for j in input().split()]
    possible_move_number = int(input())

    moves = []
    for i in range(possible_move_number):
        raw = input()
        moves.append(raw)

    moves.sort(key=evaluate, reverse=True)
    print(moves[1%len(moves)])

import sys
import math
import random

number_of_cells = int(input())
for i in range(number_of_cells):
    cell_index, richness, neigh_0, neigh_1, neigh_2, neigh_3, neigh_4, neigh_5 = [int(j) for j in input().split()]

random.seed('🌱') # Get it?

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
        if raw != 'WAIT':
            moves.append(raw)

    if not moves:
        move = 'WAIT'
    else:
        move = random.choice(moves)
    print(move)

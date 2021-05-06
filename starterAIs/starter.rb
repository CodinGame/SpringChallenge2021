class Cell
  def initialize(index, richness, neighbors)
    @index = index
    @richness = richness
    @neighbors = neighbors
  end
end

class Tree
  def initialize(cell_index, size, is_mine, is_dormant)
    @cell_index = cell_index
    @size = size
    @is_mine = is_mine
    @is_dormant = is_dormant
  end
end

WAIT = 'WAIT'
SEED = 'SEED'
GROW = 'GROW'
COMPLETE = 'COMPLETE'

class Action
  def self.parse(line)
    parts = line.split ' '
    if (parts[0] == WAIT)
      return Action.new(WAIT)
    end
    if (parts[1] == SEED)
      return Action.new(SEED, parts[2].to_i, parts[1].to_i)
    end
    return Action.new(parts[0], parts[1].to_i)
  end

  def initialize(type, target_cell_idx = 0, source_cell_idx = 0)
    @type = type
    @target_cell_idx = target_cell_idx
    @source_cell_idx = source_cell_idx
  end

  def to_s
    return WAIT if @type == WAIT
    return "#{SEED} #{@source_cell_idx} #{@target_cell_idx}" if @type == SEED
    "#{@type} #{@target_cell_idx}"
  end
end

class Game
  attr_accessor :day,
                :nutrients,
                :cells,
                :possible_actions,
                :trees,
                :my_sun,
                :my_score,
                :opponent_sun,
                :opponent_score,
                :opponent_is_waiting

  def initialize
    @day = 0
    @nutrients = 0
    @cells = []
    @possible_actions = []
    @trees = []
    @my_sun = 0
    @my_score = 0
    @opponent_sun = 0
    @opponent_score = 0
    @opponent_is_waiting = 0
  end

  def get_next_action
    # TODO: write your algorithm here
    return @possible_actions[0]
  end
end

game = Game.new

STDOUT.sync = true # DO NOT REMOVE
##  the standard input according to the problem statement.

number_of_cells = gets.to_i # 37
number_of_cells.times do
  # index: 0 is the center cell, the next cells spiral outwards
  # richness: 0 if the cell is unusable, 1-3 for usable cells
  # neigh_0: the index of the neighbouring cell for each direction
  index, richness, neigh_0, neigh_1, neigh_2, neigh_3, neigh_4, neigh_5 = gets.split(' ').collect { |x| x.to_i }
  game.cells << Cell.new(index, richness, [neigh_0, neigh_1, neigh_2, neigh_3, neigh_4, neigh_5])
end

# game loop
loop do
  game.day = gets.to_i # the game lasts 24 days: 0-23
  game.nutrients = gets.to_i # the base score you gain from the next COMPLETE action

  # my_sun: your sun points
  # my_score: your current score
  game.my_sun, game.my_score = gets.split(' ').collect { |x| x.to_i }

  # opponent_sun: opponent's sun points
  # opponent_score: opponent's score
  # opponent_is_waiting: whether your opponent is asleep until the next day
  inputs = gets.split(' ')
  game.opponent_sun = inputs[0].to_i
  game.opponent_score = inputs[1].to_i
  game.opponent_is_waiting = inputs[2] != '0'

  game.trees = []
  number_of_trees = gets.to_i # the current amount of trees
  number_of_trees.times do
    # cell_index: location of this tree
    # size: size of this tree: 0-3
    # is_mine: 1 if this is your tree
    # is_dormant: 1 if this tree is dormant
    cell_index, size, is_mine, is_dormant = gets.split ' '
    cell_index = cell_index.to_i
    size = size.to_i
    is_mine = is_mine.to_i == 1
    is_dormant = is_dormant.to_i == 1
    game.trees << Tree.new(cell_index, size, is_mine, is_dormant)
  end

  game.possible_actions = []
  number_of_possible_actions = gets.to_i
  number_of_possible_actions.times do
    possible_action = gets.chomp
    game.possible_actions << Action.parse(possible_action)
  end

  action = game.get_next_action

  puts action.to_s
end

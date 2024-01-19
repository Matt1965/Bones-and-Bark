-- Static variables
MINIMUM_TREE_SIZE = .6
MAXIMUM_TREE_SIZE = 1.6
QUADCOEF_TREE_HP = 300
LINEARCOEF_TREE_HP = -210
CONSTANT_TREE_HP = 68
LEASH_RADIUS = 300
STARTING_LOCATION = Location(4000, -2500)
STARTING_LOCATION_DOG = Location(4000, -2600)
FOREST_ANGER_GROWTH = 3
FOREST_EVOLUTION_GROWTH = .1
EVOLUTION_SUPPLY_MULT = 10
DOG_MAX_RADIUS = 700
DOG_MAX_RADIUS_WALK = 500

-- Internal Variables
TREE_SHADOW_PAIRS = {}
TREES_BEING_HARVESTED = {}
PLAYER_SKELETONS = {}
PLAYER_DOGS = {}
ALL_UNITS = {}
FOREST_ANGER = 0
FOREST_EVOLUTION = 0

-- Data Tables
UNIT_INFO = {
    Chicken = {Cost = 1, Code = "h003"},
    Frog = {Cost = 1, Code = "h003"},
    Sheep = {Cost = 2, Code = "h003"},
    Rabbit = {Cost = 2, Code = "h003"},
    Fawn = {Cost = 3, Code = "h003"},
    Pigeon = {Cost = 3, Code = "h003"},
    Seal = {Cost = 4, Code = "h003"},
    Crab = {Cost = 4, Code = "h003"},
    Spider = {Cost = 5, Code = "h003"},
    Pig = {Cost = 5, Code = "h003"},
    Boar = {Cost = 6, Code = "h003"},
    Quillboar = {Cost = 6, Code = "h003"},
    Wolf = {Cost = 7, Code = "h003"},
    Eagle = {Cost = 7, Code = "h003"},
    Wildkin = {Cost = 8, Code = "h003"},
    ForestTroll = {Cost = 8, Code = "h003"},
    Bear = {Cost = 9, Code = "h003"},
    GiantSpider = {Cost = 9, Code = "h003"},
    Ogre = {Cost = 10, Code = "h003"},
    Treant = {Cost = 10, Code = "h003"},
    Wendingo = {Cost = 11, Code = "h003"},
    Harpy = {Cost = 11, Code = "h003"},
    Golem = {Cost = 12, Code = "h003"},
    Dragon = {Cost = 12, Code = "h003"},
}

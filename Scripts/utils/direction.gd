
enum {
    NORTH,
    EAST,
    SOUTH,
    WEST,
}

const ENUMTOSTRING = {
    NORTH: "North",
    EAST: "East",
    SOUTH: "South",
    WEST: "West"
    }
    
const PLAYERDICT = {
    NORTH: "South",
    EAST: "West",
    SOUTH: "North",
    WEST: "East"
    }
    
const OPPOSITE = {
    NORTH: SOUTH,
    EAST: WEST,
    SOUTH: NORTH,
    WEST: EAST
}

const ENUMTOARRAY = {
    NORTH: [ 0 , 1 ],
    EAST: [ 1, 0 ],
    SOUTH: [ 0, -1 ],
    WEST: [ -1, 0 ]
}

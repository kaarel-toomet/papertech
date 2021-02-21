# papertech
You spawn in a world that is nothing but paper and some bodies of water. You have to mine the paper to build machines and things to get as much resources as possible.

Made from a fork of tunnelivana. Has some factory game elements.




## How to play

- ASDW or arrow keys to move
- P or Escape to pause
- E or . to craft basic items
- R to teleport to starting location
- Right click to place blocks
- Scroll to select stuff in your inventory
- Walk into stuff to break it




## Crafting

### Hand (when holding the first ingredient and pressing E)

- 5 paper → 1 thick paper
- 5 thick paper + 3 wet paper → 1 crafting machine
- 3 paper balls/crumpled paper → 1 paper (When holding shift, this is done 10 times)
- 1 pipe → 1 pipe in a different direction
- 1 detector → 1 upside-down detector
- 1 upside-down detector → 1 detector

### Crafter (place ingredients around it (not diagonally) in any order)

- 4 thick paper → 3 broken paper + 1 water
- 3 wet paper → 3 paper + 1 water (this allows infinite water generators)
- 2 thick paper + 2 broken paper → 2 pumps
- 1 pump + 3 wet paper → extractor
- 2 paper balls → 1 paper
- 4 paper → 1 thick paper
- 4 ancient paper balls → 1 ancient document

### Ancient document (same as crafter)

- 4 ancient paper balls → 1 magic crystal
- 1 magic crystal + 2 thick paper + 1 broken paper → 1 magic spike
- 1 magic crystal + 2 pumps + 1 ancient paper ball → 1 pipe
- 1 magic crystal + 1 pipe + 2 up pipe → 1 detector 



## Mechanics

Things do not work far away from the player, with 2 small exceptions:
- Pump stacks always work if the bottom pump is loaded
- Same with chained pipes, though this mechanic has problems
Everything is updated from left to right, rows going down. Some things don't use buffers (e.g.pipes), which can cause weird behavior.

### Water
For each block of water every tick:
1. If there is empty space below, flow there.
2. Otherwise, if there is empty space in one direction horizomtally, flow there.
3. If there is empty space in both horizontal directions, pick a random one.

### Pump
Lifts water and ancient paperballs. If there is a block of water or ancient paperball below and empty space above, it moves the water up.

### Extractor
If there is a block of water above, it destroys it and has a chance to spawn a paperball or ancient paperball. The chances are 0.3 and 0.02, respectively. If there is something below, it doesnt work, except for thick paper, in which case it works as a water destroyer.

### Pipes
Move all blocks in any direction. They can be chained like pumps (one pipe sends an object through multiple, e.g. `#→↓` sends the # to below the down facing pipe), when facing in different dorections. When they are arranged like `←←`, they create a weird moving object.

###Detector
Works like an up/down facing pipe that cannot be chained. It only sends objects through that also appear in one of its sides, e.g. `#A@` sends # and @ through. Comes in up-facing and down-facing variants.

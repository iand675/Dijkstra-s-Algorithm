# ----------
# readme.txt
# ----------
# Ian Duncan
# Design & Analysis of Algorithms
# December 2, 2009

The program's driver is in main.rb and parses in user commands and the network file into a
Network object, which tracks vertex and edge data and performs user queries on its data.
Assisting the Network object is the PriorityQueue class which implements a simplistic priority
queue for using Dijkstra's algorithm to find the shortest path from a source to a destination.
All relevant graph data is contained within nested hashes, providing relatively fast access
and efficient memory usage for sparse graphs.

Everything in this program works correctly (as far as I can tell), so the only real shortcoming
with this program is that it's implemented in Ruby and is thus rather slow. Also, I used a
home-made priority queue, so it's not terribly efficient and would have trouble with data sets
over several thousand in size.

Since the program is written in Ruby, the program doesn't need compiling. You can run it by
typing 'ruby main.rb' while in the program directory and it will enter a basic REPL where
you can execute commands according to the assignment's specifications and syntax.
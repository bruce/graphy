# Ruby extension implementing a priority queue

## Description
This is a fibonacci-heap priority-queue implementation. That means

    insert:                      O(1)
    decrease_priority: Amortized O(1)
    delete_min:        Amortized O(log n)

This project is different from K. Kodamas PQueue in that it allows a decrease
key operation.  That makes PriorityQueue usable for algorithms like dijkstras
shortest path algorithm, while PQueue is more suitable for Heapsort and the
like.

## Legal stuff
(c) 2005 Brian Schröder

Please submit bugreports to priority_queue@brian-schroeder.de

This extension is under the same license as ruby.

Do not hold me reliable for anything that happens to you, your programs or
anything else because of this extension. It worked for me, but there is no
guarantee it will work for you.

## Requirements
 * Ruby 1.8
 * c Compiler  

## Installation

### Installing from source

De-compress archive and enter its top directory.
Then type:

   ($ su)
    # ruby setup.rb

These simple step installs this program under the default
location of Ruby libraries.  You can also install files into
your favorite directory by supplying setup.rb some options.
Try "ruby setup.rb --help".

### Installing a ruby gem

   ($ su)
    # gem install PriorityQueue

## Usage

In this priority queue implementation the queue behaves similarly to a hash
that maps objects onto priorities.

### Hash Interface
    require 'priority_queue'

    q = PriorityQueue.new
    q["node1"] = 0
    q["node2"] = 1
    q.min #=> "node1"
    q[q.min] #=> 0
    q.min_value #=> 0

    q["node2"] = -1
    q.delete_min #=> "node2", 1
    q["node2"] #= nil
    q["node3"] = 1

    q.delete("node3") #=> "node3", 1
    q.delete("node2") #=> nil


### Queue Interface
    require 'priority_queue'

    q = PriorityQueue.new
    q.push "node1", 0 
    q.push "node2", 1

    q.min #=> "node1"

    q.decrease_priority("node2", -1)

    q.pop_min #=> "node2"
    q.min     #=> "node1"

for more exmples look into the documentation, the unit tests and the benchmark
suite.

### Dijkstras shortest path algorithm
    def dijkstra(start_node)
      # Nodes that may have neighbours wich can be relaxed further
      active = PriorityQueue.new         
      # Best distances found so far
      distances = Hash.new { 1.0 / 0.0 } 
      # Parent pointers describing shortest paths for all nodes
      parents = Hash.new                 

      # Initialize with start node
      active[start_node] = 0
      until active.empty?
	u, distance = active.delete_min
	distances[u] = distance
	d = distance + 1
	u.neighbours.each do | v |
	  next unless d < distances[v] # we can't relax this one
	  active[v] = distances[v] = d
	  parents[v] = u
	end    
      end
      parents
    end

## Performance
The benchmark directory contains an example where a random graph is created and
the shortests paths from a random node in this graph to all other nodes are
calculated with dijkstras shortests path algorithm. The algorithm is used to
compare the three different priority queue implementations in this package.

  * PoorPriorityQueue: A minimal priority queue implementation wich has
    delete_min in O(n).
  * RubyPriorityQueue: An efficent implementation in pure ruby.
  * CPriorityQueue: The same efficent implementation as a c extension.
  
The results are shown here

![Runtime for graphs of up to 8_000 Nodes](doc/compare_small.png "Runtime for graphs of up to 8_000 Nodes")

![Runtime for graphs of up to 600_000 Nodes](doc/compare_big.png "Runtime for graphs of up to 600_000 Nodes")

## Todo
  * Only write documentation once

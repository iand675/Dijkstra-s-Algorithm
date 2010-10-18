#

require 'priority_queue'

# Holds the network graph and performs network managing functions
class Network
  @@infinity = 1.0/0.0 # class constant, infinity for floating point numbers
  attr_reader :vertices
  attr_reader :edges_cost
  attr_reader :edges_up
  
  # initiates member variables
  def initialize()
    @vertices = Hash.new() # holds bools denoting if vertices are up
    @edges_cost = Hash.new() # holds edge costs
    @edges_up = Hash.new() # holds bools denoting if edges are up
  end

  # adds directed edge to graph
  def add_edge(from, to, cost)
    @vertices[from] = true unless @vertices.has_key? from
    @vertices[to]   = true unless @vertices.has_key? to
    
    @edges_cost[from] = Hash.new() unless @edges_cost[from]
    @edges_cost[from].store(to, cost)

    @edges_up[from] = Hash.new() unless @edges_up[from]
    @edges_up[from].store(to, true)
  end
  
  # deletes directed edge from graph
  def delete_edge(from, to)
    @edges_cost[from].delete to
    @edges_up[from].delete to
  end
  
  # makes edge non-traversable in shortest path, but doesn't delete it
  def edge_down(from, to)
    @edges_up[from].store(to, false)
  end
  
  # makes edge traversable again
  def edge_up(from, to)
    @edges_up[from].store(to, true)
  end
  
  # makes vertex non-reachable in shortest path, but doesn't delete it
  def vertex_down(vertex)
    @vertices[vertex] = false
  end
  
  # makes vertex reachable again
  def vertex_up(vertex)
    @vertices[vertex] = true
  end
  
  # performs dijkstra's algorithm and also makes spanning tree
  def shortest_path(root, dest)
    priority = Hash.new
    visited  = Hash.new
    previous = Hash.new
    q = PriorityQueue.new
    @vertices.each do |k, up|
      if up
        priority[k] = @@infinity
        visited[k] = false
        previous[k] = nil
      end
    end
    priority[root] = 0
    q[root] = 0
    until q.empty?
      u = q.delete_min
      visited[u[0]] = true
      break if u[1] == @@infinity
      @edges_cost.each_key do |s|
        @edges_cost[s].each_key do |d|
          if edges_up[s].fetch(d) and vertices[s] and vertices[d]
            if !visited[d] and priority[s] + @edges_cost[s].fetch(d) < priority[d]
              previous[d] = s
              priority[d] = priority[s] + @edges_cost[s].fetch(d)
              q[d] = priority[d]
            end
          end
        end
      end
    end
    prior = dest
    out = "#{prior} "
    while previous[prior]
      out = "#{previous[prior]} " + out
      prior = previous[prior]
    end
    out += "#{priority[dest]}\n"
    print out
    priority[dest]
  end
  
  # prints network data
  def print_network
    @vertices.each_key do |vk|
      print "#{vk}"
      print " DOWN" unless @vertices[vk]
      print "\n"
      if @edges_cost[vk]
        @edges_cost[vk].each do |ek, cost|
            print "  #{ek} #{cost}"
            print " DOWN" unless @edges_up[vk].fetch(ek)
            print "\n"
        end
      end
    end
  end
  
  # prints all vertices reachable by neighboring vertices for each vertex
  # efficiency is O(v*e), where v is the number of vertices and e is the number of edges
  # There can be at most v edges per vertex, so worst case is O(v^2)
  def reachable
    @vertices.each do |vk, is_up|
      if is_up
        print "#{vk}\n"
        if @edges_up[vk]
          @edges_up[vk].each do |ek, up_too|
            if up_too
              print "  #{ek}\n"
            end
          end
        end
      end
    end
  end
end



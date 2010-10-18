# ----------
# network.rb
# ----------
# Ian Duncan
# Design & Analysis of Algorithms
# December 2, 2009


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
    out = []
    from = Hash.new
    @vertices.each_key do |vk|
      str = "#{vk}"
      str += " DOWN" unless @vertices[vk]
      out << str
      if @edges_cost[vk]
        from[str] = []
        @edges_cost[vk].each do |ek, cost|
          str2 =  "  #{ek} #{cost}"
          str2 += " DOWN" unless @edges_up[vk].fetch(ek)
          from[str] << str2
        end
      end
    end
    out.sort!
    out.each do |x|
      puts x
      from[x].sort!
      from[x].each do |y|
        puts y
      end
    end
  end
  
  # prints transitive closure of up nodes and edges
  # efficiency is O(v^3) because it uses Warshall's algorithm
  # Switch commented and uncommented code in reachable to only view neighbor vertices
  def reachable
    # out = []
    #     from = Hash.new
    #     @vertices.each do |vk, is_up|
    #       if is_up
    #         out << "#{vk}"
    #         if @edges_up[vk]
    #           from[vk] = []
    #           @edges_up[vk].each do |ek, up_too|
    #             if up_too
    #               from[vk] << "  #{ek}"
    #             end
    #           end
    #         end
    #       end
    #     end
    #     out.sort!
    #     out.each do |x|
    #       puts x
    #       from[x].sort!
    #       from[x].each do |y|
    #         puts y
    #       end
    #     end
    #   end
    ind = []
    arr = []
    count = 0
    @vertices.each do |vk, is_up|
      if is_up
        ind << vk
        count += 1
      end
    end
    ind.sort!
    arr = Array.new(count) { Array.new(count) }
    ind.size.times do |y|
      ind.size.times do |x|
        if @edges_up[ind[y]].member?(ind[x])
          arr[y][x] = @edges_up[ind[y]].fetch(ind[x])
        end
      end
    end

    ind.size.times do |k|
      ind.size.times do |i|
        ind.size.times do |j|
          arr[i][j] = arr[i][j] or (arr[i][k] and arr[k][j])
        end
      end
    end

    ind.size.times do |y|
      puts ind[y]
      ind.size.times do |x|
        print "  "
        puts ind[x]
      end
    end
  end
end
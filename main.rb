# ----------
# main.rb
# ----------
# Ian Duncan
# Design & Analysis of Algorithms
# December 2, 2009

require 'network'

lines = []
file = File.open("network.txt")
# chunks each line into words
file.each {|line| lines << line.split()}

net = Network.new

# initialize network from network.txt
lines.each do |line|
  net.add_edge(line[0], line[1], line[2].to_f)
  net.add_edge(line[1], line[0], line[2].to_f)
end

# network monitoring REPL
while true
  print "query> "
  line = gets
  line = line.split
  case line[0]
  when "quit"
    break
  when "addedge"
    net.add_edge(line[1], line[2], line[3].to_f)
  when "deleteedge"
    net.delete_edge(line[1], line[2])
  when "edgedown"
    net.edge_down(line[1], line[2])
  when "edgeup"
    net.edge_up(line[1], line[2])
  when "vertexdown"
    net.vertex_down(line[1])
  when "vertexup"
    net.vertex_up(line[1])
  when "path"
    net.shortest_path(line[1], line[2])
  when "print"
    net.print_network
  when "reachable"
    net.reachable
  end
end
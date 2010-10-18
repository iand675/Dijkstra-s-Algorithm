# -----------------
# priority_queue.rb
# -----------------
# Ian Duncan
# Design & Analysis of Algorithms
# December 2, 2009

# used to choose next vertex in Dijkstra's algorithm
class PriorityQueue < Hash # subclasses hash since hash does most things we want already
  def push(object, priority)
    self[object] = priority
  end

  # returns min value's key and value
  def min
    return nil if self.empty?
    min_k = self.keys.first
    min_p = self[min_k]
    self.each do | k, p |
      min_k, min_p = k, p if p < min_p
    end
    [min_k, min_p]
  end

  # returns only min value's key
  def min_key
    min[0] rescue nil
  end
  
  # returns only min value
  def min_priority
    min[1] rescue nil
  end

  # deletes min value but also returns the min value along with its key
  def delete_min
    return nil if self.empty?
    min_k, min_p = *min
    self.delete(min_k)
    [min_k, min_p]
  end

  # removes key and corresponding value from the priority queue
  def delete(object)
    return nil unless self.has_key?(object) 
    result = [object, self[object]]
    super
    result
  end
end

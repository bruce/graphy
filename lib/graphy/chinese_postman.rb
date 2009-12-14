module Graphy

  module ChinesePostman    

    # Returns the shortest walk that traverses all arcs at least
    # once, returning to the specified start node.
    def closed_chinese_postman_tour(start, weight=nil, zero=0)
      cost, path, delta = floyd_warshall(weight, zero)
      return nil unless cp_valid_least_cost? cost, zero
      positive, negative = cp_unbalanced(delta)
      f = cp_find_feasible(delta, positive, negative, zero)
      while cp_improve(f, positive, negative, cost, zero); end
      cp_euler_circuit(start, f, path)
    end

  private
 
    def cp_euler_circuit(start, f, path) # :nodoc:
      circuit = [u=v=start]
      bridge_taken = Hash.new {|h,k| h[k] = Hash.new}
      until v.nil?
        if v=f[u].keys.detect {|k| f[u][k] > 0}
          f[u][v] -= 1
          circuit << (u = path[u][v]) while u != v 
        else
          unless bridge_taken[u][bridge = path[u][start]]
            v = vertices.detect {|v1| v1 != bridge && edge?(u,v1) && !bridge_taken[u][v1]} || bridge
            bridge_taken[u][v] = true
            circuit << v            
          end
        end  
        u=v
      end; circuit
    end
 
    def cp_cancel_cycle(cost, path, f, start, zero) # :nodoc:
      u = start; k = nil
      begin
        v = path[u][start]
        k = f[v][u] if cost[u][v] < zero and (k.nil? || k > f[v][u])
      end until (u=v) != start
      u = start
      begin
        v = path[u][start]
        cost[u][v] < zero ? f[v][u] -= k : f[u][v] += k
      end until (u=v) != start
      true # This routine always returns true to make cp_improve easier
    end
  
    def cp_improve(f, positive, negative, cost, zero) # :nodoc:
      residual = self.class.new
      negative.each do |u|
        positive.each do |v|
          residual.add_edge!(u,v,cost[u][v])
          residual.add_edge!(v,u,-cost[u][v]) if f[u][v] != 0
        end
      end
      r_cost, r_path, r_delta = residual.floyd_warshall(nil, zero)
      i = residual.vertices.detect {|v| r_cost[v][v] and r_cost[v][v] < zero}
      i ? cp_cancel_cycle(r_cost, r_path, f, i) : false
    end
  
    def cp_find_feasible(delta, positive, negative, zero) # :nodoc:
      f = Hash.new {|h,k| h[k] = Hash.new}
      negative.each do |i|
        positive.each do |j|
          f[i][j] = -delta[i] < delta[j] ? -delta[i] : delta[j]
          delta[i] += f[i][j]
          delta[j] -= f[i][j]
        end
      end; f
    end
 
    def cp_valid_least_cost?(c, zero) # :nodoc:
      vertices.each do |i|
        vertices.each do |j|
          return false unless c[i][j] and c[i][j] >= zero
        end
      end; true
    end
  
    def cp_unbalanced(delta) # :nodoc:
      negative = []; positive = []
      vertices.each do |v|
        negative << v if delta[v] < 0
        positive << v if delta[v] > 0
      end; [positive, negative]  
    end

  end # Chinese Postman
end # Graphy
  

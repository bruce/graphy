require File.join(File.dirname(__FILE__), 'spec_helper')

describe "MultiArc" do # :nodoc:

  describe "directed_pseudo_graph" do
    it do
      dpg = DirectedPseudoGraph[ :a,:b,
                               :a,:b,
                               :a,:b ]
      dpg.edges.size.should == 3
      x = 0
      dpg.edges.each {|e| dpg[e] = (x+=1)}
      dpg.edges.inject(0) {|a,v| a+=dpg[v]}.should == 6
    end
  end
  
  describe "directed_multi_graph" do
    it do
      dmg = DirectedMultiGraph[ :a,:a,
                                :a,:a,
                                :a,:b,
                                :a,:b,
                                :b,:b,
                                :b,:b ]
      dmg.edges.size.should == 6
      x = 0
      dmg.edges.each { |e| dmg[e] = (x+=1) }
      dmg.edges.inject(0) {|a,v| a+=dmg[v]}.should == 21
    end
  end
  
end

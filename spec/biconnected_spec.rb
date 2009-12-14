require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Biconnected" do # :nodoc:
  describe "tarjan" do
    it do
      tarjan = UndirectedGraph[ 1, 2,
                                1, 5,
                                1, 6, 
                                1, 7,
                                2, 3, 
                                2, 4,
                                3, 4,
                                2, 5,
                                5, 6,
                                7, 8,
                                7, 9,
                                8, 9 ]
      graphs, articulations = tarjan.biconnected
      articulations.sort.should == [1,2,7]
      graphs.size.should == 4
      graphs.find {|g| g.size == 2}.vertices.sort.should == [1,7]
      graphs.find {|g| g.size == 4}.vertices.sort.should == [1,2,5,6]
      graphs.find {|g| g.size == 3 && g.vertex?(2)}.vertices.sort.should == [2,3,4]
      graphs.find {|g| g.size == 3 && g.vertex?(7)}.vertices.sort.should == [7,8,9]
    end
  end
end

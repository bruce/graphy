require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Arc" do # :nodoc:

  before do
    @e = Arc.new(1,2,'boo')
    @u = Edge.new(1,2,'hoo')
  end

  describe "edge_new" do
    it do
      proc { Arc.new }.should raise_error(ArgumentError)
      proc { Arc.new(1) }.should raise_error(ArgumentError)
      Arc.new(1,2).should be_a_kind_of(Arc)
      Arc.new(1,2,'label').should be_a_kind_of(Arc)
    end
  end

  describe "edge_getters" do
    it do
      @e.source.should == 1
      @e.target.should == 2
      @e.label.should == 'boo'

      @e[0].should == 1
      @e[1].should == 2
      @e[2].should == 'boo'
      
      @e[-3].should == 1
      @e[-2].should == 2
      @e[-1].should == 'boo'

      proc { @e[-4] }.should raise_error(IndexError) 
      proc { @e[3] }.should raise_error(IndexError)  
      
      @e['source'].should == 1
      @e['target'].should == 2
      @e['label'].should == 'boo'

      @e[:source].should == 1
      @e[:target].should == 2
      @e[:label].should == 'boo'
    end
  end

  describe "edge_setters" do
    it do
      @e.source = 23
      @e.target = 42
      @e.label  = 'Yabba'
      @e.source.should == 23
      @e.target.should == 42
      @e.label.should == 'Yabba'

      @e['source'] = 2
      @e['target'] = 1
      @e['label']  = 'Dabba'
      @e.source.should == 2
      @e.target.should == 1
      @e.label.should == 'Dabba'

      @e[:source] = 9
      @e[:target] = 8
      @e['label'] = 'Doooo!'
      @e.source.should == 9
      @e.target.should == 8
      @e.label.should == 'Doooo!'

      @e[0] = 'Fred'
      @e[1] = 'Flintstone'
      @e[2] = 'and'
      @e.source.should == 'Fred'
      @e.target.should == 'Flintstone'
      @e.label.should == 'and'

      @e[-3] = 'Barney'
      @e[-2] = 'Rubble'
      @e[-1] = nil
      @e.source.should == 'Barney'
      @e.target.should == 'Rubble'
      @e.label.should == nil
    end
  end

  describe "edge_simple_methods" do
    it do
      @e.to_a.should == [1,2,'boo']
      @e.to_s.should == "(1-2 'boo')"
      @e.label = nil
      @e.to_s.should == "(1-2)"
      @e.eql?(Arc.new(1,2)).should be_true
      @e.eql?(Arc.new(1,3)).should be_false
      Arc.new(2,1).eql?(@e).should be_false

      @e.should == Arc.new(1,2)
      @e.reverse.should == Arc.new(2,1)
      Arc.new(1,2).should_not == Arc.new(1,3)
      Arc.new(2,1).should_not == @e
    end
  end

  describe "edge_sort" do
    it do
      x = [ Arc.new(2,3), Arc.new(1,3), Arc.new(1,2), Arc.new(2,1) ].sort
      x.should == [Arc.new(1,2), Arc.new(1,3), Arc.new(2,1), Arc.new(2,3)]
    end
  end

  describe "undirected_edge_new" do
    it do
      proc { Edge.new }.should raise_error(ArgumentError)
      proc { Edge.new(1) }.should raise_error(ArgumentError)
      Edge.new(1,2).should be_a_kind_of(Edge)
      Edge.new(1,2,'label').should be_a_kind_of(Edge)
    end
  end

  describe "undirected_edge_getters" do
    it do
      @u.source.should == 1
      @u.target.should == 2
      @u.to_a.should == [1,2,'hoo']
      @u.to_s.should == "(1=2 'hoo')"
    end
  end

  describe "undirected_edge_methods" do
    it do
      @u.label = nil
      @u.to_s.should == "(1=2)"
      Edge.new(2,1).to_s.should == "(1=2)"

      @u.should == Edge.new(2,1)
      @u.should == Edge.new(2,1,'boo')
      @u.should_not == Edge.new(2,3)

      Edge.new(2,1).hash.should == @u.hash
    end
  end

  describe "undirected_edge_sort" do
    it do
      x = [Edge.new(12, 1), Edge.new(2,11)].sort
      x.should == [Edge.new(2,11), Edge.new(1,12)]
    end
  end
  
  describe "hash" do
    it do
      Arc[1,2,:c].should == Arc[1,2,:b]
      Arc[1,2,:c].hash.should == Arc[1,2,:b].hash
      Arc[1,2].should_not == Arc[2,1]
      Arc[1,2].should_not == Edge[1,2]
      Edge[1,2].should == Edge[2,1]
      Edge[1,2,:a].should == Edge[2,1,:b]
    end
  end

end

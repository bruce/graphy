#--
# Copyright (c) 2006 Shawn Patrick Garbett
# Copyright (c) 2002,2004,2005 by Horst Duchene
# 
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
# 
#     * Redistributions of source code must retain the above copyright notice(s),
#       this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright notice,
#       this list of conditions and the following disclaimer in the documentation
#       and/or other materials provided with the distribution.
#     * Neither the name of the Shawn Garbett nor the names of its contributors
#       may be used to endorse or promote products derived from this software
#       without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#++
module Graphy
    
  # This module provides for internal numbering of edges for differentiating between mutliple edges
  module ArcNumber
    
    attr_accessor :number # Used to differentiate between mutli-edges
    
    def initialize(p_source,p_target,p_number,p_label=nil)
      self.number = p_number 
      super(p_source, p_target, p_label)
    end

    # Returns (v,u) if self == (u,v).
    def reverse() self.class.new(target, source, number, label); end
    
    # Allow for hashing of self loops
    def hash() super ^ number.hash; end   
    def to_s() super + "[#{number}]"; end
    def <=>(rhs) (result = super(rhs)) == 0 ? number <=> rhs.number : result; end 
    def inspect() "#{self.class.to_s}[#{source.inspect},#{target.inspect},#{number.inspect},#{label.inspect}]"; end
    def eql?(rhs) super(rhs) and (rhs.number.nil? or number.nil? or number == rhs.number); end 
    def ==(rhs) eql?(rhs); end

    # Shortcut constructor. Instead of Arc.new(1,2) one can use Arc[1,2]
    def self.included(cl)
      
      def cl.[](p_source, p_target, p_number=nil, p_label=nil)
        new(p_source, p_target, p_number, p_label)
      end
    end

  end # ArcNumber
end # Graphy

#!/usr/bin/ruby

require 'kconv'

$KCODE = 'u'

class Node
  attr_reader :segment
  attr_reader :children
  attr_accessor :parent

  def initialize(chunk, segment, parent = nil, children = [])
    @chunk = chunk
    @segment = segment
    @parent = parent
    @children = children
  end

  #
  def has_child?
    not @children.empty?
  end
  
  #
  def each_child
    @children.each{|child|
      yield(child)
    }
  end

  #
  def add_child(child)
    child.parent = self
    @children << child
  end
  
  #
  def getCid
    return @chunk.cid
  end
  
  #
  def getLink
    return @chunk.link
  end
  
  #
  def getSegment
    return @chunk.getSegment
  end
  
  #
  def getParticle
    return @chunk.getParticle
  end
  
  #
  def getPos
    #pos = @chunk.tokens.map{|token| token.pos}
    
    return @chunk.getPos
  end
  
  #
  def filterSegment
    return @chunk.filter
  end
  
  #
  def getPath
    return getAllPath(self)
  end
  
private
  
  def getAllPath(node)
    if node.has_child?
      rlt = []
      node.each_child{|child| rlt.concat(getAllPath(child))}
    else
      rlt = backtrace(node)
    end
    
    return rlt
  end
  
  def backtrace(leaf)
    route = []
    current = leaf
    while current
      route << current.segment
      break if current == self
      current = current.parent
    end
    
    segments = []
    route.each_index{|i| segments << route[route.size-i-1, i+1].to_s}
    
    return segments
  end
  
  #  def to_s
  #    @label
  #  end
  
  #  alias inspcet to_s
end

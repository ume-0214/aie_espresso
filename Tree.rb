#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'kconv'

class Tree

  def initialize(chunks)
    @chunks = chunks
  end

  # 文を取得
  def getSentence
    sentence = @chunks.inject(""){|string, chunk| string + chunk.getSegment}
    
    return sentence
  end

  # 与えられた文節の助詞を取得
  def getParticle(string, particle = [])
    chunk = @chunks.detect{|chunk| chunk.searchString(string)}
    
    particle = chunk.getParticle
    
    return particle
  end
  
  # 与えられた文字列の文節を取得
  def getSegments(string, segments = [])
    segments = @chunks.select{|chunk| chunk.searchString(string)}
    
    return segments
  end

  # 与えられた文節の直前の文節を取得
  def getAnteriorSegment(chunk, segment = nil)
    i = @chunks.index(chunk)
    segment = @chunks[i - 1] if i != 0

    return segment
  end

  # 与えられた文節の直後の文節を取得
  def getPosteriorSegment(chunk, segment = nil)
    i = @chunks.index(chunk)
    segment = @chunks[i + 1] if i != (@chunks.length - 1)

    return segment
  end

  # 与えられた文字列の係り先の文節を取得
  def getNextSegments(chunk)
    nextSegments = @chunks.select{|c| c.cid == chunk.link}
    
    return nextSegments
  end
  
  # 与えられた文字列の係り元の文節を取得
  def getPreSegments(chunk)
    preSegments = @chunks.select{|c| c.link == chunk.cid}
    
    return preSegments		
  end
  
  # 文節内に文字列が含まれているかいないかを判定
  def searchString(searchStr, result = false)
    @chunks.each do |chunk|
      result = chunk.searchString(searchStr)
      break if result
    end
    
    return result
  end
  
end

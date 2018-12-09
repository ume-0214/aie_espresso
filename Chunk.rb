#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'kconv'

class Chunk
  attr_reader :cid
  attr_reader :link
  #attr_reader :rel
  attr_reader :head
  attr_reader :func
  attr_reader :score
  attr_reader :tokens

  def initialize(cid, link, head, func, score, tokens = [])
    @cid = cid
    @link = link
    @head = head
    @func = func
    @score = score
    @tokens = tokens
  end

  # 文節の取得
  def getSegment
    segment = @tokens.inject(""){|string, token| string + token.surface}

    return segment
  end

  # 記号を削除した文節の取得
  def cut_symbol(string= "", s = 0, e = @tokens.length - 1)
    #s = 1 if @tokens[s].get_pos_0 == "記号"
    e = @tokens.length - 2 if @tokens[e].get_pos_1 == "句点" || @tokens[e].get_pos_1 == "読点"

    for i in s..e
      string += @tokens[i].surface
    end

    return string
  end

  # 文節のlinkを取得
  def getLink(string, link = nil)
    link = @link if searchString(string)

    return link
  end

  # 文節のcidを取得
  def getCid(string, cid = nil)
    cid = @cid if searchString(string)

    return cid
  end

  # 助詞の一覧を取得
#  def getPos
#    pos = @tokens.map{|token| token.pos}
#
#    return pos
#  end

  # 助詞の取得
  def getParticle(particle = "")
    @tokens.each do |token|
      surface = token.surface

      pos_0 = token.get_pos_0
      pos_1 = token.get_pos_1

      break if (pos_0 == "助詞" && surface == "て") || (pos_1 == "連体化" && surface == "の") || (pos_1 == "並立助詞" && surface == "と")

      if pos_0 == "助詞"
        particle += surface
      elsif pos_0 == "名詞" && surface == "の"
        particle += surface
      end
    end
    
    return particle
  end

  # 文字列の検索
  def searchString(str, result = false)
    segment = getSegment
    result = true if str == segment[0..(str.length - 1)]

    return result
  end
end

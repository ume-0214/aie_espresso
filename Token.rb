#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'kconv'

class Token
#	attr_reader :surface
#	attr_reader :read
#	attr_reader :base
#	attr_reader :pos
#	attr_reader :ctype
#	attr_reader :cform
#	attr_reader :ne

  attr_reader :surface
  attr_reader :feature_list
  attr_reader :ne

  def initialize(token)
    @surface = token.normalized_surface.toutf8
    @feature_list = []
    @ne = token.ne.toutf8
    
    (0..(token.feature_list_size-1)).each do |i|
      @feature_list << token.feature_list(i).toutf8
    end
  end

  def get_pos_0
    return feature_list[0]
  end

  def get_pos_1
    return feature_list[1]
  end

  def has_particle?(flg = false)
    flg = true if feature_list[0] == "助詞"

    return flg
  end

  def has_auxiliary_verb?(flg = false)
    flg = true if feature_list[0] == "助動詞"

    return flg
  end

  def has_adverb?(flg = false)
    flg = true if feature_list[0] == "副詞"

    return flg
  end

  def has_verb?(flg = false)
    flg = true if feature_list[0] == "動詞"

    return flg
  end

  def has_noun?(flg = false)
    flg = true if feature_list[0] == "名詞"

    return flg
  end

  def has_anti_independence?(flg = false)
    flg = true if feature_list[1] == "非自立"

    return flg
  end
    
  def has_pronoun?(flg = false)
    flg = true if feature_list[1] == "代名詞"

    return flg
  end

  def has_adjective_suffix?(flg = false)
    flg = true if feature_list[1] == "形容動詞語幹"

    return flg
  end

  def has_point?(flg = false)
    flg = true if feature_list[1] == "句点"

    return flg
  end

  def has_case_particle?(flg = false)
    flg = true if feature_list[1] == "格助詞"

    return flg
  end

  def has_dependency_particle?(flg = false)
    flg = true if feature_list[1] == "係助詞"

    return flg
  end

end

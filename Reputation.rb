#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'kconv'

class Reputation

  attr_reader :sentence
  attr_reader :seed
  attr_reader :common

  def initialize(sentence, seed, common)
    @sentence = sentence
    @seed = seed
    @common = common
  end
end

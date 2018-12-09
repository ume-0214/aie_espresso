#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'kconv'
require 'Seed'

# 共通頻出表現クラス
class Common

  # 種表現の総数
  @@seed_sum = {}

  # 種表現の異なり数
  @@seed_var = {}

  # 共通頻出表現	
  attr_reader :name

  # 共通頻出表現から得られた種表現
  attr_reader :seeds

  # 共通頻出表現の重み
  attr_accessor :weight

  # 相互情報量
  attr_accessor :pmi

  def initialize(common, seeds = {}, pmi = {})
    @name = common
    @seeds = seeds
    @pmi = pmi
  end

  # 初期化
  def self.clear
    @@seed_sum.clear
    @@seed_var.clear
  end

  # 種表現の追加
  def add_seed(seed)
    if @seeds.key?(seed)
      @seeds[seed] += 1
    elsif
      @seeds.store(seed, 1)
    end

    if @@seed_sum.key?(seed)
      @@seed_sum[seed] += 1
    elsif
      @@seed_sum.store(seed, 1)
    end

    if @@seed_var.key?(seed)
      @@seed_var[seed] << @name unless @@seed_var[seed].include?(@name)
    else
      @@seed_var.store(seed, [@name])
    end
  end

  # 種表現の取得
  def each_seed
    @seeds.each_key do |seed|
      yield seed
    end
  end

  # 与えられた種表現の個数を取得
  def get_seed_count(seed)
    return @seeds[seed]
  end

  # 与えられた種表現の総数を取得
  def get_seed_sum(seed)
    return @@seed_sum[seed]
  end

  # 与えられた種表現の異なり数を取得
  def get_seed_var(seed)
    return @@seed_var[seed].length
  end

  # 共通頻出表現の総数を獲得
  def get_common_sum(total = 0)
    @seeds.each_value do |count|
      total += count
    end

    return total
  end

  # PMIの最大値を取得
  def get_max_pmi
    sort_pmi = pmi.to_a.sort{|pmi1, pmi2|
      (pmi2[1] <=> pmi1[1]) * 2 + (pmi1[0] <=> pmi2[0])
    }

    return sort_pmi[0][1]
  end

  # 種表現候補の獲得
  def getSeeds(tree, seeds = [])
    segments = tree.getSegments(@name)

    segments.each do |segment|
      string = segment.cut_symbol
      particle = segment.getParticle
      common = string[0..(string.length - particle.length - 1)]

      next if @name != common

      nextSegments = tree.getNextSegments(segment)

      nextSegments.each do |nextSegment|
        other = nextSegment.cut_symbol

        next if particle == "など" || particle.empty? || other.empty? || other.length == 1

        seeds << Seed.new(particle + other, particle, other)
      end
    end

    return seeds
  end

end

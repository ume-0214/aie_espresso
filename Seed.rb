#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'kconv'
require 'Common'

# 種表現クラス
class Seed

  # 共通頻出表現の総数
  @@common_sum = {}

  # 共通頻出表現の異なり数
  @@common_var = {}

  # 種表現
  attr_reader :name

  # 種表現の助詞
  attr_reader :particle

  # 種表現の助詞以外の形態素列
  attr_reader :other

  # 共通頻出表現
  attr_reader :commons

  # 種表現の重み
  attr_accessor :weight

  # 相互情報量
  attr_accessor :pmi

  def initialize(seed, particle, other, commons = {}, pmi = {})
    @name = seed
    @particle = particle
    @other = other
    @commons = commons
    @pmi = pmi
  end

  # 初期化
  def self.clear
    @@common_sum.clear
    @@common_var.clear
  end

  # 共通頻出表現の追加
  def add_common(common)
    if @commons.key?(common)
      @commons[common] += 1
    elsif
      @commons.store(common, 1)
    end

    if @@common_sum.key?(common)
      @@common_sum[common] += 1
    elsif
      @@common_sum.store(common, 1)
    end

    if @@common_var.key?(common)
      @@common_var[common] << @name unless @@common_var[common].include?(@name)
    else
      @@common_var.store(common, [@name])
    end
  end

  # 共通頻出表現の取得
  def each_common
    @commons.each_key do |common|
      yield common
    end
  end

  # 与えられた共通頻出表現の個数を取得
  def get_common_count(common)
    return @commons[common]
  end

  # 与えられた共通頻出表現の総数を取得
  def get_common_sum(common)
    return @@common_sum[common]
  end

  # 与えられた共通頻出表現の異なり数を取得
  def get_common_var(common)
    return @@common_var[common].length
  end

  # 種表現の総数を獲得
  def get_seed_sum(total = 0)
    @commons.each_value do |count|
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

  # 共通頻出表現候補の獲得
  def getCommons(tree, commons = [])
    segments = tree.getSegments(@other)

    segments.each do |segment|
      s = segment.cut_symbol

      next if s != @other

      preSegments = tree.getPreSegments(segment)

      preSegments.each do |segment|
        # 代名詞、非自立、形容動詞語幹、動詞、助動詞は除去
        stopword = segment.tokens.select{|token| token.has_pronoun? || token.has_anti_independence? || token.has_adjective_suffix? || token.has_verb? || token.has_auxiliary_verb?}
        next unless stopword.empty?

        if segment.getParticle == @particle
          string = segment.cut_symbol
          common = string[0..(string.length - @particle.length - 1)]

          # 数値のみの文字列は除去
          commons << Common.new(common) unless common =~ /^[+-]?\d+$/
        end
      end
    end

    return commons
  end

end

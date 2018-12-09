#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'kconv'
require 'Seed'

# 種表現を管理するクラス
class SeedsManager

  def initialize(dbManager)
    @seeds = {}
    @dbManager = dbManager
  end

  # 共通頻出表現 → 種表現
  def add(seed, common)
    @seeds[seed.name] = seed unless @seeds.key?(seed.name)
    @seeds[seed.name].add_common(common.name)
  end

  # 与えられた種表現のエントロピーの値を取得
#  def get_entropy(seed)
#    return @seeds[seed.name].entropy
#  end

  # 種表現クラスの獲得
  def each_seed
    @seeds.each_value do |seed|
      yield seed
    end
  end

  # 初期化
  def clear_seeds
    @seeds.clear
    Seed.clear
  end

  # 共通頻出表元候補の獲得
  def getCandidateCommons(seed, sentence)
    s = @seeds[seed.name]
    tree = @dbManager.getTree(sentence)

    if tree != nil
      candidateCommons = s.getCommons(tree)
      return candidateCommons
    else
      return []
    end
  end

  # 信頼度の計算
  def cal_reliability(commons, t, seeds = [], tmp = {}, tmp_seeds = [])
    commons.each do |common|
      tmp[common.name] = common.weight
    end

    cal_pmi
    max = max_pmi

    @seeds.each_value do |seed|
      weight = 0

      seed.commons.each_key do |common|
        weight += (seed.pmi[common] / max.to_f) * tmp[common]
      end

      seed.weight = weight / commons.length
      tmp_seeds << seed
    end

    seeds = tmp_seeds.sort{|seed1, seed2| seed2.weight <=> seed1.weight}

    return seeds[0..t]
  end

  private

  # PMIの計算
  def cal_pmi(n = 0)
    @seeds.each_value do |seed|
      n += seed.get_seed_sum
    end

    @seeds.each_value do |seed|
      seed.commons.each do |common, count|
        min = 0
        seed_sum = seed.get_seed_sum
        common_sum = seed.get_common_sum(common)

        if seed_sum < common_sum
          min = seed_sum.to_f
        else
          min = common_sum.to_f
        end

        pmi = Math.log10((n.to_f * count.to_f) / (common_sum.to_f * seed_sum.to_f)) * (count.to_f / (count.to_f + 1)) * (min / (min + 1))
        seed.pmi[common] = pmi
      end
    end
  end

  # PMIの最大値を取得
  def max_pmi(pmi_list = [])
    @seeds.each_value do |seed|
      pmi = seed.get_max_pmi
      pmi_list << pmi
    end

    return pmi_list.max
  end

end

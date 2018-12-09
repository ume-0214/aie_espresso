#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'kconv'
require 'Common'

# 複数の共通頻出表現を管理するクラス
class CommonsManager

  def initialize(dbManager)
    @commons = {}
    @dbManager = dbManager
  end

  # 共通頻出表現と種表現の追加
  def add(common, seed)
    @commons[common.name] = common unless @commons.key?(common.name)
    @commons[common.name].add_seed(seed.name)
  end

  # 与えられた共通頻出表現のエントロピーの値を取得
#  def get_entropy(common)
#    return @commons[common].entropy
#  end

  # 共通頻出表現クラスの取得
  def each_common
    @commons.each_value do |common|
      yield common
    end
  end

  # 共通頻出表現の情報を初期化
  def clear_commons
    @commons.clear
    Common.clear
  end

  # 種表現候補の取得
  def getCandidateSeeds(common, sentence)
    c = @commons[common.name]
    tree = @dbManager.getTree(sentence)

    if tree != nil
      candidateSeeds = c.getSeeds(tree)
      return candidateSeeds
    else
      return []
    end
  end

  # 信頼度の計算
  def cal_reliability(seeds, t, commons = [], tmp = {}, tmp_commons = [])
    seeds.each do |seed|
      tmp[seed.name] = seed.weight
    end

    cal_pmi
    max = max_pmi

    @commons.each_value do |common|
      weight = 0

      common.seeds.each_key do |seed|
        weight += (common.pmi[seed] / max.to_f) * tmp[seed] 
      end

      common.weight = weight / seeds.length
      tmp_commons << common
    end

    commons = tmp_commons.sort{|common1, common2| common2.weight <=> common1.weight}

    return commons[0..t]
  end

  private

  # PMIの計算
  def cal_pmi(n = 0)
    @commons.each_value do |common|
      n += common.get_common_sum
    end

    @commons.each_value do |common|
      common.seeds.each do |seed, count|
        min = 0
        common_sum = common.get_common_sum
        seed_sum = common.get_seed_sum(seed)

        if common_sum < seed_sum
          min = common_sum.to_f
        else
          min = seed_sum.to_f
        end

        pmi = Math.log10((n.to_f * count.to_f) / (seed_sum.to_f * common_sum.to_f)) * (count.to_f / (count.to_f + 1)) * (min / (min + 1))
        common.pmi[seed] = pmi
      end
    end
  end

  # PMIの最大値を取得
  def max_pmi(pmi_list = [])
    @commons.each_value do |common|
      pmi = common.get_max_pmi
      pmi_list << pmi
    end

    return pmi_list.max
  end

end

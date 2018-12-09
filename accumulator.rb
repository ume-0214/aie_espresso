#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'kconv'
require 'csv'

# 閾値
t = ARGV[0]

# 初期評価表現
init = ARGV[1]

init_weight = 1.0 / init.to_f

path = "/home/ume/workspace/kakaku_result/Camera/examination_result/p-"

seed = {"が良い" => init_weight, "が悪い" => init_weight}
#seed = {"が良い" => init_weight, "が悪い" => init_weight, "が良いです" => init_weight, "は高いです" => init_weight, "は最高です" => init_weight, "も良い" => init_weight}
#seed = {"が良い" => init_weight, "が悪い" => init_weight, "が良いです" => init_weight, "は高いです" => init_weight, "は最高です" => init_weight, "も良い" => init_weight, "もよく" => init_weight, "は満足です" => init_weight, "は良いと" => init_weight, "は素晴らしいです" => init_weight}
common = {}

(1..10).each do |f|
  lines = []

  CSV.readlines(path + f.to_s + "/seed_" + init + "_" + t + ".csv").each do |line|
    lines << line
  end

  for i in 2..(lines.length - 1)
    line = lines[i]

    if seed.key?(line[0].toutf8)
      seed[line[0].toutf8] += line[1].to_f
    else
      seed.store(line[0].toutf8, line[1].to_f)
    end
  end

end

(1..10).each do |f|
  lines = []

  CSV.readlines(path + f.to_s + "/common_" + init + "_" + t + ".csv").each do |line|
    lines << line
  end

  for i in 2..(lines.length - 1)
    line = lines[i]

    if common.key?(line[0].toutf8)
      common[line[0].toutf8] += line[1].to_f
    else
      common.store(line[0].toutf8, line[1].to_f)
    end
  end

end

sort_seed = seed.to_a.sort{|seed1, seed2|
  (seed2[1] <=> seed1[1]) * 2 + (seed1[0] <=> seed2[0])
}

sort_common = common.to_a.sort{|common1, common2|
  (common2[1] <=> common1[1]) * 2 + (common1[0] <=> common2[0])
}

seed_path = "/home/ume/workspace/kakaku_result/Camera/examination_result/p-sum/seed_" + init + "_" + t + ".csv"
common_path = "/home/ume/workspace/kakaku_result/Camera/examination_result/p-sum/common_" + init + "_" + t + ".csv"

CSV.open(seed_path, 'w') do |writer|
  writer << ["", "weight"]

  sort_seed.each do |key, value|
    writer << [key, value]
  end
end

CSV.open(common_path, 'w') do |writer|
  writer << ["", "weight"]

  sort_common.each do |key, value|
    writer << [key, value]
  end
end

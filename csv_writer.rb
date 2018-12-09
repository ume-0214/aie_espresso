#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'kconv'
require 'csv'

# ソートしてCSVファイルに書き込み
def write_csv(row, column, weight_list, path)
  elements = {}

  for i in 0..(row.length - 1)
    line = row[i]
    key = line[1]

    if elements.key?(key)
      elements[key] << line
    else
      elements.store(key, [line])
    end
  end

  sort_elements = elements.keys.sort.reverse

  CSV.open(path, 'w') do |writer|
    writer << column
    writer << weight_list

    sort_elements.each do |key|
      lines = elements[key]
      
      lines.each do |line|
        writer << line
      end
    end
  end

end

# test
def write_common_test(num, init, t, seeds, commonsManager, column = [], weight_list = [], row = [])
  path = "/home/ume/workspace/kakaku_result/Camera/examination_result/e-" + num.to_s + "/sort_common_" + init + "_" + t + ".csv"

  column[0..1] = "", "weight"
  weight_list[0..1] = "weight", ""

  seeds.each do |seed|
    column << seed.name
    weight_list << seed.weight
  end

  commonsManager.each_common do |common|
    line = Array.new(column.length, 0)

    line[0..1] = common.name, common.weight

    common.each_seed do |seed|
      index = column.index(seed)
      line[index] = common.get_seed_count(seed)
    end

    row << line
  end

  write_csv(row, column, weight_list, path)
end

# test
def write_seed_test(num, init, t, commons, seedsManager, column = [], weight_list = [], row = [])
  path = "/home/ume/workspace/kakaku_result/Camera/examination_result/e-" + num.to_s + "/sort_seed_" + init + "_" + t + ".csv"

  column[0..1] = "", "weight"
  weight_list[0..1] = "weight", ""

  commons.each do |common|
    column << common.name
    weight_list << common.weight
  end

  seedsManager.each_seed do |seed|
    line = Array.new(column.length, 0)

    line[0..1] = seed.name, seed.weight

    seed.each_common do |common|
      index = column.index(common)
      line[index] = seed.get_common_count(common)
    end

    row << line
  end

  write_csv(row, column, weight_list, path)
end

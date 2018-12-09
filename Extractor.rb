#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'kconv'
require 'csv'
require 'Reputation'
require 'FileReader'
require 'ResultReader'
require 'DbManager'
require 'Common'

# 閾値
t = ARGV[0]

# 初期評価表現
init = ARGV[1]

# 反復回数
iteration = ARGV[2]

# 上位からの獲得個数
top = ARGV[3]

# 使用するデータベースのパス
dbPath = "/home/ume/workspace/experiment_data/kakaku_db/Camera.naist_db"

# 使用するカテゴリーのパス
filePath = "normalized_sentence.txt"

# 結果が出力されているテキストのパス
seed_path = "/home/ume/workspace/kakaku_result/Camera/examination_result/e-" + iteration + "/sort_seed_" + init + "_" + t + ".csv"
common_path = "/home/ume/workspace/kakaku_result/Camera/examination_result/e-" + iteration + "/sort_common_" + init + "_" + t + ".csv"

# 書き込みするテキストのパス
write_path = "/home/ume/workspace/kakaku_result/Camera/extraction_result/espresso/" + top + "/result_" + iteration + "_" + init + "_" + t + ".csv"

result_reader = ResultReader.new(seed_path, common_path)
file_reader = FileReader.new(filePath)
dbManager = DbManager.new(dbPath)

result_reader.csv_seed_read(top.to_i)
result_reader.csv_common_read(top.to_i)
corpus = file_reader.read

commons = {}
results = []

# データベースを開く
dbManager.open

# 共通頻出表現を含んでいる文を取得
result_reader.each_common do |c|
  sentences = corpus.select{|sentence| sentence.include?(c)}
  common = Common.new(c)
  commons[common] = sentences
end

# 共通頻出表現が種表現に係っている文を取得
commons.each do |common, sentences|
  sentences.each do |sentence|
    tree = dbManager.getTree(sentence)
    candidateSeeds = common.getSeeds(tree)

    result_reader.each_seed do |s|
      candidateSeeds.each do |candidateSeed|
        results << Reputation.new(sentence, s, common.name) if candidateSeed.name == s
      end
    end

  end
end

# データベースを閉じる
dbManager.close

CSV.open(write_path, 'w') do |writer|
  writer << ["result", "評価項目", "評価表現", "評判情報"]

  results.each do |reputation|
    writer << ["", reputation.common.toutf8, reputation.seed.toutf8, reputation.sentence.toutf8]
  end
end

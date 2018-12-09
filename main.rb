#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'kconv'
require 'FileReader'
require 'DbManager'
require 'SeedsManager'
require 'CommonsManager'
require 'csv_writer'

# 閾値の設定
t = ARGV[0]

# 使用するデータベースのパス
dbPath = "/home/ume/workspace/experiment_data/kakaku_db/Camera.naist_db"

# 使用するカテゴリーのパス
filePath = "normalized_sentence.txt"

# 初期種表現のパス
init_path = "init_seed_100.txt"

# 種表現を格納する配列の初期化
seeds = []

# 共通頻出表現を格納する配列の初期化
commons = []

# 初期種表現の格納
open(init_path) do |io|
  io.readlines.each do |line|
    next if line[0] == "#"
    ary = line.chomp.split(",")
    seeds << Seed.new(ary[0], ary[1], ary[2])
  end
end

init = seeds.length
seeds.map{|seed| seed.weight = 1.0}

reader = FileReader.new(filePath)
dbManager = DbManager.new(dbPath)
seedsManager = SeedsManager.new(dbManager)
commonsManager = CommonsManager.new(dbManager)

corpus = reader.read

# データベースを開く
dbManager.open

for i in 0..9

  tmp_seed = {}
  tmp_common = {}

  # 種表現を含んでいる文の取得
  seeds.each do |s|
    sentences = corpus.select{|sentence| sentence.include?(s.other)}
    tmp_seed[s] = sentences
  end

  # 共通頻出元候補の獲得
  tmp_seed.each do |s, sentences|
    sentences.each do |sentence|
      tree = dbManager.getTree(sentence)
      candidateCommons = s.getCommons(tree)
      candidateCommons.map{|candidateCommon| commonsManager.add(candidateCommon, s)}
    end
  end

  commons = commonsManager.cal_reliability(seeds, (t.to_i - 1))
  write_common_test(i + 1, init.to_s, t, seeds, commonsManager)

  commons.each do |c|
    print c.name + ":" + c.weight.to_s + "\n"
  end
  print "-----------------------------------\n"

  # 共通頻出表現を含んでいる文を取得
  commons.each do |c|
    sentences = corpus.select{|sentence| sentence.include?(c.name)}
    tmp_common[c] = sentences
  end

  # 種表現候補の獲得
  tmp_common.each do |c, sentences|
    sentences.each do |sentence|
      tree = dbManager.getTree(sentence)
      candidateSeeds = c.getSeeds(tree)
      candidateSeeds.map{|candidateSeed| seedsManager.add(candidateSeed, c)}
    end
  end

  seeds = seedsManager.cal_reliability(commons, (t.to_i - 1))
  write_seed_test(i + 1, init.to_s, t, commons, seedsManager)

  seeds.each do |seed|
    print seed.name + ":" + seed.weight.to_s + "\n"
  end
  print "-----------------------------------\n"

  commonsManager.clear_commons
  seedsManager.clear_seeds

#  print "seeds" + seeds.length.to_s + "\n"
#  print "commons" + commons.length.to_s + "\n"
end

# データベースを閉じる
dbManager.close

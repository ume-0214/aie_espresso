#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'kconv'
require 'csv'

# 出力結果の読み込みを行なうクラス
class ResultReader

  def initialize(seed_path, common_path, seeds = [], commons = [])
    @seed_path = seed_path
    @common_path = common_path
    @seeds = seeds
    @commons = commons
  end

  # CSVの出力結果の読み込み（種表現）
  def csv_seed_read(top, lines = [])
    CSV.readlines(@seed_path).each do |line|
      lines << line
    end

    for i in 2..(top + 2)
      line = lines[i]
      @seeds << line[0].toutf8
    end

  end

  # CSVの出力結果の読み込み（共通頻出表現）
  def csv_common_read(top, lines = [])
    CSV.readlines(@common_path).each do |line|
      lines << line
    end

    for i in 2..(top + 2)
      line = lines[i]
      @commons << line[0].toutf8
    end

  end

  # 種表現の取得
  def each_seed
    @seeds.each do |s|
      yield(s)
    end
  end

  # 共通頻出表現の取得
  def each_common
    @commons.each do |c|
      yield(c)
    end
  end

end

#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'kconv'
require 'Token'
require 'Chunk'
require 'Tree'
require 'tokyocabinet'
include TokyoCabinet

class DbManager

  def initialize(path)
    @path = path
    @tdb = TDB::new
  end

  # 全ての文を取得
  def read(sentences = [])
    @tdb.each_key do |sentence|
      sentences << sentence.toutf8
    end

    return sentences
  end

  # 与えられた文の解析結果を取得
  def getTree(sentence)
    data = @tdb[sentence]
    tree = Marshal.load(data["parse"]) if data

    if data != nil
      return tree
    else
      return nil
    end
  end

  # データベースを開く
  def open
    @tdb.open(@path, TDB::OWRITER | TDB::OCREAT)
  end

  # データベースを閉じる
  def close
    @tdb.close
  end

  # 文字列の検索
  def search_sentence(str)
    @qry = TDBQRY::new(@tdb)
    @qry.addcond("str", TDBQRY::QCFTSPH, str)
    sentences = @qry.search

    return sentences
  end

end

#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'kconv'
require 'csv'
require 'CaboCha'
require 'Token'
require 'Chunk'
require 'Tree'
require 'tokyocabinet'
include TokyoCabinet

class Sentence
  attr_reader :sentence
  attr_reader :file

  def initialize(sentence, file)
    @sentence = sentence
    @file = file
  end
end

path = "/home/ume/workspace/experiment_data/kakaku_db/Camera.naist_db"
write_path = "answer.csv"
list = []

tdb = TDB::new
tdb.open(path, TDB::OWRITER | TDB::OCREAT)

tdb.each do |key, value|
  list << Sentence.new(key.toutf8, value["file"].toutf8)
end

tdb.close

sample = list.to_a.sample(2000)

CSV.open(write_path, "w") do |writer|
  sample.each do |data|
    writer << ["", data.file.toutf8, data.sentence.toutf8]
  end
end

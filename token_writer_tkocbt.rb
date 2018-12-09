#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'kconv'
require 'CaboCha'
require 'Token'
require 'Chunk'
require 'Tree'
require 'find'
require 'tokyocabinet'
include TokyoCabinet

def parse(sentence, c)
  tree =  c.parse(sentence)
  size =  tree.size()
  
  chunks = Array.new()
  current_chunk = nil
  
  cid = 0
  
  (0..size-1).each do |i| 
    token = tree.token(i)
    chunk = token.chunk
    
    if (chunk)
      current_chunk = Chunk.new(cid, chunk.link, chunk.head_pos, chunk.func_pos, chunk.score)
      cid += 1
      chunks << current_chunk
    end
    #current_chunk.tokens << Token.new(token.surface(), token.read(), token.base(), token.pos(), token.cform(), token.ctype(), token.ne())
    #current_chunk.tokens << Token.new(token.surface(), token.pos())
    current_chunk.tokens << Token.new(token)
  end
  
  t = Tree.new(chunks)
  
  return t
end

c = CaboCha::Parser.new
#c = CaboCha::Parser.new([$0] + ARGV)

tdb = TDB::new

# データベースを開く
tdb.open("/home/ume/workspace/experiment_data/kakaku_db/Camera.naist_db", TDB::OWRITER | TDB::OCREAT)

Find.find(File.expand_path("/home/ume/workspace/experiment_data/kakaku_review_text/Camera/")) do |path|
  next if File.directory?(path)
  
  p path
  
  open(path) do |io|
    while sentence = io.gets
      if sentence != "\n"
        sentence.chomp!
        next if sentence.empty?
        tree = parse(sentence, c)
        dump = Marshal.dump(tree)
        normalized_sentence = tree.getSentence.toutf8
        print "false\n" unless tdb.put(normalized_sentence, { "str" => normalized_sentence, "parse" => dump, "file" => File.basename(path)})
      end
    end
  end
  
end

# データベースを閉じる
tdb.close

#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'kconv'
require 'find'
require 'CaboCha'
require 'Token'
require 'Chunk'
require 'Tree'
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

    current_chunk.tokens << Token.new(token)
  end
  
  t = Tree.new(chunks)
  
  return t
end

c = CaboCha::Parser.new
sentences = []

Find.find(File.expand_path("/home/ume/workspace/experiment_data/kakaku_review_text/Camera/")) do |path|
  next if File.directory?(path)
  
  p path
  
  open(path) do |io|
    while sentence = io.gets
      if sentence != "\n"
        sentence.chomp!
        next if sentence.empty?
        tree = parse(sentence, c)
        normalized_sentence = tree.getSentence.toutf8
				sentences << normalized_sentence
      end
    end
  end
  
end

open("normalized_sentence.txt", "w") do |io|
	io.puts(sentences)
end

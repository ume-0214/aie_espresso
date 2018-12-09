#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'kconv'
require 'find'

class FileReader

  def initialize(path)
    @path = path
  end

  def read(sentences = [])
    open(@path) do |io|
      while sentence = io.gets
        sentences << sentence.chomp!
      end
    end

    return sentences
  end

  def readFiles(sentences = [])
    Find.find(File.expand_path(@path)) do |path|
      next if File.directory?(path)
      
      #p path
      
      open(path) do |io|
        io.readlines.each do |line|
          line.chomp!
          sentences << line if !(line.empty?)
        end
      end
    end
    
    return sentences
  end
  
end

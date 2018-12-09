#!/usr/bin/ruby

require 'kconv'
#require 'CaboCha'
require 'Token'
require 'Chunk'
require 'Tree'

$KCODE = 'u'

class Corpus

#	attr_accessor :corp

	def initialize
		@corp = []
#		@c = CaboCha::Parser.new([$0] + ARGV);
	end

	# 解析結果をcorpに追加
	def addTree(trees)
		@corp.concat(trees)
	end
  
	# 与えられた文をかぼちゃで解析し、解析結果をcorpに追加
#  def add(sentence)
#		tree =  @c.parse(sentence)
#		size =  tree.size()
#
#		chunks = Array.new()
#		current_chunk = nil
#
#		cid = 0
#
#		(0..size-1).each do |i| 
#  		token = tree.token(i)
#  		if (token.hasChunk()) 
#  	  	chunk = token.chunk()
#				current_chunk = Chunk.new(cid, chunk.link(), chunk.rel(), chunk.head(), chunk.func(), chunk.score())
#  	  	cid += 1
#				chunks << current_chunk
#	  	end
#			current_chunk.tokens << Token.new(token.surface(), token.read(), token.base(), token.pos(), token.cform(), token.ctype(), token.ne())
#		end
#
#		t = Tree.new(chunks)
#
#		@corp << t
#  end

	# 与えられた文字列を含んでいる文の解析結果を抽出
	def extractTrees(string, trees = [])

		@corp.each do |tree|
			if tree.getSentence.include?(string)
				trees << tree
			end
		end

		return trees
	end

	# corpの内容を出力
#  def output
#		@corp.each do |tree|
#			p tree.getSentence().toutf8
#			tree.chunks.each do |chunk|
#				printf "* %d %d/%s %d/%d %f\n", chunk.cid, chunk.link, chunk.rel, chunk.head, chunk.func, chunk.score
#				chunk.tokens.each do |token|
#					 printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\n",
#						token.surface.toutf8, token.read.toutf8, token.base.toutf8,
#						token.pos.toutf8, token.cform.toutf8, token.ctype.toutf8, token.ne.toutf8
#				end
#			end
#			print "-----------------------------------------------------------------------\n"
#			sleep 0.5
#		end
#  end

end

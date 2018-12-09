#!/usr/bin/ruby

require 'kconv'
require 'DerivationExpression'

# 核文節クラス
class Core
	attr_reader :core
	attr_reader :derivationExpression
#	attr_reader :derivedExpression
#	attr_reader :segmentCount
#	attr_reader :seeds

	def initialize(core)
		@core = core
		@derivationExpression = {}
#		@seeds = {seed => 1}
#		@derivedExpression = {}
#		@segmentCount = {}
	end

	# 表現の追加
	def add(segment, count, seed)
		@derivationExpression[segment] = DerivationExpression.new(segment, count) unless @derivationExpression.key?(segment)
		@derivationExpression[segment].add(seed)
	end

	# 核文節から派生する表現の総数の取得
	def getDerivedExpressionTotal(total = 0)
		@derivationExpression.each_value do |element|
			total += element.count
		end

		return total
	end

	#
	def search(segment)
		if @derivationExpression.key?(segment)
			return @derivationExpression[segment]
		else
			return false
		end
	end

	# 表現の追加
#	def addSegment(segment, count)
#		if @derivedExpression.key?(segment)
#			@derivedExpression[segment] += 1
#		else
#			@derivedExpression.store(segment, 1)
#			@segmentCount.store(segment, count)
#		end
#	end

	# 種表現の追加
#	def addSeed(seed)
#		if @seeds.key?(seed)
#			@seeds[seed] += 1
#		else
#			@seeds.store(seed, 1)
#		end
#	end

	# 核文節から派生する表現の総数の取得
#	def getDerivedExpressionTotal(total = 0)
#		@derivedExpression.each_value do |count|
#			total += count
#		end
#
#		return total
#	end

	#
#	def search(segment)
#		if @derivedExpression.key?(segment)
#			return self
#		else
#			return false
#		end
#	end

end

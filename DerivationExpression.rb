#!/usr/bin/ruby

require 'kconv'

$KCODE = 'u'

# 派生表現クラス
class DerivationExpression

	attr_reader :expression
	attr_reader :segmentCount
	attr_reader :count
	attr_reader :seeds

	def initialize(expression, segmentCount, seed = {})
		@expression = expression
		@segmentCount = segmentCount
		@count = 1
		@seeds = seed
	end

	def add(seed)
		@count += 1

		if @seeds.key?(seed)
			@seeds[seed] += 1
		else
			@seeds.store(seed, 1)
		end
	end

end

#!/usr/bin/ruby

require 'kconv'
require 'Core'

$KCODE = 'u'

# 核文節から派生した表現を管理するクラス
class CoresManager

	def initialize(cores = {})
		@cores = cores
	end

	# 核文節の追加
	def add(block, seed, count = 0)
		core = block[0]

		@cores[core] = Core.new(core) unless @cores.key?(core)

		block.each do |segment|
			count = 0 if core == segment
			count += 1
			@cores[core].add(segment, count, seed)
		end
	end

	# 縮小
	def constraction(segments = [])
		@cores.each_value do |core|
			scores = {}
			ne = core.getDerivedExpressionTotal

			core.derivationExpression.each do |segment, element|
				next if element.count == 1

				probability = element.count.to_f / ne.to_f
				score = -1 * element.segmentCount * element.count * ((Math.log10(probability)) / (Math.log10(2)))

				scores[segment] = score
			end

			segments.concat(getMaxScore(scores))
		end

		return segments
	end

	# 核文節の追加
#	def add(block, seed, count = 0)
#		core = block[0]
#
#		if @cores.key?(core)
#			@cores[core].addSeed(seed)
#		else
#			@cores[core] = Core.new(core, seed)
#		end
#
#		block.each do |segment|
#			count = 0 if core == segment
#			count += 1
#			@cores[core].addSegment(segment, count)
#		end
#	end

	# 縮小
#	def constraction(segments = [])
#		@cores.each_value do |core|
#			scores = {}
#			ne = core.getDerivedExpressionTotal
#
#			core.derivedExpression.each do |segment, count|
#				next if count == 1
#
#				probability = count.to_f / ne.to_f
#				score = -1 * core.segmentCount[segment] * count * ((Math.log10(probability)) / (Math.log10(2)))
#
#			scores[segment] = score
#			end
#
#			segments.concat(getMaxScore(scores))
#		end
#
#		return segments
#	end

	#
	def searchExpression(segment, derivationExpression = nil)
		@cores.each_value do |c|
			derivationExpression = c.search(segment)
			break if derivationExpression != false
		end

		return derivationExpression
	end

	#
	def output
		@cores.each do |key, core|
			print "核文節:" + core.core.toutf8 + "\n"

			print "拡張された表現\n"
			core.derivedExpression.each do |k, v|
				print k.toutf8 + ":" + core.segmentCount[k].to_s + "\n"
				print "個数:" + v.to_s + "\n"
			end

			print "種表現\n"
			core.seeds.each do |s, n|
				print s.toutf8 + ":" + n.to_s + "\n"
			end
			print "---------------------------------\n"
			sleep 0.5
		end
	end

private

	# scoreが最大の表現を取得
	def getMaxScore(scores, max = 0.0, segments = [])
		scores.each_value do |score|
			max = score if max < score
		end

		scores.each do |segment, score|
			segments << segment if score == max
		end

		return segments
	end

end

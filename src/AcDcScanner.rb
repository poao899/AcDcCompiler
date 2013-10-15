load 'ASTNode.rb'

class Scanner

	@@regex = /([^\.\s]+\.*)|([\+\-\*\/\=]+)|(\n)/

	def initialize(source)
		raise "can't open the source file\n" unless source.is_a? File
		@source ||= source
		@source_words ||= []
		@line_num ||= 0
	end

	def getToken
		begin str = getStr end until str.nil? || str != "\n"
		return nil unless str
		if str =~ /^\d+$/
			# read a inum
		elsif str =~ /^\d+\.$/
			str2 = getStr
			raise "scan error at line #{@line_num}: not a fnum: #{str+str2}" unless str2 =~ /^\d+$/
			str += str2
			# read a fnum
		elsif str =~ /^[a-zA-Z]+$/
			# read a id
		elsif str =~ /^[\+\-]$/
			# read plus/minus
		elsif str =~ /^[\*\/]$/
			# read mult/div
		elsif str == "="
			# read assign
		else
			raise "scan error at line #{@line_num}: not a symbol: #{str}"
		end
		return str
	end
	
	private
	# 取得下一個 String
	def getStr
		while @source_words.empty?
			return nil if @source.eof?
			@source_words = @source.gets.scan(@@regex).collect{|x,y,z| x.nil? ? z : x}
			@line_num += 1
		end
		ret = @source_words.shift
		return ret
	end
	
end
load 'ASTNode.rb'
load 'AcDcToken.rb'

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
        ret = nil
        if str =~ /^\d+$/               # inum
            ret = Token.new(:inum, str)
        elsif str =~ /^\d+\.$/          # fnum
            str2 = getStr
            raise "scan error at line #{@line_num}: not a fnum: #{str+str2}" unless str2 =~ /^\d+$/
            ret = Token.new(:fnum, str+str2)
        elsif str =~ /^[a-zA-Z]+$/      # id
            ret = Token.new(:id, str)
        elsif str =~ /^[\+\-\*\/]$/     # operator
            ret = Token.new(:ope, str)
        elsif str == "="                # assign
            ret = Token.new(:ass, str)
        else                            # unknowns
            raise "scan error at line #{@line_num}: not a symbol: #{str}"
        end
        return ret
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

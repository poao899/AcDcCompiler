load 'ASTNode.rb'
load 'AcDcToken.rb'

class Scanner

    # @@regex = /([^\.\s]+\.*)|([\+\-\*\/\=]+)|(\n)/
    @@regex = /([^\+\-\*\/\=\s]+)|([\+\-\*\/\=])/
    
    def initialize(source)
        raise "can't open the source file\n" unless source.is_a? File
        @source ||= source
        @source_words ||= []
        @line_num ||= 0
    end

    def getToken
        begin str = getStr end until str.nil? || str != "\n"
        return nil unless str
        if str =~ /^\d+$/               # inum
            Token.new(:T_inum, str)
        elsif str =~ /^\d+\.\d+$/       # fnum
            Token.new(:T_fnum, str)
        elsif str =~ /^[a-zA-Z]+$/      # id
            tok = case str
                when "p" then :T_print
                when "i" then :T_intdcl
                when "f" then :T_floatdcl
                else :T_id
            end
            Token.new(tok, str)
        elsif str =~ /^[\+\-\*\/]$/     # operator
            tok = case str
                when "+" then :T_plus
                when "-" then :T_minus
                when "*" then :T_mult
                when "/" then :T_div
            end
            Token.new(tok, str)
        elsif str == "="                # assign
            Token.new(:T_assign, str)
        else                            # unknowns
            raise "scan error at line #{@line_num}: not a symbol: #{str}"
        end
    end
    
    private
    # 取得下一個 String
    def getStr
        while @source_words.empty?
            return nil if @source.eof?
            @source_words = @source.gets.scan(@@regex).collect{|x,y| x.nil? ? y : x}
            @line_num += 1
        end
        ret = @source_words.shift
        return ret
    end
    
end

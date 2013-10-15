load 'ASTNode.rb'
load 'AcDcToken.rb'

class Scanner

    # @@regex = /([^\.\s]+\.*)|([\+\-\*\/\=]+)|(\n)/
    @@regex = /([^\+\-\*\/\=\s]+)|([\+\-\*\/\=])/

    @@token_regex = 
    {
        /^\d+$/         => :T_inum,
        /^\d+\.\d+$/    => :T_fnum,
        /^p$/           => :T_print,
        /^i$/           => :T_intdcl,
        /^f$/           => :T_floatdcl,
        /^[a-zA-Z]+$/   => :T_id,
        /^\+$/          => :T_plus,
        /^\-$/          => :T_minus, 
        /^\*$/          => :T_mult, 
        /^\/$/          => :T_div, 
        /^=$/           => :T_assign
    }
    
    def initialize(source)
        raise "can't open the source file\n" unless source.is_a? File
        @source ||= source
        @source_words ||= []
        @line_num ||= 0
    end

    def getToken
        begin str = getStr end until str.nil? || str != "\n"
        return nil if str.nil?

        accept_regexes = @@token_regex.keys.select { |regex| str =~ regex }
        raise "scan error at line #{@line_num}: not a symbol: #{str}" if accept_regexes.empty?

        type = @@token_regex[accept_regexes.first]
        return Token.new(type, str)
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

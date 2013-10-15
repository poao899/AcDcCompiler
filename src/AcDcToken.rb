class Token
   
    attr_reader :sym, :val
   
    def initialize(sym, val)
        @sym = sym.to_sym
        if @sym == :T_inum
            @val = val.to_i
        elsif @sym == :T_fnum
            @val = val.to_f
        else
            @val = val.to_s
        end
    end
    
    def test
        puts "Token with sym:%4s, val:#{@val}" % @sym
    end
   
end
class Token
   
    def initialize(sym, val)
        @sym = sym.to_sym
        if @sym == :inum
            @val = val.to_i
        elsif @sym == :fnum
            @val = val.to_f
        else
            @val = val.to_s
        end
    end
    
    def test
        puts "Token with sym:%4s, val:#{@val}" % @sym
    end
   
end
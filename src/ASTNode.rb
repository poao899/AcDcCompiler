require 'bigdecimal'

class ASTNode
    
    attr_reader :child
    attr_accessor :val
    
    def initialize(token_list=[])
        @child ||= []
        @prefix_rule = []
        @rules ||= []
        @val ||= nil
        @expect_sym ||= :none
        @token_list = token_list
    end
    
    def parse
        
        try_match = Proc.new do |node|
            chd = Object.const_get(node).new(@token_list)
            @child.push(chd)
            @token_list = chd.parse
        end
    
        unless @expect_sym == :none
            token = @token_list.shift
            # This is a terminal: check .first type
            raise "parse error: Done with imcomplete parsing" if token.nil?
            raise "parse error: Expect a #{@expect_sym}, get a #{token.sym}" unless token.sym == @expect_sym
            @val = token.val
        end
        
        # Two or more rules with same prefix
        @prefix_rule.each(&try_match)
        
        # Find out which rule is correct
        match_success = @rules.empty?
        token_list_tmp = Array.new(@token_list)
        child_tmp = Array.new(@child)
        
        @rules.each do |rule|
            # Try to parse this rule
            begin
                rule.each(&try_match)
                match_success = true
                break
            rescue Exception => e
                @token_list = Array.new(token_list_tmp)
                @child = Array.new(child_tmp)
            end
        end
        
        raise "parse error" unless match_success
        return @token_list
    end

    def trace(d=0)
        d.times{print">>> "}
        puts "Now at #{self.class.name} with val:#{@val}"
        @child.each{|x| x.trace(d+1)}
    end
    
    def rotate(invalid_symbols)
        @child.each_with_index do |x,idx|
            if (invalid_symbols.include? self.class.name) && (idx == @child.length-1) && (x.class.name == self.class.name)
                ret = x.rotate(invalid_symbols)
                @child[idx] = x.child[0]
                x.child[0] = self
                return ret
            else
                @child[idx] = x.rotate(invalid_symbols)
            end
            
        end
        return self
    end
    
    def const_fold
    
        # the terminals
        return self if @child.length == 0
        
        # fold the symbol with only 1 child.
        return @child[0].const_fold if @child.length == 1
        
        @child.each_with_index do |x,idx|
            @child[idx] = x.const_fold
        end
        
        if (child.length == 3) && (@child[1].nil?) == false && (@child[0].is_a? N_absnum) && (@child[2].is_a? N_absnum)
            if (@child[0].is_a? N_inum) && (@child[2].is_a? N_inum)
                new_self = N_inum.new(nil)
                new_self.val = @child[1].eval(@child[0].val, @child[2].val).to_i
            else
                new_self = N_fnum.new(nil)
                new_self.val = @child[1].eval(BigDecimal.new(@child[0].val.to_s), BigDecimal.new(@child[2].val.to_s)).to_f
            end
            return new_self
        end
        return self
    end

    def get_symbol_table
        {}
    end 

    def get_type_of_val(symbol_table)
    end 

    def code_generate(symbol_table)
    end 
end

###################################
# Test Only                       #
###################################

class TestNode < ASTNode
    def initialize(token_list)
        super(token_list)
        @prefix_rule = [:TestNode]
        @expect_sym = :id
    end
end


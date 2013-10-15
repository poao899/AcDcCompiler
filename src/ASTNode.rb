class ASTNode
        
    def initialize(token_list=[])
        @child ||= []
        @prefix_rule = nil
        @rules ||= []
        @val ||= nil
        @expect_sym ||= :none
        @token_list = token_list
    end
    
    def parse
        token = @token_list.shift
        
        unless @expect_sym == :none
            # This is a terminal: check .first type
            raise "parse error: Done with imcomplete parsing" if token.nil?
            raise "parse error: Expect a #{@expect_sym}, get a #{token.sym}" unless token.sym == @expect_sym
            @val = token.val
        end
        
        # Two or more rules with same prefix
        @prefix_rule.each do |tok,node|
            chd = Object.const_get(node).new(@token_list)
            @child.push(chd)
            @token_list = chd.parse
        end
        
        # Find out which rule is correct
        @rules.each do |tok,node|
            
        end
        
        return @token_list
    end
end

class Prog < ASTNode

end


###################################
# Test Only                       #
###################################

class TestNode < ASTNode
    def initialize(token_list)
        super(token_list)
        @prefix_rule = [[:id,:TestNode]]
        @expect_sym = :id
    end
end


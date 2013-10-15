class ASTNode

    # This is a shared token_list !

    @@token_list = []
    
    def self.token_list=(token_list)
        @@token_list = token_list
    end
        
    def initialize(val=nil)
        @child ||= []
        @prefix_rule = nil
        @rules ||= []
        @val ||= val
        @expect_sym ||= :id
    end
    
    def parse
        token = @@token_list.shift
        
        # Some errors
        
        raise "parse error: Done with imcomplete parsing" if token.nil?
        raise "parse error: Expect a #{@expect_sym}, get a #{token.sym}" unless token.sym == @expect_sym
        
        @val = token.val
        
        # Two rules with same prefix
        
        @prefix_rule.each do |tok,node|
            chd = Object.const_get(node).new
            @child.push(chd)
            chd.parse
        end
    end
end

###################################
# Test Only                       #
###################################

class TestNode < ASTNode
    def initialize(val=nil)
        super(val)
        @prefix_rule = [[:id,:TestNode]]
    end
end


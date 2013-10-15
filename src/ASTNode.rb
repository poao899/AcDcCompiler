class ASTNode
        
    def initialize(token_list=[])
        @child ||= []
        @prefix_rule = []
        @rules ||= []
        @val ||= nil
        @expect_sym ||= :none
        @token_list = token_list
    end
    
    def parse
    
        puts "parse at #{self.class.name}"
        
        unless @expect_sym == :none
            token = @token_list.shift
            # This is a terminal: check .first type
            raise "parse error: Done with imcomplete parsing" if token.nil?
            raise "parse error: Expect a #{@expect_sym}, get a #{token.sym}" unless token.sym == @expect_sym
            @val = token.val
        end
        
        # Two or more rules with same prefix
        @prefix_rule.each do |node|
            chd = Object.const_get(node).new(@token_list)
            @child.push(chd)
            @token_list = chd.parse
        end
        
        # Find out which rule is correct
        
        match_success = @rules.empty?
        
        @rules.each do |rule|
            puts "Rule: #{rule}"
            # Try to parse this rule
            token_list_tmp = Array.new(@token_list)
            begin
                rule.each do |node|
                    chd = Object.const_get(node).new(@token_list)
                    @child.push(chd)
                    @token_list = chd.parse
                end
                match_success = true
                break
            rescue Exception => e
                puts "Got msg #{e.message}"   # test only
                @token_list = token_list_tmp
                @child.clear unless @child.nil?
            end
        end
        
        raise "Match error" unless match_success
        return @token_list
    end

    def trace(d=0)
        d.times{print"="}
        puts "Now at #{self.class.name}"
        @child.each{|x| x.trace(d+1)}
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


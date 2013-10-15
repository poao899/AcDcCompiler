class ASTNode
    
    attr_reader :child
    
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
        @prefix_rule.each &try_match
        
        # Find out which rule is correct
        match_success = @rules.empty?
        token_list_tmp = Array.new(@token_list)
        child_tmp = Array.new(@child)
        
        @rules.each do |rule|
            # Try to parse this rule
            begin
                rule.each &try_match
                match_success = true
                break
            rescue Exception => e
                @token_list = token_list_tmp
                @child = child_tmp
            end
        end
        
        raise "parse error" unless match_success
        return @token_list
    end

    def trace(d=0)
        d.times{print">>> "}
        puts "Now at #{self.class.name}"
        @child.each{|x| x.trace(d+1)}
    end
    
    def rotate(invalid_symbols)
        # puts "#{self.class.name} && #{invalid_symbols.include? self.class.name}}"
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


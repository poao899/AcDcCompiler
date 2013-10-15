module ASTNode
    def initialize
        @next ||= Hash.new
        @prefix_rule = nil
        @rules = []
    end
    
    def parse(token_list)
    
    end
end

class Prog 
end
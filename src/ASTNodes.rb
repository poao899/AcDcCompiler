
###################################
# Various of ASTNodes             #
###################################

load 'ASTNode.rb'

class Prog < ASTNode
    def initialize(token_list)
        super(token_list)
        @prefix_rule = []
        @rules = [
            [:Dcls, :Stmts, :N_eof]
        ]
    end

    def get_symbol_table
        return @child[0].get_symbol_table
    end 
end

class Dcls < ASTNode
    def initialize(token_list)
        super(token_list)
        @prefix_rule = []
        @rules = [
            [:Dcl, :Dcls],
            [:N_lambda]
        ]
    end

    def get_symbol_table
        # FIXME: slow algorithm
        symbol_table = {}
        child.each do |chd| 
            table = chd.get_symbol_table

            # TODO: the reference solution by TA would print Error but continue 
            duplicate_keys = symbol_table.keys.select { |key| table.has_key? key }
            duplicate_keys.each {|key| puts "Error : id #{key} has been declared"}

            symbol_table.merge!(table)
        end
        return symbol_table
    end 
end

class Dcl < ASTNode
    def initialize(token_list)
        super(token_list)
        @prefix_rule = []
        @rules = [
            [:N_floatdcl, :N_id],
            [:N_intdcl, :N_id]
        ]
    end

    def get_symbol_table
        if @child[0].is_a? N_intdcl
            {@child[1].val => :Int}
        else 
            {@child[1].val => :Float}
        end
    end 
end

class Stmts < ASTNode
    def initialize(token_list)
        super(token_list)
        @prefix_rule = []
        @rules = [
            [:Stmt, :Stmts],
            [:N_lambda]
        ]
    end
end

class Stmt < ASTNode
    def initialize(token_list)
        super(token_list)
        @prefix_rule = []
        @rules = [
            [:N_id, :N_assign, :Exprh],
            [:N_print, :N_id]
        ]
    end
    def update_code(symbol_table)
        if @child[0].is_a? N_id
            # assign
            output = ""

            left, right = @child[0], @child[2]
            var_name = left.val
            puts "assignment : #{var_name}"
            if left.type != right.type 
                raise "Error : can't convert float to integer" if left.type == :Int
                puts "convert to float"
                output += "5 k\n"
            end
            output += "s#{symbol_table[var_name][:reg]}\n" + "0 k\n"
            return output
        else
            # print
            var_name = @child[1].val
            puts "print : #{var_name}"
            return "l#{symbol_table[var_name][:reg]}\n" + "p\n"
        end
    end 
end

class Exprh < ASTNode
    def initialize(token_list)
        super(token_list)
        @prefix_rule = [:Exprl]
        @rules = [
            [:Opeh, :Exprh],
            []
        ]
    end
    def update_type(symbol_table)
        @type = 
            if @child[0].type == @child[2].type 
                @child[0].type 
            else 
                :Float
            end
    end 

    def update_code(symbol_table)
        left, right = @child[0], @child[2]
        output = ""
        output += "l#{symbol_table[left.val][:reg]}\n" if left.is_a? N_id
        output += "l#{symbol_table[right.val][:reg]}\n" if right.is_a? N_id
        output += "5 k\n" if @type == :Float
        output += "#{@child[1].val}\n"
        return output
    end 
end

class Exprl < ASTNode
    def initialize(token_list)
        super(token_list)
        @prefix_rule = [:Val]
        @rules = [
            [:Opel, :Exprl],
            []
        ]
    end
    def update_type(symbol_table)
        @type = 
            if @child[0].type == @child[2].type 
                @child[0].type 
            else 
                :Float
            end
    end 
    def update_code(symbol_table)
        left, right = @child[0], @child[2]
        output = ""
        output += "l#{symbol_table[left.val][:reg]}\n" if left.is_a? N_id
        output += "l#{symbol_table[right.val][:reg]}\n" if right.is_a? N_id
        output += "5 k\n" if @type == :Float
        output += "#{@child[1].val}\n"
        return output
    end 
end

class Opeh < ASTNode
    def initialize(token_list)
        super(token_list)
        @prefix_rule = []
        @rules = [
            [:N_plus],
            [:N_minus]
        ]
    end
end

class Opel < ASTNode
    def initialize(token_list)
        super(token_list)
        @prefix_rule = []
        @rules = [
            [:N_mult],
            [:N_div]
        ]
    end
end

class Val < ASTNode
    def initialize(token_list)
        super(token_list)
        @prefix_rule = []
        @rules = [
            [:N_id],
            [:N_inum],
            [:N_fnum]
        ]
    end
end

class N_lambda < ASTNode
    def initialize(token_list)
        super(token_list)
    end
end

class N_id < ASTNode
    def initialize(token_list)
        super(token_list)
        @expect_sym = :T_id
    end
    def update_type(symbol_table)
        raise "Error : identifier #{key} is not declared" unless symbol_table.has_key? @val
        @type = symbol_table[@val][:type]
    end 
end

class N_assign < ASTNode
    def initialize(token_list)
        super(token_list)
        @expect_sym = :T_assign
    end
end

class N_plus < ASTNode
    def initialize(token_list)
        super(token_list)
        @expect_sym = :T_plus
    end
    def eval(a, b)
        a+b
    end
end

class N_minus < ASTNode
    def initialize(token_list)
        super(token_list)
        @expect_sym = :T_minus
    end
    def eval(a, b)
        a-b
    end
end

class N_mult < ASTNode
    def initialize(token_list)
        super(token_list)
        @expect_sym = :T_mult
    end
    def eval(a, b)
        a*b
    end
end

class N_div < ASTNode
    def initialize(token_list)
        super(token_list)
        @expect_sym = :T_div
    end
    def eval(a, b)
        raise "const folding: divide by 0" if b == 0
        a/b
    end
end

class N_print < ASTNode
    def initialize(token_list)
        super(token_list)
        @expect_sym = :T_print
    end
end

class N_intdcl < ASTNode
    def initialize(token_list)
        super(token_list)
        @expect_sym = :T_intdcl
    end
end

class N_floatdcl < ASTNode
    def initialize(token_list)
        super(token_list)
        @expect_sym = :T_floatdcl
    end
end

class N_absnum < ASTNode
    def initialize(token_list)
        super(token_list)
    end
end

class N_inum < N_absnum
    def initialize(token_list)
        super(token_list)
        @expect_sym = :T_inum
    end
    def update_type(symbol_table)
        @type = :Int
    end 
    def update_code(symbol_table)
        puts "constant : Int"
        return "#{@val}\n"
    end 
end

class N_fnum < N_absnum
    def initialize(token_list)
        super(token_list)
        @expect_sym = :T_fnum
    end
    def update_type(symbol_table)
        @type = :Float
    end 
    def update_code(symbol_table)
        puts "constant : Float"
        return "#{@val}\n"
    end 
end

class N_eof < ASTNode
    def initialize(token_list)
        super(token_list)
        @expect_sym = :T_eof
    end
end


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
end

class Exprh < ASTNode
    def initialize(token_list)
        super(token_list)
        @prefix_rule = [:Exprl]
        @rules = [
            [:Opeh, :Exprh],
            [:N_lambda]
        ]
    end
end

class Exprl < ASTNode
    def initialize(token_list)
        super(token_list)
        @prefix_rule = [:Val]
        @rules = [
            [:Opel, :Exprl],
            [:N_lambda]
        ]
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
end

class N_minus < ASTNode
    def initialize(token_list)
        super(token_list)
        @expect_sym = :T_minus
    end
end

class N_mult < ASTNode
    def initialize(token_list)
        super(token_list)
        @expect_sym = :T_mult
    end
end

class N_div < ASTNode
    def initialize(token_list)
        super(token_list)
        @expect_sym = :T_div
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

class N_inum < ASTNode
    def initialize(token_list)
        super(token_list)
        @expect_sym = :T_inum
    end
end

class N_fnum < ASTNode
    def initialize(token_list)
        super(token_list)
        @expect_sym = :T_fnum
    end
end

class N_eof < ASTNode
    def initialize(token_list)
        super(token_list)
        @expect_sym = :T_eof
    end
end
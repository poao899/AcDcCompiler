
###################################
# Various of ASTNodes             #
###################################

load 'ASTNode.rb'

class Prog < ASTNode
    def initialize(token_list)
        super(token_list)
        @prefix_rule = []
        @rules = [
            [:Dcls, :Stmts]
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
    def intialize(token_list)
        super(token_list)
        @prefix_rule = []
        @rules = [
            [:N_floatdcl, :N_id],
            [:N_intdcl, :N_id]
        ]
    end
end

class Stmts < ASTNode
    def intialize(token_list)
        super(token_list)
        @prefix_rule = []
        @rules = [
            [:Stmt, :Stmts],
            [:N_lambda]
        ]
    end
end

class Stmt < ASTNode
    def intialize(token_list)
        super(token_list)
        @prefix_rule = []
        @rules = [
            [:N_id, :N_assign, :Exprh],
            [:N_print, :N_id]
        ]
    end
end

class Exprh < ASTNode
    def intialize(token_list)
        super(token_list)
        @prefix_rule = [:Exprl]
        @rules = [
            [:N_lambda],
            [:Opeh, :Exprh]
        ]
    end
end

class Exprl < ASTNode
    def intialize(token_list)
        super(token_list)
        @prefix_rule = [:Val]
        @rules = [
            [:N_lambda],
            [:Opel, :Exprl]
        ]
    end
end

class Opeh < ASTNode
    def intialize(token_list)
        super(token_list)
        @prefix_rule = []
        @rules = [
            [:N_plus],
            [:N_minus]
        ]
    end
end

class Opel < ASTNode
    def intialize(token_list)
        super(token_list)
        @prefix_rule = []
        @rules = [
            [:N_mult],
            [:N_div]
        ]
    end
end

class Val < ASTNode
    def intialize(token_list)
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
    def intialize(token_list)
        super(token_list)
    end
end

class N_id < ASTNode
    def intialize(token_list)
        super(token_list)
        @val = :T_id
    end
end

class N_assign < ASTNode
    def intialize(token_list)
        super(token_list)
        @val = :T_assign
    end
end

class N_plus < ASTNode
    def intialize(token_list)
        super(token_list)
        @val = :T_plus
    end
end

class N_minus < ASTNode
    def intialize(token_list)
        super(token_list)
        @val = :T_minus
    end
end

class N_mult < ASTNode
    def intialize(token_list)
        super(token_list)
        @val = :T_mult
    end
end

class N_div < ASTNode
    def intialize(token_list)
        super(token_list)
        @val = :T_div
    end
end

class N_print < ASTNode
    def intialize(token_list)
        super(token_list)
        @val = :T_print
    end
end

class N_intdcl < ASTNode
    def intialize(token_list)
        super(token_list)
        @val = :T_intdcl
    end
end

class N_floatdcl < ASTNode
    def intialize(token_list)
        super(token_list)
        @val = :T_floatdcl
    end
end
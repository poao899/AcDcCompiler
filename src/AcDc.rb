#!/usr/bin/env ruby

load 'ASTNodes.rb'
load 'AcDcScanner.rb'

class AcDcCompiler

    def initialize(argv)
        raise "can't open the source file\n" unless File.readable? argv[0]
        @source_file = File.open(argv[0], "r")
        @target_file = File.open(argv[1], "w")
        @scanner = Scanner.new(@source_file)
        @token_list = []
        @syntax_tree = nil
    end
    
    def get_input
        while token = @scanner.getToken
            @token_list.push(token)
        end
        @token_list.push(Token.new(:T_eof))

        #@token_list.each {|x| x.test} #FIXME: DEBUG
    end 

    def parse
        @syntax_tree = Prog.new(@token_list)
        @syntax_tree.parse
        @syntax_tree.rotate(["Exprh", "Exprl"])
        #@syntax_tree.trace
    end

    def optimize
        @syntax_tree.const_fold
        @syntax_tree.trace
    end 
    
    def code_generate
        symbol_table = @syntax_tree.get_symbol_table
        
        symbol_table.to_a.each_with_index do |tuple, idx|
            var_name, type = tuple
            symbol_table[var_name] = {:type => type, :reg => ((idx + 10).to_s 36)}
        end 

        puts symbol_table

        # TODO: output to target_file
        #result = @syntax_tree.code_generate 
        #puts result
    end
end

###################################
# The entry of the AcDc compiler  #
# return the message immediately  #
###################################

def main

    begin

        raise "Usage: #{$0} source_file target_file" unless ARGV.length == 2

        myAcDc = AcDcCompiler.new(ARGV)
        myAcDc.get_input
        myAcDc.parse
        myAcDc.optimize
        myAcDc.code_generate 
    rescue Exception => e    # Compile failed.
        puts e.message
    end
    
end

main if __FILE__ == $0        # The entry of this program

# Syntax.rakumod
# Module containing the grammar for .combo files

use v6.d;
unit module Syntax:ver<0.0.2>:auth<Michele Dusi>;

# Basic grammar for parsing.
grammar Parser is export {

    token TOP { \v* <line>+ %% [\v+] \v* }
    token ws { \h* }

    rule line {
        | <declaration>
        | <comment>
    }

    token comment { "#" \V* }

    rule declaration { <var-decl> "=" <expr> }

    rule var-decl {
        "\\"? # Escaped declaration = not showing this variable in the output.
        <id>
        [":" <type>]? # I don't like typing, maybe this will be removed
    }

    token id { <alpha> \w* }

    token type { # Types: numerical (floats & integers), booleans and textual (strings).
        | "num"
        | "bool"
        | "string"
    }

    rule expr {
        | <bool-expr>
        | <num-expr>
    }

    rule bool-expr {
        | <bool-term>+ %% <bool-op>
    }

    token bool-op {
        | "&" | "and"
        | "|" | "or"
        | "^" | "xor"
        | "->"
        | "<->"
    }

    token bool-un-op {
        | "!" | "not"
    }

    rule bool-term {
        | <rel-expr>
        | <bool-un-op> <bool-term>
        | "(" <bool-expr> ")"
        | <bool-constant>
        | <bool-random-sample>
    }

    rule bool-set {
        | "[" <bool-expr>+ %% "," "]"
        | "[" <bool-expr> "," [<bool-expr> ","?]? ".." ["."*] <bool-expr> "]"
    }

    token bool-constant {
        | "True"
        | "False"
    }

    rule bool-random-sample { # Given a numerical expression (supposing to have a value between 0 and 1), this returns a boolean value <True> with the corresponding probability.
        | "%" "(" <num-expr> ")"
    }

    rule rel-expr { # A boolean expression comparing exactly two (2) numerical expression.
        | <rel-term> <rel-op> <rel-term>
    }

    token rel-op {
        | "=="
        | "!="
        | ">"
        | ">="
        | "<"
        | "<="
    }

    rule rel-term { # A term usable in a relational expression. It's basically a numerical expression.
        | <num-expr>
    }

    rule num-expr {
        | <low-num-term> [<low-num-op> <low-num-term>]*
    }

    token low-num-op {
        | "+"
        | "-"
    }

    rule low-num-term {
        | <high-num-term>+ %% <high-num-op>
    }

    token high-num-op {
        | "*"
        | "/"
    }

    token num-un-op {
        | "-"
    }

    rule high-num-term {
        | <num-un-op> <high-num-term>
        | "(" <num-expr> ")"
        | <id>
        | <num-constant>
        | <num-set>
        | <num-cond-expr>
        # Functions call?
    }

    rule num-set {
        | "[" <num-expr>+ %% "," "]"
        | "[" <num-expr> "," [<num-expr> ","?]? ".." ["."*] <num-expr> "]"
    }

    rule num-cond-expr {
        | "if" <bool-expr> "then" <num-expr> "else" <num-expr>
    }

    token num-constant {
        | <integer>
        | <float>
    }

    token integer {
        \d+
    }

    token float {
        | \d* ["."] \d+
        | \d+ ["."]? \d*
    }

}

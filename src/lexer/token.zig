const ILLEGAL = "ILLEGAL";
const EOF = "EOF";

const IDENT = "IDENT";
const INT = "INT";

const ASSIGN = "=";
const PLUS = "+";

const COMMA = ",";
const SEMICOLON = ";";

const LPAREN = "(";
const RPAREN = ")";
const LBRACE = "{";
const RBRACE = "}";

const FUNCTION = "FUNCTION";
const LET = "LET";

pub const Token = struct {
    Type: []const u8,
    Literal: []const u8,
};

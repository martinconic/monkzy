const std = @import("std");

const tokenType = []const u8;

pub const Token = struct {
    Type: []const u8,
    Literal: []const u8,
};

pub const ILLEGAL = "ILLEGAL";
pub const EOF = "EOF";

pub const IDENT = "IDENT";
pub const INT = "INT";

pub const ASSIGN = "=";
pub const PLUS = "+";
pub const MINUS = "-";
pub const BANG = "!";
pub const ASTERIX = "*";
pub const SLASH = "/";

pub const LT = "<";
pub const GT = ">";

pub const EQ = "==";
pub const NOT_EQ = "!=";

pub const COMMA = ",";
pub const SEMICOLON = ";";

pub const LPAREN = "(";
pub const RPAREN = ")";
pub const LBRACE = "{";
pub const RBRACE = "}";

pub const FUNCTION = "FUNCTION";
pub const LET = "LET";
pub const TRUE = "TRUE";
pub const FALSE = "FALSE";
pub const IF = "IF";
pub const ELSE = "ELSE";
pub const RETURN = "RETURN";

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
var keywords = std.StringHashMap(tokenType).init(gpa.allocator());

pub fn init() !void {
    _ = try keywords.put("fn", FUNCTION);
    _ = try keywords.fetchPut("let", LET);
    _ = try keywords.fetchPut("true", TRUE);
    _ = try keywords.fetchPut("false", FALSE);
    _ = try keywords.fetchPut("if", IF);
    _ = try keywords.fetchPut("else", ELSE);
    _ = try keywords.fetchPut("return", RETURN);
}

pub fn lookupIdent(ident: []const u8) tokenType {
    if (keywords.get(ident)) |tok| {
        return tok;
    }
    return IDENT;
}

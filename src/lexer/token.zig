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

pub const COMMA = ",";
pub const SEMICOLON = ";";

pub const LPAREN = "(";
pub const RPAREN = ")";
pub const LBRACE = "{";
pub const RBRACE = "}";

pub const FUNCTION = "FUNCTION";
pub const LET = "LET";

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
var keywords = std.StringHashMap(tokenType).init(gpa.allocator());

pub fn init() !void {
    _ = try keywords.put("fn", FUNCTION);
    _ = try keywords.fetchPut("let", LET);
}

pub fn lookupIdent(ident: []const u8) tokenType {
    if (keywords.get(ident)) |tok| {
        return tok;
    }
    return IDENT;
}

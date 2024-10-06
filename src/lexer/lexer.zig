const std = @import("std");
const token = @import("token.zig");

pub const Lexer = struct {
    input: []const u8,
    position: usize = 0,
    readPosition: usize = 0,
    ch: u8,

    pub fn init(input: []const u8) Lexer {
        var lexer = Lexer{
            .input = input,
            .position = 0,
            .readPosition = 0,
            .ch = if (input.len > 0) input[0] else 0,
        };

        lexer.readChar();
        return lexer;
    }

    pub fn readChar(self: *Lexer) void {
        if (self.readPosition >= self.input.len) {
            self.ch = 0;
        } else {
            self.ch = self.input[self.readPosition];
        }
        self.position = self.readPosition;
        self.readPosition += 1;
    }

    pub fn nextToken(self: *Lexer) token.Token {
        const tok = switch (self.ch) {
            '=' => token.Token{ .Type = "ASSIGN", .Literal = "=" },
            '+' => token.Token{ .Type = "PLUS", .Literal = "+" },
            '(' => token.Token{ .Type = "LPAREN", .Literal = "(" },
            ')' => token.Token{ .Type = "RPAREN", .Literal = ")" },
            '{' => token.Token{ .Type = "LBRACE", .Literal = "{" },
            '}' => token.Token{ .Type = "RBRACE", .Literal = "}" },
            ',' => token.Token{ .Type = "COMMA", .Literal = "," },
            ';' => token.Token{ .Type = "SEMICOLON", .Literal = ";" },
            else => token.Token{ .Type = "EOF", .Literal = "" },
        };

        self.readChar(); // Move to the next character for the following token
        return tok;
    }
};

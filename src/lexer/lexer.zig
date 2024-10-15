const std = @import("std");
const token = @import("../token/token.zig");

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

    pub fn peekChar(self: *Lexer) u8 {
        if (self.readPosition >= self.input.len) {
            return 0;
        } else {
            return self.input[self.readPosition];
        }
    }

    pub fn readIdentifier(self: *Lexer) []const u8 {
        const position = self.position;
        while (isLetter(self.ch)) {
            self.readChar();
        }
        return self.input[position..self.position];
    }

    pub fn nextToken(self: *Lexer) token.Token {
        self.skipWhitespace();

        var tok: token.Token = undefined;

        switch (self.ch) {
            '=' => {
                if (self.peekChar() == '=') {
                    const ch = self.ch;
                    self.readChar();
                    const literal = [2]u8{ ch, self.ch };
                    tok = token.Token{ .Type = "EQ", .Literal = &literal };
                } else {
                    tok = token.Token{ .Type = "ASSIGN", .Literal = token.ASSIGN };
                }
            },
            '+' => tok = token.Token{ .Type = "PLUS", .Literal = token.PLUS },
            '-' => tok = token.Token{ .Type = "MINUS", .Literal = token.MINUS },
            '!' => {
                if (self.peekChar() == '=') {
                    const ch = self.ch;
                    self.readChar();
                    const literal = [2]u8{ ch, self.ch };
                    tok = token.Token{ .Type = "NOT_EQ", .Literal = &literal };
                } else {
                    tok = token.Token{ .Type = "BANG", .Literal = token.BANG };
                }
            },
            '/' => tok = token.Token{ .Type = "SLASH", .Literal = token.SLASH },
            '*' => tok = token.Token{ .Type = "ASTERIX", .Literal = token.ASTERIX },
            '<' => tok = token.Token{ .Type = "LT", .Literal = token.LT },
            '>' => tok = token.Token{ .Type = "GT", .Literal = token.GT },
            '(' => tok = token.Token{ .Type = "LPAREN", .Literal = token.LPAREN },
            ')' => tok = token.Token{ .Type = "RPAREN", .Literal = token.RPAREN },
            '{' => tok = token.Token{ .Type = "LBRACE", .Literal = token.LBRACE },
            '}' => tok = token.Token{ .Type = "RBRACE", .Literal = token.RBRACE },
            ',' => tok = token.Token{ .Type = "COMMA", .Literal = token.COMMA },
            ';' => tok = token.Token{ .Type = "SEMICOLON", .Literal = token.SEMICOLON },
            0 => tok = token.Token{ .Type = "EOF", .Literal = "" },
            else => {
                if (isLetter(self.ch)) {
                    const literal = self.readIdentifier();
                    return token.Token{
                        .Literal = literal,
                        .Type = token.lookupIdent(literal),
                    };
                } else if (isDigit(self.ch)) {
                    return token.Token{ .Type = token.INT, .Literal = self.readNumber() };
                } else {
                    return token.Token{
                        .Type = token.ILLEGAL,
                        .Literal = &[_]u8{self.ch},
                    };
                }
            },
        }

        self.readChar(); // Move to the next character for the following token
        return tok;
    }

    fn skipWhitespace(self: *Lexer) void {
        while ((self.ch == ' ') or (self.ch == '\t') or (self.ch == '\n') or (self.ch == '\r')) {
            self.readChar();
        }
    }

    fn readNumber(self: *Lexer) []const u8 {
        const position = self.position;
        while (isDigit(self.ch)) {
            self.readChar();
        }
        return self.input[position..self.position];
    }
};

pub fn isLetter(ch: u8) bool {
    return ('a' <= ch and ch <= 'z') or ('A' <= ch and ch <= 'Z') or (ch == '_');
}

pub fn isDigit(ch: u8) bool {
    return ('0' <= ch) and (ch <= '9');
}

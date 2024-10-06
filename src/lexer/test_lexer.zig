const std = @import("std");
const lexer = @import("lexer.zig");

test "next token" {
    const input = "=+(){},;";
    const tests = [_]struct {
        expectedType: []const u8,
        expectedLiteral: []const u8,
    }{
        // Explicitly define field names when initializing test cases
        .{ .expectedType = "ASSIGN", .expectedLiteral = "=" },
        .{ .expectedType = "PLUS", .expectedLiteral = "+" },
        .{ .expectedType = "LPAREN", .expectedLiteral = "(" },
        .{ .expectedType = "RPAREN", .expectedLiteral = ")" },
        .{ .expectedType = "LBRACE", .expectedLiteral = "{" },
        .{ .expectedType = "RBRACE", .expectedLiteral = "}" },
        .{ .expectedType = "COMMA", .expectedLiteral = "," },
        .{ .expectedType = "SEMICOLON", .expectedLiteral = ";" },
        .{ .expectedType = "EOF", .expectedLiteral = "" },
    };

    var lex = lexer.Lexer.init(input);

    for (tests) |tt| {
        const tok = lex.nextToken();

        try std.testing.expectEqualStrings(tt.expectedType, tok.Type);
        try std.testing.expectEqualStrings(tt.expectedLiteral, tok.Literal);
    }
}

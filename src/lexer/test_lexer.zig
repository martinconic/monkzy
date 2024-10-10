const std = @import("std");
const lexer = @import("lexer.zig");
const token = @import("token.zig");

test "next token" {
    const input =
        \\let five = 5;
        \\let ten = 10;
        \\
        \\let add = fn(x, y) {
        \\    x + y;
        \\};
        \\
        \\let result = add(five, ten);
    ;
    const tests = [_]struct {
        expectedType: []const u8,
        expectedLiteral: []const u8,
    }{
        // Explicitly define field names when initializing test cases
        .{ .expectedType = "LET", .expectedLiteral = "let" },
        .{ .expectedType = "IDENT", .expectedLiteral = "five" },
        .{ .expectedType = "ASSIGN", .expectedLiteral = token.ASSIGN },
        .{ .expectedType = "INT", .expectedLiteral = "5" },
        .{ .expectedType = "SEMICOLON", .expectedLiteral = token.SEMICOLON },
        .{ .expectedType = "LET", .expectedLiteral = "let" },
        .{ .expectedType = "IDENT", .expectedLiteral = "ten" },
        .{ .expectedType = "ASSIGN", .expectedLiteral = token.ASSIGN },
        .{ .expectedType = "INT", .expectedLiteral = "10" },
        .{ .expectedType = "SEMICOLON", .expectedLiteral = token.SEMICOLON },
        .{ .expectedType = "LET", .expectedLiteral = "let" },
        .{ .expectedType = "IDENT", .expectedLiteral = "add" },
        .{ .expectedType = "ASSIGN", .expectedLiteral = token.ASSIGN },
        .{ .expectedType = "FUNCTION", .expectedLiteral = "fn" },
        .{ .expectedType = "LPAREN", .expectedLiteral = token.LPAREN },
        .{ .expectedType = "IDENT", .expectedLiteral = "x" },
        .{ .expectedType = "COMMA", .expectedLiteral = token.COMMA },
        .{ .expectedType = "IDENT", .expectedLiteral = "y" },
        .{ .expectedType = "RPAREN", .expectedLiteral = token.RPAREN },
        .{ .expectedType = "LBRACE", .expectedLiteral = token.LBRACE },
        .{ .expectedType = "IDENT", .expectedLiteral = "x" },
        .{ .expectedType = "PLUS", .expectedLiteral = token.PLUS },
        .{ .expectedType = "IDENT", .expectedLiteral = "y" },
        .{ .expectedType = "SEMICOLON", .expectedLiteral = token.SEMICOLON },
        .{ .expectedType = "RBRACE", .expectedLiteral = token.RBRACE },
        .{ .expectedType = "SEMICOLON", .expectedLiteral = token.SEMICOLON },
        .{ .expectedType = "LET", .expectedLiteral = "let" },
        .{ .expectedType = "IDENT", .expectedLiteral = "result" },
        .{ .expectedType = "ASSIGN", .expectedLiteral = token.ASSIGN },
        .{ .expectedType = "IDENT", .expectedLiteral = "add" },
        .{ .expectedType = "LPAREN", .expectedLiteral = token.LPAREN },
        .{ .expectedType = "IDENT", .expectedLiteral = "five" },
        .{ .expectedType = "COMMA", .expectedLiteral = token.COMMA },
        .{ .expectedType = "IDENT", .expectedLiteral = "ten" },
        .{ .expectedType = "RPAREN", .expectedLiteral = token.RPAREN },
        .{ .expectedType = "SEMICOLON", .expectedLiteral = token.SEMICOLON },
        .{ .expectedType = "EOF", .expectedLiteral = "" },
    };

    try token.init();
    var lex = lexer.Lexer.init(input);

    for (tests) |tt| {
        const tok = lex.nextToken();

        try std.testing.expectEqualStrings(tt.expectedType, tok.Type);
        try std.testing.expectEqualStrings(tt.expectedLiteral, tok.Literal);
    }
}

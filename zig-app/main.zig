const std = @import("std");
const time = std.time;

const Snippet = struct {
    text: []u8,
    timestamp: i64,
};

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    var snippets = std.ArrayList(Snippet).init(allocator);
    defer snippets.deinit();
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Clipboard Manager Zig multipiattaforma\n", .{});

    var last_clipboard = try allocator.alloc(u8, 0);
    defer allocator.free(last_clipboard);

    while (true) {
        const clipboard = try getClipboard(allocator);
        defer allocator.free(clipboard);
        if (!std.mem.eql(u8, clipboard, last_clipboard)) {
            const now = time.timestamp();
            try snippets.append(Snippet{
                .text = try allocator.dupe(u8, clipboard),
                .timestamp = now,
            });
            allocator.free(last_clipboard);
            last_clipboard = try allocator.dupe(u8, clipboard);
            try saveSnippetsToFile(&snippets);
            try stdout.print("Nuovo snippet salvato alle {d}: {s}\n", .{ now, clipboard });
        }
        std.time.sleep(500_000_000); // 500ms
    }
}

fn saveSnippetsToFile(snippets: *std.ArrayList(Snippet)) !void {
    var file = try std.fs.cwd().createFile("snippets.txt", .{ .truncate = true });
    defer file.close();
    for (snippets.items) |snippet| {
        try file.writer().print("[{d}] {s}\n", .{ snippet.timestamp, snippet.text });
    }
}

// --- Clipboard Windows ---
fn getClipboard(allocator: std.mem.Allocator) ![]u8 {
    if (WIN32) {
        var child = std.process.Child.init(&[_][]const u8{ "powershell", "-Command", "Get-Clipboard" }, allocator);
        child.stdout_behavior = .Pipe;
        child.stderr_behavior = .Ignore;
        try child.spawn();
        var out = std.ArrayList(u8).init(allocator);
        defer out.deinit();
        if (child.stdout) |stdout| {
            var reader = stdout.reader();
            try reader.readAllArrayList(&out, 4096);
        }
        _ = try child.wait();
        var output = out.items;
        if (output.len > 0 and output[output.len - 1] == '\n') {
            output = output[0 .. output.len - 1];
        }
        return try allocator.dupe(u8, output);
    } else {
        // TODO: Linux/macOS: usa xclip o pbpaste
        return allocator.alloc(u8, 0);
    }
}

const WIN32 = @import("builtin").os.tag == .windows;

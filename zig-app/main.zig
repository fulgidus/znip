const std = @import("std");
const time = std.time;
const builtin = @import("builtin");

const Snippet = struct {
    text: []u8,
    timestamp: i64,
};

extern fn XOpenDisplay(display_name: ?[*:0]const u8) ?*anyopaque;
extern fn XCloseDisplay(display: *anyopaque) i32;
extern fn XDefaultScreen(display: *anyopaque) i32;
extern fn XRootWindow(display: *anyopaque, screen_number: i32) c_ulong;
extern fn XGetSelectionOwner(display: *anyopaque, selection: c_ulong) c_ulong;
extern fn XInternAtom(display: *anyopaque, atom_name: [*]const u8, only_if_exists: i32) c_ulong;
extern fn XConvertSelection(display: *anyopaque, selection: c_ulong, target: c_ulong, property: c_ulong, requestor: c_ulong, time: c_ulong) i32;
extern fn XSync(display: *anyopaque, discard: i32) i32;
extern fn XNextEvent(display: *anyopaque, event_return: *u8) i32;
extern fn XGetWindowProperty(display: *anyopaque, w: c_ulong, property: c_ulong, long_offset: c_long, long_length: c_long, delete: i32, req_type: c_ulong, actual_type_return: *c_ulong, actual_format_return: *i32, nitems_return: *c_ulong, bytes_after_return: *c_ulong, prop_return: *[*]u8) i32;
extern fn XFree(data: *anyopaque) i32;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    var snippets = std.ArrayList(Snippet).init(allocator);
    defer snippets.deinit();
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Znip\n", .{});

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
            try stdout.print("Nuovo znippet salvato alle {d}: {s}\n", .{ now, clipboard });
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
    } else if (LINUX) {
        // Check for Wayland
        if (std.process.getEnvVarOwned(allocator, "WAYLAND_DISPLAY")) |wayland_display| {
            defer allocator.free(wayland_display);
            return error.WaylandClipboardNotSupported;
        } else |_| {
            // X11 clipboard access
            const display = XOpenDisplay(null);
            if (display == null) return error.X11DisplayOpenFailed;
            defer _ = XCloseDisplay(display.?);
            const screen = XDefaultScreen(display.?);
            const window = XRootWindow(display.?, screen);
            const clipboard_atom = XInternAtom(display.?, "CLIPBOARD", 0);
            const utf8_atom = XInternAtom(display.?, "UTF8_STRING", 0);
            const prop_atom = XInternAtom(display.?, "XSEL_DATA", 0);
            _ = XConvertSelection(display.?, clipboard_atom, utf8_atom, prop_atom, window, 0);
            _ = XSync(display.?, 0);
            var event: [24]u8 = undefined;
            _ = XNextEvent(display.?, &event[0]);
            var actual_type: c_ulong = 0;
            var actual_format: i32 = 0;
            var nitems: c_ulong = 0;
            var bytes_after: c_ulong = 0;
            var prop: [*]u8 = undefined;
            _ = XGetWindowProperty(display.?, window, prop_atom, 0, 1024 * 1024, 0, utf8_atom, &actual_type, &actual_format, &nitems, &bytes_after, &prop);
            defer if (@intFromPtr(prop) != 0) {
                _ = XFree(prop);
            };
            if (nitems == 0 or @intFromPtr(prop) == 0) return allocator.alloc(u8, 0);
            const slice = @as([*]const u8, @ptrCast(prop))[0..nitems];
            return try allocator.dupe(u8, slice);
        }
    } else if (MACOS) {
        var child = std.process.Child.init(&[_][]const u8{"pbpaste"}, allocator);
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
        return allocator.alloc(u8, 0);
    }
}

const WIN32 = builtin.os.tag == .windows;
const LINUX = builtin.os.tag == .linux;
const MACOS = builtin.os.tag == .macos;

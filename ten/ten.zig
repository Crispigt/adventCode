const std = @import("std");

fn readLineToVariable(reader: anytype, buffer: []u8) !?[]const u8 {
    const line = try reader.readUntilDelimiterOrEof(buffer, '\n');
    return line orelse null; // Handle the case where no more lines are available
}

fn convertfuckingstringtoint(input: ?[]const u8, allocator: anytype, ) ![]i32 {
    var ret: i32 = 0;

    if (input) |value| {
        var ints = try allocator.alloc(i32, value.len);
        var count: usize = 0;
        for(value)|item|{
            const cItem: [1]u8 = [1]u8{item};
            const trimshit = std.mem.trim(u8, &cItem, " \n\r");
            ret = try std.fmt.parseInt(i32, trimshit, 10);
            //std.debug.print("converted: {d}\n", .{ret});
            ints[count] = ret;
            count +=1;
        }
        return ints;
    }
    return &[_]i32{};
}

fn resetFoundTop(foundTop: [][]bool) void {
    for (foundTop) |*row| {
        for (row.*) |*item| {
            item.* = false;
        }
    }
}


fn findPaths(mat: std.ArrayList([]i32), allocator: anytype) !i32 {
    var x: usize = 0;
    var y: usize = 0;
    var res: i32 = 0;
    // Allocate memory for the outer array (rows)
    const adj = try allocator.alloc([]bool, mat.items.len);
    var c: usize = 0;
    for (adj)|*row|{
        row.* = try allocator.alloc(bool, mat.items[0].len);
        for (0..row.*.len) |i| {
            row.*[i] = false;
        }
        c+=1;
    }
    

    //Can probably memorize paths and just keep how many 9s each path goes to.
    for (mat.items) |value| {
        for (value) |val| {
            if(val == 0){
                std.debug.print("{d}, {d}:\n", .{x, y});
                //var foundTop= std.ArrayList([]i32).init(allocator);
                //defer foundTop.deinit();
                res += try findNextNumber(x, y, 1, mat, adj);
                std.debug.print("res: {d}\n", .{res});
                resetFoundTop(adj);
            }
            x += 1;
        }
        y += 1;
        x = 0;
    }
    return res;
}

fn findNextNumber(x: usize, y: usize, next:i32, mat: std.ArrayList([]i32), foundTop: [][]bool) anyerror!i32 {
    //Need to check so that not going outside inside the box
    //std.debug.print("{d},{d}\n", .{x,y});
    std.debug.print("x: {d}, y: {d}, {d}\n", .{x,y, next});

    var cur: i32 = 0;
    cur += try up(x, y, next, mat, foundTop);
    cur += try down(x, y, next, mat,foundTop);
    cur += try left(x, y, next, mat,foundTop);
    cur += try right(x, y, next, mat,foundTop);
    
    return cur;
}

fn up(x: usize, y: usize, next: i32, mat: std.ArrayList([]i32), foundTop: [][]bool) !i32 {
    if (y <= 0) return 0;
    // Correct indexing: mat.items[y-1][x]
    if (mat.items[y-1][x] == next) {
        if (next == 9 and foundTop[y-1][x] == false) {
            foundTop[y-1][x] = true;
            return 1;
            }
        return try findNextNumber(x, y-1, next + 1, mat, foundTop);
    }
    return 0;
}

fn down(x: usize, y: usize, next: i32, mat: std.ArrayList([]i32), foundTop: [][]bool) !i32 {
    if (y + 1 >= mat.items.len) return 0;
    // Correct indexing: mat.items[y+1][x]
    if (mat.items[y+1][x] == next) {
        if (next == 9 and foundTop[y+1][x] == false ) {
            foundTop[y+1][x] = true;
            return 1;
            }
        return try findNextNumber(x, y+1, next + 1, mat,foundTop);
    }
    return 0;
}

fn right(x: usize, y: usize, next: i32, mat: std.ArrayList([]i32), foundTop: [][]bool) !i32 {
    if (x + 1 >= mat.items[y].len) return 0;
    // Correct indexing: mat.items[y][x+1]
    if (mat.items[y][x+1] == next) {
        if (next == 9 and foundTop[y][x+1] == false) {
            foundTop[y][x+1] = true;
            return 1;
            }
        return try findNextNumber(x+1, y, next + 1, mat, foundTop);
    }
    return 0;
}

fn left(x: usize, y: usize, next: i32, mat: std.ArrayList([]i32), foundTop: [][]bool) !i32 {
    if (x <= 0) return 0;
    // Correct indexing: mat.items[y][x-1]
    if (mat.items[y][x-1] == next) {
        if (next == 9 and foundTop[y][x-1] == false) {
            foundTop[y][x-1] = true;
            return 1;
            }
        return try findNextNumber(x-1, y, next + 1, mat, foundTop);
    }
    return 0;
}

pub fn main() !void {

    const stdin = std.io.getStdIn();

    const allocator = std.heap.page_allocator;
    var buffer: [1024]u8 = undefined;
    const reader = stdin.reader();
    var array1= std.ArrayList([]i32).init(allocator);
    while(true){
        const line = try readLineToVariable(reader, &buffer);
        if(line == null) break;
        //std.debug.print("{any}\n", .{line});
        const num = try convertfuckingstringtoint(line, allocator); // best thing would be to get the position of each zero from this as well
        for (num) |value| {
            std.debug.print("{d} ", .{value});
        }
        std.debug.print("\n", .{});
        try array1.append(num);
    } 
    std.debug.print("\n--- Got input ---\n\n", .{});
    for (array1.items) |value| {
        for (value) |value1| {
            std.debug.print("{d} ", .{value1});
        }
        std.debug.print("\n", .{});
    }
    const res = try findPaths(array1, allocator);
    std.debug.print("{d}\n", .{res});
}


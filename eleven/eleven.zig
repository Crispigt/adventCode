//If num = 0 => 1
//If num.len % 2 = 0 => split number eg. 10 = 1 and 0, no leading zeroes 00 = 0
//Else num * 2024

//Maybe a tree would be good, where each node is the number, if split we get two new nodes below,
//one
//Otherwise maybe an array where each number has it's own arraylist and we remove then add the splitet number
//we rebuild the full number by going through and
//Only problematic part is that we have to shift everything to add a new number inbetween
//Otherwise a linked list makes it easy to add and remove numbers
// Going with a linked list, then we check each of the things through functions,
// That is the above functions, also need to implement a linked list, with custom functions
// to add and remove based on the above
// Repeat x amount of times


// First read input to the linked list


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



pub fn main() !void {

    const stdin = std.io.getStdIn();

    const allocator = std.heap.page_allocator;
    var buffer: [1024]u8 = undefined;
    const reader = stdin.reader();
    while(true){
        const line = try readLineToVariable(reader, &buffer);
        if(line == null) break;
        //std.debug.print("{any}\n", .{line});
        const num = try convertfuckingstringtoint(line, allocator); // best thing would be to get the position of each zero from this as well
        for (num) |value| {
            std.debug.print("{d} ", .{value});
        }
        std.debug.print("\n", .{});
    } 
    std.debug.print("\n--- Got input ---\n\n", .{});
}
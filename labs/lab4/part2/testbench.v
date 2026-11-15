
`timescale 1ns/1ps

module testbench;

    reg [1:0] SW;
    reg [0:0] KEY;
    wire [6:0] HEX3, HEX2, HEX1, HEX0;

    part2 dut (SW, KEY, HEX3, HEX2, HEX1, HEX0);

    // Clock: 10 ns period
    initial KEY = 0;
    always #5 KEY[0] = ~KEY[0];

    initial begin
        // Icarus Verilog waveform output
        $dumpfile("part2.vcd");
        $dumpvars(0, testbench);

        SW = 2'b00;  // Reset
        #20;

        SW = 2'b11;  // Enable counting
        #200;

        SW = 2'b01;  // Disable counting
        #40;

        SW = 2'b11;  // Resume counting
        #100;

        SW = 2'b10;  // Reset again
        #20;

        $finish;
    end

endmodule

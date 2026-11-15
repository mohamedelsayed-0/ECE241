
`timescale 1ns/1ps

module testbench;

    reg [0:0] KEY;
    reg CLOCK_50;
    wire [6:0] HEX0;

    part3 dut (KEY, CLOCK_50, HEX0);

    initial CLOCK_50 = 0;
    always #10 CLOCK_50 = ~CLOCK_50;

    initial begin
        $dumpfile("part3.vcd");
        $dumpvars(0, testbench);

        KEY = 0;
        #40;

        KEY = 1;
        #1200;

        KEY = 0;
        #40;

        $finish;
    end

endmodule

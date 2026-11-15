
`timescale 1ns/1ps

module testbench;

    reg CLOCK_50;
    reg [0:0] KEY;
    wire [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;

    part4 dut (
        .CLOCK_50(CLOCK_50),
        .KEY(KEY),
        .HEX5(HEX5),
        .HEX4(HEX4),
        .HEX3(HEX3),
        .HEX2(HEX2),
        .HEX1(HEX1),
        .HEX0(HEX0)
    );

    initial CLOCK_50 = 0;
    always #10 CLOCK_50 = ~CLOCK_50;

    initial begin
        $dumpfile("part4.vcd");
        $dumpvars(0, testbench);

        KEY = 0;
        #40;

        KEY = 1;
        #1300;

        KEY = 0;
        #40;

        $finish;
    end

endmodule

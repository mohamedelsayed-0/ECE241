`timescale 1ns / 1ps

module testbench ();

    parameter CLOCK_PERIOD = 200;

    reg Clk, D;
    wire Qa, Qb, Qc;

    initial begin
        Clk <= 1'b0;
    end

    always @ (*) begin : Clock_Generator
        #((CLOCK_PERIOD) / 2) Clk <= ~Clk;
    end

    initial begin
        D <= 0;
        #80 D <= 1;
        #40 D <= 0;
        #20 D <= 1;
        #30 D <= 0;
        #40 D <= 1;
        #30 D <= 0;
        #20 D <= 1;
        #20 D <= 0;
        #40 D <= 1;
        #20 D <= 0;
        #20 D <= 1;
        #60 D <= 0;
    end

    part4 U1 (Clk, D, Qa, Qb, Qc);

    // added myself (icarus + surfer)
    initial begin
        $dumpfile("part4.vcd");
        $dumpvars(0, testbench);
        #600 $finish;
    end

endmodule
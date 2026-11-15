`timescale 1ns / 1ps

module testbench ();

    parameter CLOCK_PERIOD = 10;

    reg Clk, R, S;
    wire Qa, Qb;

    initial begin
        Clk <= 1'b0;
    end

    always @ (*)
    begin : Clock_Generator
        #((CLOCK_PERIOD) / 2) Clk <= ~Clk;
    end

    initial begin
        R <= 1; S <= 0;
        #10 R <= 0;
        #10 S <= 1;
        #10 S <= 0;
        #20 R <= 1;
        #10 R <= 0;
    end

    part1 U1 (Clk, R, S, Qa, Qb);

    // added for my software (surfer + icarus)
    initial begin
        $dumpfile("part1.vcd");
        $dumpvars(0, testbench);
        #80 $finish;
    end

endmodule
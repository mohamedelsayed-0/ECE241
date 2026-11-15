
`timescale 1ns/1ps

module tb_mandelbrot1;

    reg clk = 0;
    always #5 clk = ~clk;

    reg reset = 1;
    reg start = 0;
    reg signed [15:0] c_real = 0;
    reg signed [15:0] c_imag = 0;
    reg [7:0] max_iter = 100;

    wire [7:0] iter_count;
    wire done, escaped;

    mandelbrot_engine dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .c_real(c_real),
        .c_imag(c_imag),
        .max_iter(max_iter),
        .iter_count(iter_count),
        .done(done),
        .escaped(escaped)
    );

    task check_point;
        input signed [15:0] a, b;
        input [7:0] cap, expected_count;
        input expected_escaped;

        begin
            @(negedge clk);
            c_real = a;
            c_imag = b;
            max_iter = cap;
            start = 1;

            @(negedge clk);
            start = 0;

            wait(done === 1'b1);

            if (iter_count !== expected_count ||
                escaped !== expected_escaped) begin

                $display("FAIL c=(%0d,%0d), count=%0d escaped=%b; expected count=%0d escaped=%b",
                         a, b, iter_count, escaped,
                         expected_count, expected_escaped);

                $fatal(1, "Incorrect Mandelbrot result");
            end

            $display("PASS c=(%0d,%0d), count=%0d escaped=%b",
                     a, b, iter_count, escaped);

            repeat (2) @(negedge clk);
        end
    endtask

    initial begin
        $dumpfile("mandelbrot.vcd");
        $dumpvars(0, tb_mandelbrot1);

        repeat (2) @(negedge clk);
        reset = 0;

        // c = 0: never escapes
        check_point(16'sd0, 16'sd0, 8'd100, 8'd100, 1'b0);

        // c = 2: escapes after 2 iterations
        check_point(16'sd8192, 16'sd0, 8'd100, 8'd2, 1'b1);

        // c = -1: never escapes
        check_point(-16'sd4096, 16'sd0, 8'd100, 8'd100, 1'b0);

        // c = 1: escapes after 3 iterations
        check_point(16'sd4096, 16'sd0, 8'd100, 8'd3, 1'b1);

        // max_iter = 0
        check_point(16'sd0, 16'sd0, 8'd0, 8'd0, 1'b0);

        $display("ALL TESTS PASSED");
        $finish;
    end

    initial begin
        #200000;
        $fatal(1, "Timeout: done was not asserted");
    end

endmodule

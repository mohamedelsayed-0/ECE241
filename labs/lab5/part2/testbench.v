
`timescale 1ns/1ps

module testbench;

    reg [1:0] SW;
    reg [0:0] KEY;
    wire [9:0] LEDR;

    integer errors = 0;

    part2 dut (
        .SW(SW),
        .KEY(KEY),
        .LEDR(LEDR)
    );

    // Manual clock pulse
    task clock_pulse;
        begin
            #5 KEY[0] = 0;
            #5 KEY[0] = 1;
            #1;
        end
    endtask

    // Send a bit and check the result
    task send_bit;
        input bit_value;
        input [3:0] expected_state;
        input expected_z;
        begin
            SW[1] = bit_value;
            clock_pulse();

            if (dut.y_Q !== expected_state ||
                LEDR[9] !== expected_z) begin
                $display("FAIL: w=%b state=%h expected=%h z=%b expected=%b",
                         bit_value, dut.y_Q, expected_state,
                         LEDR[9], expected_z);
                errors = errors + 1;
            end
            else begin
                $display("PASS: w=%b state=%h z=%b",
                         bit_value, dut.y_Q, LEDR[9]);
            end
        end
    endtask

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, testbench);

        SW = 2'b00;
        KEY = 1'b1;

        // Reset to A
        clock_pulse();
        SW[0] = 1;

        $display("TEST 1: Four zeros");
        send_bit(0, 4'h1, 0); // B
        send_bit(0, 4'h2, 0); // C
        send_bit(0, 4'h3, 0); // D
        send_bit(0, 4'h4, 1); // E
        send_bit(0, 4'h4, 1); // E again

        $display("TEST 2: Four ones");
        send_bit(1, 4'h5, 0); // F
        send_bit(1, 4'h6, 0); // G
        send_bit(1, 4'h7, 0); // H
        send_bit(1, 4'h8, 1); // I
        send_bit(1, 4'h8, 1); // I again

        $display("TEST 3: Alternating bits");
        send_bit(0, 4'h1, 0); // B
        send_bit(1, 4'h5, 0); // F
        send_bit(0, 4'h1, 0); // B
        send_bit(1, 4'h5, 0); // F

        if (errors == 0)
            $display("ALL PART 2 TESTS PASSED");
        else
            $display("PART 2 FAILED: %0d errors", errors);

        #10;
        $finish;
    end

endmodule

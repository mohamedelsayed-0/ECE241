
`timescale 1ns/1ps

module testbench;

    reg [1:0] SW;
    reg [0:0] KEY;
    wire [9:0] LEDR;

    // Device under test
    part1_modified dut (
        .SW(SW),
        .KEY(KEY),
        .LEDR(LEDR)
    );

    // Generate clock pulses
    task clock_pulse;
        begin
            #5 KEY[0] = 0;
            #5 KEY[0] = 1;
            #5;
        end
    endtask

    // Apply input and clock
    task send_bit;
        input bit_value;
        begin
            SW[1] = bit_value;
            clock_pulse();
        end
    endtask

    initial begin
        $dumpfile("wave2.vcd");
        $dumpvars(0, testbench);

        // Initialize
        SW = 2'b00;
        KEY = 1'b1;

        // Reset (synchronous, active-low)
        clock_pulse();
        SW[0] = 1;

        // Test 1: Four consecutive zeros
        send_bit(0);
        send_bit(0);
        send_bit(0);
        send_bit(0);

        // Test 2: Fifth zero (overlap)
        send_bit(0);

        // Test 3: Four consecutive ones
        send_bit(1);
        send_bit(1);
        send_bit(1);
        send_bit(1);

        // Test 4: Fifth one (overlap)
        send_bit(1);

        // Test 5: Alternating inputs
        send_bit(0);
        send_bit(1);
        send_bit(0);
        send_bit(1);

        #20;
        $finish;
    end

endmodule


`timescale 1ns/1ps

module testbench;

    reg [2:0] SW;
    reg [1:0] KEY;
    reg CLOCK_50 = 0;
    wire [9:0] LEDR;

    integer errors = 0;
    integer i;

    // 10 ns clock period
    always #5 CLOCK_50 = ~CLOCK_50;

    // Device under test
    part3 #(
        .cycles(3)
    ) dut (
        .SW(SW),
        .CLOCK_50(CLOCK_50),
        .KEY(KEY),
        .LEDR(LEDR)
    );

    // Check one Morse symbol
    // units = 1 for dot, 3 for dash
    task check_symbol;
        input integer units;
        integer j;
        begin
            for (j = 1; j <= units * 3; j = j + 1) begin
                @(posedge CLOCK_50);
                #1;

                if (j < units * 3) begin
                    if (LEDR[0] !== 1'b1) begin
                        $display("FAIL: LED should be ON at %0t", $time);
                        errors = errors + 1;
                    end
                end
                else begin
                    if (LEDR[0] !== 1'b0) begin
                        $display("FAIL: LED should be OFF at %0t", $time);
                        errors = errors + 1;
                    end
                end
            end
        end
    endtask

    // Check gap between symbols
    task check_gap;
        integer j;
        begin
            for (j = 1; j <= 3; j = j + 1) begin
                @(posedge CLOCK_50);
                #1;

                if (j < 3 && LEDR[0] !== 1'b0) begin
                    $display("FAIL: Gap should be OFF");
                    errors = errors + 1;
                end

                if (j == 3 && LEDR[0] !== 1'b1) begin
                    $display("FAIL: Next symbol did not start");
                    errors = errors + 1;
                end
            end
        end
    endtask

    // Test a complete letter
    task test_letter;
        input [2:0] letter;
        input [3:0] bits;
        input integer length;

        integer j;
        integer units;
        integer before_errors;

        begin
            before_errors = errors;

            // Select letter
            @(negedge CLOCK_50);
            SW = letter;
            KEY[1] = 0;

            // Start transmission
            @(posedge CLOCK_50);
            #1;
            KEY[1] = 1;

            if (LEDR[0] !== 1'b1) begin
                $display("FAIL: Letter did not start");
                errors = errors + 1;
            end

            for (j = 0; j < length; j = j + 1) begin
                if (j > 0)
                    check_gap();

                if (bits[j])
                    units = 3;
                else
                    units = 1;

                check_symbol(units);
            end

            if (dut.state !== 2'd0 ||
                LEDR[0] !== 1'b0) begin
                $display("FAIL: Did not return to IDLE");
                errors = errors + 1;
            end

            if (errors == before_errors)
                $display("PASS: Letter %0d", letter);
            else
                $display("FAIL: Letter %0d", letter);
        end
    endtask

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, testbench);

        // Initialize
        SW = 3'b000;
        KEY = 2'b10;

        // Synchronous reset
        repeat (2) @(posedge CLOCK_50);
        #1 KEY[0] = 1;

        // Test all letters A-H
        test_letter(3'b000, 4'b0010, 2); // A .-
        test_letter(3'b001, 4'b0001, 4); // B -...
        test_letter(3'b010, 4'b0101, 4); // C -.-.
        test_letter(3'b011, 4'b0001, 3); // D -..
        test_letter(3'b100, 4'b0000, 1); // E .
        test_letter(3'b101, 4'b0100, 4); // F ..-.
        test_letter(3'b110, 4'b0011, 3); // G --.
        test_letter(3'b111, 4'b0000, 4); // H ....

        if (errors == 0)
            $display("ALL PART 3 TESTS PASSED");
        else
            $display("PART 3 FAILED: %0d errors", errors);

        #20;
        $finish;
    end

endmodule

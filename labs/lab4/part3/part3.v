
module part3 (KEY, CLOCK_50, HEX0);

    input [0:0] KEY;
    input CLOCK_50;
    output [6:0] HEX0;

    reg [2:0] timer;  // z
    reg [3:0] digit;

    always @(posedge CLOCK_50) begin
        if (!KEY[0]) begin
            timer <= 0;
            digit <= 0;
        end
        else if (timer == 4) begin  // z
            timer <= 0;

            if (digit == 9)
                digit <= 0;
            else
                digit <= digit + 1;
        end
        else
            timer <= timer + 1;
    end

    hex_decoder h0 (digit, HEX0);

endmodule

module hex_decoder(input [3:0] in, output reg [6:0] out);
    always @(*) begin
        case (in)
            0: out = 7'b1000000;
            1: out = 7'b1111001;
            2: out = 7'b0100100;
            3: out = 7'b0110000;
            4: out = 7'b0011001;
            5: out = 7'b0010010;
            6: out = 7'b0000010;
            7: out = 7'b1111000;
            8: out = 7'b0000000;
            9: out = 7'b0010000;
            default: out = 7'b1111111;
        endcase
    end
endmodule

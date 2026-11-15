
module TFlipFlop (
    input Clock,
    input Clear,
    input T,
    output reg Q
);
    always @(posedge Clock) begin
        if (!Clear)
            Q <= 1'b0;
        else if (T)
            Q <= ~Q;
    end
endmodule


module hex_decoder (
    input [3:0] in,
    output reg [6:0] out
);
    always @(*) begin
        case (in)
            4'h0: out = 7'b1000000;
            4'h1: out = 7'b1111001;
            4'h2: out = 7'b0100100;
            4'h3: out = 7'b0110000;
            4'h4: out = 7'b0011001;
            4'h5: out = 7'b0010010;
            4'h6: out = 7'b0000010;
            4'h7: out = 7'b1111000;
            4'h8: out = 7'b0000000;
            4'h9: out = 7'b0010000;
            4'hA: out = 7'b0001000;
            4'hB: out = 7'b0000011;
            4'hC: out = 7'b1000110;
            4'hD: out = 7'b0100001;
            4'hE: out = 7'b0000110;
            4'hF: out = 7'b0001110;
            default: out = 7'b1111111;
        endcase
    end
endmodule


module part1 (SW, KEY, HEX1, HEX0);
    input [1:0] SW;
    input [0:0] KEY;
    output [6:0] HEX1, HEX0;

    wire [7:0] Count;
    wire [7:0] T;

    assign T[0] = SW[1];
    assign T[1] = SW[1] & Count[0];
    assign T[2] = SW[1] & (&Count[1:0]);
    assign T[3] = SW[1] & (&Count[2:0]);
    assign T[4] = SW[1] & (&Count[3:0]);
    assign T[5] = SW[1] & (&Count[4:0]);
    assign T[6] = SW[1] & (&Count[5:0]);
    assign T[7] = SW[1] & (&Count[6:0]);

    TFlipFlop ff0 (KEY[0], SW[0], T[0], Count[0]);
    TFlipFlop ff1 (KEY[0], SW[0], T[1], Count[1]);
    TFlipFlop ff2 (KEY[0], SW[0], T[2], Count[2]);
    TFlipFlop ff3 (KEY[0], SW[0], T[3], Count[3]);
    TFlipFlop ff4 (KEY[0], SW[0], T[4], Count[4]);
    TFlipFlop ff5 (KEY[0], SW[0], T[5], Count[5]);
    TFlipFlop ff6 (KEY[0], SW[0], T[6], Count[6]);
    TFlipFlop ff7 (KEY[0], SW[0], T[7], Count[7]);

    hex_decoder h0 (Count[3:0], HEX0);
    hex_decoder h1 (Count[7:4], HEX1);

endmodule

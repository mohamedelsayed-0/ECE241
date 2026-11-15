
module part2 (SW, KEY, HEX3, HEX2, HEX1, HEX0);
    input [1:0] SW;
    input [0:0] KEY;
    output [6:0] HEX3, HEX2, HEX1, HEX0;

    reg [15:0] Count;

    always @(posedge KEY[0]) begin
        if (!SW[0])
            Count <= 16'b0;
        else if (SW[1])
            Count <= Count + 1'b1;
    end

    hex_decoder h0 (Count[3:0],   HEX0);
    hex_decoder h1 (Count[7:4],   HEX1);
    hex_decoder h2 (Count[11:8],  HEX2);
    hex_decoder h3 (Count[15:12], HEX3);

endmodule

module hex_decoder(input [3:0] in, output reg [6:0] out);
    always @(*) begin
        case (in)
            4'h0: out = 7'h40;
            4'h1: out = 7'h79;
            4'h2: out = 7'h24;
            4'h3: out = 7'h30;
            4'h4: out = 7'h19;
            4'h5: out = 7'h12;
            4'h6: out = 7'h02;
            4'h7: out = 7'h78;
            4'h8: out = 7'h00;
            4'h9: out = 7'h10;
            4'hA: out = 7'h08;
            4'hB: out = 7'h03;
            4'hC: out = 7'h46;
            4'hD: out = 7'h21;
            4'hE: out = 7'h06;
            4'hF: out = 7'h0E;
        endcase
    end
endmodule

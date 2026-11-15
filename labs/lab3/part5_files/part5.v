module part5 (SW, KEY, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0, LEDR);
    input [7:0] SW;
    input [1:0] KEY;
    output [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
    output [9:0] LEDR;

    wire [7:0] A, B;
    wire [8:0] S;

    // Eight flip-flops store A
    dff F0 (KEY[1], KEY[0], SW[0], A[0]);
    dff F1 (KEY[1], KEY[0], SW[1], A[1]);
    dff F2 (KEY[1], KEY[0], SW[2], A[2]);
    dff F3 (KEY[1], KEY[0], SW[3], A[3]);
    dff F4 (KEY[1], KEY[0], SW[4], A[4]);
    dff F5 (KEY[1], KEY[0], SW[5], A[5]);
    dff F6 (KEY[1], KEY[0], SW[6], A[6]);
    dff F7 (KEY[1], KEY[0], SW[7], A[7]);

    assign B = SW;
    assign S = {1'b0, A} + {1'b0, B};

    assign LEDR[0] = S[8];
    assign LEDR[9:1] = 9'b0;

    hex7 H0 (B[3:0], HEX0);
    hex7 H1 (B[7:4], HEX1);

    hex7 H2 (A[3:0], HEX2);
    hex7 H3 (A[7:4], HEX3);

    hex7 H4 (S[3:0], HEX4);
    hex7 H5 (S[7:4], HEX5);
endmodule


module dff (Clk, Reset, D, Q);
    input Clk, Reset, D;
    output Q;

    wire Qm;

    dlatch master (~Clk, Reset, D, Qm);
    dlatch slave (Clk, Reset, Qm, Q);
endmodule


module dlatch (Clk, Reset, D, Q);
    input Clk, Reset, D;
    output Q;

    wire R_g, S_g, Qbar;

    assign R_g = (~D & Clk) | ~Reset;
    assign S_g = D & Clk & Reset;

    assign Q = ~(R_g | Qbar);
    assign Qbar = ~(S_g | Q);
endmodule
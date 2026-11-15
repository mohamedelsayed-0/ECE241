module part3 (SW, LEDR);
    input [1:0] SW;
    output [9:0] LEDR;

    wire Qm;

    Dlatch master (SW[1], SW[0], Qm);
    Dlatch slave (~SW[1], Qm, LEDR[0]);

    assign LEDR[9:1] = 0;
endmodule

module Dlatch (Clk, D, Q);
    input Clk, D;
    output Q;

    wire R_g, S_g, Qb;

    assign R_g = ~D & Clk;
    assign S_g = D & Clk;

    assign Q = ~(R_g | Qb);
    assign Qb = ~(S_g | Q);
endmodule
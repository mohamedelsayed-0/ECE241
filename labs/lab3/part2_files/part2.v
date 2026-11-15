module D_latch (Clk, D, Q);
    input Clk, D;
    output Q;

    wire R_g, S_g, Qb;

    assign R_g = ~D & Clk;
    assign S_g = D & Clk;

    assign Q = ~(R_g | Qb);
    assign Qb = ~(S_g | Q);
endmodule
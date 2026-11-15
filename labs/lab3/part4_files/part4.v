module part4 (Clk, D, Qa, Qb, Qc);
    input Clk, D;
    output Qa, Qb, Qc;

    wire Qm1, Qm2;

    // Qa
    dlatch L1 (Clk, D, Qa);

    // Qb
    dlatch L2 (~Clk, D, Qm1);
    dlatch L3 (Clk, Qm1, Qb);

    // Qc
    dlatch L4 (Clk, D, Qm2);
    dlatch L5 (~Clk, Qm2, Qc);
endmodule


module dlatch (Clk, D, Q);
    input Clk, D;
    output Q;

    wire R_g, S_g, Qbar;

    assign R_g = ~D & Clk;
    assign S_g = D & Clk;

    assign Q = ~(R_g | Qbar);
    assign Qbar = ~(S_g | Q);
endmodule
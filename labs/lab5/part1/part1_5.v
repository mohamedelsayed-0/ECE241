
module part1_modified (
    input  [1:0] SW,
    input  [0:0] KEY,
    output [9:0] LEDR
);

    wire w = SW[1];
    reg [8:0] Q;
    wire [8:0] D;

    assign D[0] = 1'b1;

    assign D[1] = ~w & (~Q[0] | Q[5] | Q[6] |
                        Q[7] | Q[8]);

    assign D[2] = ~w & Q[1];
    assign D[3] = ~w & Q[2];
    assign D[4] = ~w & (Q[3] | Q[4]);

    assign D[5] = w & (~Q[0] | Q[1] | Q[2] | Q[3] | Q[4]);

    assign D[6] = w & Q[5];
    assign D[7] = w & Q[6];
    assign D[8] = w & (Q[7] | Q[8]);

    always @(posedge KEY[0]) begin
        if (!SW[0])
            Q <= 9'b000000000;
        else
            Q <= D;
    end

    assign LEDR[8:0] = Q;
    assign LEDR[9] = Q[4] | Q[8];

endmodule

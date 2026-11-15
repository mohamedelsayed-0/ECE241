
module part1 (
    input  [1:0] SW,
    input  [0:0] KEY,
    output [9:0] LEDR
);

    wire w = SW[1];
    wire reset_n = SW[0];
    wire Clock = KEY[0];

    reg  [8:0] Q;
    wire [8:0] D;

    assign D[0] = 1'b0; //a

    assign D[1] = ~w & (Q[0] | Q[5] | Q[6] | Q[7] | Q[8]); // b

    assign D[2] = ~w & Q[1]; //c
    assign D[3] = ~w & Q[2]; //d
    assign D[4] = ~w & (Q[3] | Q[4]); //e

    assign D[5] = w & (Q[0] | Q[1] | Q[2] | Q[3] | Q[4]); //f

    assign D[6] = w & Q[5]; //g
    assign D[7] = w & Q[6]; //h
    assign D[8] = w & (Q[7] | Q[8]); //i

    always @(posedge Clock) begin
        if (!reset_n)
            Q <= 9'b000000001; 
        else
            Q <= D;
    end

    assign LEDR[8:0] = Q;
    assign LEDR[9] = Q[4] | Q[8];

endmodule

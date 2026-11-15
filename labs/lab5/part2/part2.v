
module part2 (
    input [1:0] SW,
    input [0:0] KEY,
    output [9:0] LEDR
);

    wire w = SW[1];

    reg [3:0] y_Q, Y_D;

    parameter A = 4'b0000,
              B = 4'b0001,
              C = 4'b0010,
              D = 4'b0011,
              E = 4'b0100,
              F = 4'b0101,
              G = 4'b0110,
              H = 4'b0111,
              I = 4'b1000;

    // next-state
    always @(*) begin
        case (y_Q)
            A: Y_D = (!w) ? B : F;
            B: Y_D = (!w) ? C : F;
            C: Y_D = (!w) ? D : F;
            D: Y_D = (!w) ? E : F;
            E: Y_D = (!w) ? E : F;

            F: Y_D = (!w) ? B : G;
            G: Y_D = (!w) ? B : H;
            H: Y_D = (!w) ? B : I;
            I: Y_D = (!w) ? B : I;

            default: Y_D = A;
        endcase
    end

    // flip-flops
    always @(posedge KEY[0]) begin
        if (!SW[0])
            y_Q <= A;
        else
            y_Q <= Y_D;
    end

    // output
    assign LEDR[9] = (y_Q == E) || (y_Q == I);
    assign LEDR[8:4] = 5'b00000;
    assign LEDR[3:0] = y_Q;

endmodule

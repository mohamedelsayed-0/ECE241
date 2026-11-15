
module part4 (
    input CLOCK_50,
    input [0:0] KEY,
    output reg [6:0] HEX5, HEX4, HEX3,
    output reg [6:0] HEX2, HEX1, HEX0
);

    reg [2:0] timer;     // z
    reg [2:0] position;

    always @(posedge CLOCK_50) begin
        if (!KEY[0]) begin
            timer <= 0;
            position <= 0;
        end
        else if (timer == 4) begin  // z
            timer <= 0;

            if (position == 5)
                position <= 0;
            else
                position <= position + 1;
        end
        else
            timer <= timer + 1;
    end

    always @(*) begin
        HEX5 = 7'b1111111;
        HEX4 = 7'b1111111;
        HEX3 = 7'b1111111;
        HEX2 = 7'b1111111;
        HEX1 = 7'b1111111;
        HEX0 = 7'b1111111;

        case (position)
            0: begin
                HEX2 = 7'b0100001; // d
                HEX1 = 7'b0000110; // E
                HEX0 = 7'b1111001; // 1
            end

            1: begin
                HEX3 = 7'b0100001;
                HEX2 = 7'b0000110;
                HEX1 = 7'b1111001;
            end

            2: begin
                HEX4 = 7'b0100001;
                HEX3 = 7'b0000110;
                HEX2 = 7'b1111001;
            end

            3: begin
                HEX5 = 7'b0100001;
                HEX4 = 7'b0000110;
                HEX3 = 7'b1111001;
            end

            4: begin
                HEX5 = 7'b0000110;
                HEX4 = 7'b1111001;
                HEX0 = 7'b0100001;
            end

            5: begin
                HEX5 = 7'b1111001;
                HEX1 = 7'b0100001;
                HEX0 = 7'b0000110;
            end
        endcase
    end

endmodule

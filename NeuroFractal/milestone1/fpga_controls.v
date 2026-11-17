
module fpga_controls (
    input  wire [9:0] SW,
    input  wire [1:0] KEY,
	 //go coordinate mapepr
    output wire [7:0] pixel_x,
    output reg  [6:0] pixel_y,
	 //go mdanelbrot engine
    output wire reset,
    output wire start,
    output wire [7:0] max_iter
);
    // SW[7:0] selects pixel X. 160, 255 are outside the 160-pixel image.
    // clamp invalid X values to the last column (159).
    assign pixel_x = (SW[7:0] > 8'd159) ? 8'd159 : SW[7:0];

    // 
    always @(*) begin
        case (SW[9:8])
            2'b00: pixel_y = 7'd0;
            2'b01: pixel_y = 7'd40;
            2'b10: pixel_y = 7'd80;
            2'b11: pixel_y = 7'd119;
            default: pixel_y = 7'd0;
        endcase
    end

    assign reset = ~KEY[0];
    assign start = ~KEY[1];


    assign max_iter = 8'd100;
endmodule

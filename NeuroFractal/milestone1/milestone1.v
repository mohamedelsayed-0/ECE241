
module coordinate_mapper (
    input wire [7:0] pixel_x,//1606 bits
    input wire [6:0] pixel_y,//1207bit
    output wire signed [15:0] c_real,
    output wire signed [15:0] c_imag
);

    wire signed [31:0] real_value;
    wire signed [31:0] imag_value;

    // Convert pixel X to Q4.12 real coordinate
    assign real_value = -32'sd8192
        + (32'sd12288 * $signed({1'b0, pixel_x})) / 32'sd159;

    // Convert pixel Y to Q4.12 imaginary coordinate
    assign imag_value = 32'sd6144
        - (32'sd12288 * $signed({1'b0, pixel_y})) / 32'sd119;

    assign c_real = real_value[15:0];
    assign c_imag = imag_value[15:0];

endmodule

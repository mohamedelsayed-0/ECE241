module mandelbrot_engine (
    input clk,
    input reset, //  active-high
    input start, 
    input signed [15:0] c_real, // Q4.12
    input signed [15:0] c_imag, // Q4.12
    input [7:0]  max_iter,
    output reg [7:0]  iter_count,
    output reg done,
    output reg escaped
);
    localparam [1:0] IDLE = 2'd0,
                     ITERATE = 2'd1,
                     CHECK = 2'd2,
                     FINISHED = 2'd3;

    reg [1:0] state;
    reg signed [15:0] cr, ci;
    reg [7:0] limit;

    // retaining extra integer bits so the final escaping step cannot wrap
    reg signed [31:0] zr, zi;
    wire signed [63:0] xx = zr * zr;
    wire signed [63:0] yy = zi * zi;
    wire signed [63:0] xy = zr * zi;

    wire signed [63:0] next_real = ((xx - yy) >>> 12) + cr;
    wire signed [63:0] next_imag = ((xy <<< 1) >>> 12) + ci;

    // compare Q8.24 squared magnitudes against 4 * 2^24
    wire [64:0] magnitude_sq = {1'b0, xx} + {1'b0, yy};
    wire outside = (magnitude_sq > 65'd67108864);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            zr <= 0;
            zi <= 0;
            cr <= 0;
            ci <= 0;
            limit <= 0;
            iter_count <= 0;
            done <= 0;
            escaped <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        cr <= c_real;
                        ci <= c_imag;
                        limit <= max_iter;
                        zr <= 0;
                        zi <= 0;
                        iter_count <= 0;
                        done <= 0;
                        escaped <= 0;
                        state <= (max_iter == 0) ? CHECK : ITERATE;
                    end
                end

                ITERATE: begin
                    zr <= next_real[31:0];
                    zi <= next_imag[31:0];
                    iter_count <= iter_count + 8'd1;
                    state <= CHECK;
                end

                CHECK: begin
                    if (outside) begin
                        escaped <= 1'b1;
                        done <= 1'b1;
                        state <= FINISHED;
                    end else if (iter_count >= limit) begin
                        escaped <= 1'b0;
                        done <= 1'b1;
                        state <= FINISHED;
                    end else begin
                        state <= ITERATE;
                    end
                end

                FINISHED: begin
                    // hold the result until start is released; then re-arm.
                    if (!start)
                        state <= IDLE;
                end
            endcase
        end
    end
endmodule


module part3 #(
    parameter integer cycles = 25000000
)(
    input [2:0] SW,
    input CLOCK_50,
    input [1:0] KEY,
    output [9:0] LEDR
);

   // states
    parameter IDLE = 2'd0,
              ON   = 2'd1,
              GAP  = 2'd2;

    reg [1:0] state;

    reg [3:0] pattern;
    reg [2:0] symbols_left;
    reg [1:0] units_left;

    reg [3:0] selected_pattern;
    reg [2:0] selected_length;

    always @(*) begin
        case (SW)
            3'b000: begin // A: .-
                selected_pattern = 4'b0010;
                selected_length = 2;
            end
            3'b001: begin // B: -...
                selected_pattern = 4'b0001;
                selected_length = 4;
            end
            3'b010: begin // C: -.-.
                selected_pattern = 4'b0101;
                selected_length = 4;
            end
            3'b011: begin // D: -..
                selected_pattern = 4'b0001;
                selected_length = 3;
            end
            3'b100: begin // E: .
                selected_pattern = 4'b0000;
                selected_length = 1;
            end
            3'b101: begin // F: ..-.
                selected_pattern = 4'b0100;
                selected_length = 4;
            end
            3'b110: begin // G: --.
                selected_pattern = 4'b0011;
                selected_length = 3;
            end
            3'b111: begin // H: ....
                selected_pattern = 4'b0000;
                selected_length = 4;
            end
        endcase
    end

    reg [25:0] timer;
    wire tick = (timer == cycles - 1);

    // state machine
    always @(posedge CLOCK_50) begin
        if (!KEY[0]) begin
            state <= IDLE;
            pattern <= 0;
            symbols_left <= 0;
            units_left <= 0;
            timer <= 0;
        end
        else begin
            case (state)

                IDLE: begin
                    timer <= 0;

                    if (!KEY[1]) begin
                        pattern <= selected_pattern;
                        symbols_left <= selected_length;

                        if (selected_pattern[0])
                            units_left <= 3; // dash
                        else
                            units_left <= 1; // dot

                        state <= ON;
                    end
                end

                ON: begin
                    if (tick) begin
                        timer <= 0;

                        if (units_left > 1) begin
                            units_left <= units_left - 1;
                        end
                        else if (symbols_left == 1) begin
                            state <= IDLE;
                            symbols_left <= 0;
                        end
                        else begin
                            pattern <= pattern >> 1;
                            symbols_left <= symbols_left - 1;
                            state <= GAP;
                        end
                    end
                    else begin
                        timer <= timer + 1;
                    end
                end

                GAP: begin
                    if (tick) begin
                        timer <= 0;

                        if (pattern[0])
                            units_left <= 3;
                        else
                            units_left <= 1;

                        state <= ON;
                    end
                    else begin
                        timer <= timer + 1;
                    end
                end

                default: begin
                    state <= IDLE;
                    timer <= 0;
                end
            endcase
        end
    end

    assign LEDR[0] = (state == ON);
    assign LEDR[9:1] = 9'b0;

endmodule

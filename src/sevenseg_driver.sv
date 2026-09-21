module sevenseg_driver #(
    parameter integer CLK_HZ = 100_000_000
) (
    input  logic        clk,
    input  logic        reset,
    input  logic [1:0]  state,
    input  logic [13:0] reaction_ms,
    input  logic        false_start,
    output logic [6:0]  seg,
    output logic [3:0]  an
);
    localparam logic [1:0] IDLE   = 2'd0;
    localparam logic [1:0] WAIT_S = 2'd1;
    localparam logic [1:0] GO     = 2'd2;
    localparam logic [1:0] RESULT = 2'd3;

    localparam integer REFRESH_DIV = CLK_HZ / 4000;
    localparam integer REFRESH_MAX = (REFRESH_DIV < 1) ? 0 : REFRESH_DIV - 1;
    localparam integer REFRESH_W = (REFRESH_MAX < 1) ? 1 : $clog2(REFRESH_MAX + 1);

    logic [REFRESH_W-1:0] refresh_count;
    logic [1:0] digit_sel;
    logic [4:0] symbols [0:3];
    logic [4:0] current_symbol;

    localparam logic [4:0] SYM_0 = 5'd0;
    localparam logic [4:0] SYM_9 = 5'd9;
    localparam logic [4:0] SYM_F = 5'd10;
    localparam logic [4:0] SYM_A = 5'd11;
    localparam logic [4:0] SYM_L = 5'd12;
    localparam logic [4:0] SYM_S = 5'd13;
    localparam logic [4:0] SYM_DASH = 5'd14;
    localparam logic [4:0] SYM_BLANK = 5'd15;

    integer value;

    always_ff @(posedge clk) begin
        if (reset) begin
            refresh_count <= '0;
            digit_sel <= 2'd0;
        end else if (refresh_count == REFRESH_MAX) begin
            refresh_count <= '0;
            digit_sel <= digit_sel + 1'b1;
        end else begin
            refresh_count <= refresh_count + 1'b1;
        end
    end

    always_comb begin
        symbols[0] = SYM_BLANK;
        symbols[1] = SYM_BLANK;
        symbols[2] = SYM_BLANK;
        symbols[3] = SYM_BLANK;
        value = reaction_ms;

        case (state)
            IDLE: begin
                symbols[0] = SYM_DASH;
                symbols[1] = SYM_DASH;
                symbols[2] = SYM_DASH;
                symbols[3] = SYM_DASH;
            end

            WAIT_S: begin
                symbols[0] = SYM_BLANK;
                symbols[1] = SYM_BLANK;
                symbols[2] = SYM_BLANK;
                symbols[3] = SYM_BLANK;
            end

            GO: begin
                symbols[0] = SYM_0;
                symbols[1] = SYM_0;
                symbols[2] = SYM_0;
                symbols[3] = SYM_0;
            end

            RESULT: begin
                if (false_start) begin
                    symbols[0] = SYM_F;
                    symbols[1] = SYM_A;
                    symbols[2] = SYM_L;
                    symbols[3] = SYM_S;
                end else begin
                    symbols[0] = (value / 1000) % 10;
                    symbols[1] = (value / 100)  % 10;
                    symbols[2] = (value / 10)   % 10;
                    symbols[3] = value % 10;
                end
            end

            default: begin
                symbols[0] = SYM_BLANK;
                symbols[1] = SYM_BLANK;
                symbols[2] = SYM_BLANK;
                symbols[3] = SYM_BLANK;
            end
        endcase
    end

    always_comb begin
        case (digit_sel)
            2'd0: begin an = 4'b1110; current_symbol = symbols[3]; end
            2'd1: begin an = 4'b1101; current_symbol = symbols[2]; end
            2'd2: begin an = 4'b1011; current_symbol = symbols[1]; end
            default: begin an = 4'b0111; current_symbol = symbols[0]; end
        endcase

        case (current_symbol)
            5'd0:  seg = 7'b0000001;
            5'd1:  seg = 7'b1001111;
            5'd2:  seg = 7'b0010010;
            5'd3:  seg = 7'b0000110;
            5'd4:  seg = 7'b1001100;
            5'd5:  seg = 7'b0100100;
            5'd6:  seg = 7'b0100000;
            5'd7:  seg = 7'b0001111;
            5'd8:  seg = 7'b0000000;
            5'd9:  seg = 7'b0000100;
            SYM_F: seg = 7'b0111000;
            SYM_A: seg = 7'b0001000;
            SYM_L: seg = 7'b1110001;
            SYM_S: seg = 7'b0100100;
            SYM_DASH: seg = 7'b1111110;
            default: seg = 7'b1111111;
        endcase
    end
endmodule

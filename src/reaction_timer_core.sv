module reaction_timer_core #(
    parameter integer MIN_WAIT_MS = 1000,
    parameter integer MAX_WAIT_MS = 4000
) (
    input  logic        clk,
    input  logic        reset,
    input  logic        ms_tick,
    input  logic        button_pressed,
    input  logic [15:0] random_value,
    output logic [1:0]  state,
    output logic [13:0] reaction_ms,
    output logic        false_start
);
    localparam logic [1:0] IDLE   = 2'd0;
    localparam logic [1:0] WAIT_S = 2'd1;
    localparam logic [1:0] GO     = 2'd2;
    localparam logic [1:0] RESULT = 2'd3;

    localparam integer WAIT_RANGE = MAX_WAIT_MS - MIN_WAIT_MS + 1;

    logic [13:0] wait_target_ms;
    logic [13:0] wait_elapsed_ms;
    logic [13:0] go_elapsed_ms;

    always_ff @(posedge clk) begin
        if (reset) begin
            state           <= IDLE;
            reaction_ms     <= 14'd0;
            false_start     <= 1'b0;
            wait_target_ms  <= MIN_WAIT_MS;
            wait_elapsed_ms <= 14'd0;
            go_elapsed_ms   <= 14'd0;
        end else begin
            case (state)
                IDLE: begin
                    reaction_ms <= 14'd0;
                    false_start <= 1'b0;
                    wait_elapsed_ms <= 14'd0;
                    go_elapsed_ms <= 14'd0;

                    if (button_pressed) begin
                        wait_target_ms <= MIN_WAIT_MS + (random_value % WAIT_RANGE);
                        state <= WAIT_S;
                    end
                end

                WAIT_S: begin
                    if (button_pressed) begin
                        false_start <= 1'b1;
                        reaction_ms <= 14'd0;
                        state <= RESULT;
                    end else if (ms_tick) begin
                        if (wait_elapsed_ms + 1'b1 >= wait_target_ms) begin
                            wait_elapsed_ms <= 14'd0;
                            go_elapsed_ms <= 14'd0;
                            state <= GO;
                        end else begin
                            wait_elapsed_ms <= wait_elapsed_ms + 1'b1;
                        end
                    end
                end

                GO: begin
                    if (button_pressed) begin
                        reaction_ms <= go_elapsed_ms;
                        false_start <= 1'b0;
                        state <= RESULT;
                    end else if (ms_tick) begin
                        if (go_elapsed_ms < 14'd9999)
                            go_elapsed_ms <= go_elapsed_ms + 1'b1;
                    end
                end

                RESULT: begin
                    if (button_pressed)
                        state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule

module debounce #(
    parameter integer STABLE_SAMPLES = 4
) (
    input  logic clk,
    input  logic reset,
    input  logic sample_tick,
    input  logic noisy_in,
    output logic clean,
    output logic pressed
);
    localparam integer WIDTH = (STABLE_SAMPLES <= 2) ? 1 : $clog2(STABLE_SAMPLES + 1);

    logic sync_1, sync_2;
    logic [WIDTH-1:0] high_count;
    logic [WIDTH-1:0] low_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            sync_1    <= 1'b0;
            sync_2    <= 1'b0;
            clean      <= 1'b0;
            pressed    <= 1'b0;
            high_count <= '0;
            low_count  <= '0;
        end else begin
            sync_1 <= noisy_in;
            sync_2 <= sync_1;
            pressed <= 1'b0;

            if (sample_tick) begin
                if (sync_2) begin
                    low_count <= '0;
                    if (high_count < STABLE_SAMPLES)
                        high_count <= high_count + 1'b1;

                    if ((high_count >= STABLE_SAMPLES - 1) && !clean) begin
                        clean   <= 1'b1;
                        pressed <= 1'b1;
                    end
                end else begin
                    high_count <= '0;
                    if (low_count < STABLE_SAMPLES)
                        low_count <= low_count + 1'b1;

                    if (low_count >= STABLE_SAMPLES - 1)
                        clean <= 1'b0;
                end
            end
        end
    end
endmodule

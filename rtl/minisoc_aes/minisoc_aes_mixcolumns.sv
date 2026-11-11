module mixcolumns#(parameter STAGES_XTIMES_SERIAL = 2, STAGES_XTIMES_PARALLEL = 4)(
    input  logic        clock,
    input  logic        nreset,
    input logic         ena,
    input  logic [7:0]  x_data[STAGES_XTIMES_PARALLEL-1:0],
    input  logic [7:0] y_data[STAGES_XTIMES_PARALLEL-1:0], 
    output logic [7:0] c_data[STAGES_XTIMES_PARALLEL-1:0]
);
logic [7:0] xtimes_matrix_data[STAGES_XTIMES_PARALLEL-1:0][STAGES_XTIMES_SERIAL-1:0];
logic [7:0] and_xtimes_expand_bits[STAGES_XTIMES_PARALLEL-1:0][STAGES_XTIMES_SERIAL-1:0];
logic [7:0] xor_xtimes_expand_bits[STAGES_XTIMES_PARALLEL-1:0][STAGES_XTIMES_SERIAL-1:0];


    generate
        genvar  i, j;
        for(i = 0; i < STAGES_XTIMES_PARALLEL; i++)begin: g_lane
            assign xtimes_matrix_data[i][0] = x_data[i];
            for(j = 1; j < STAGES_XTIMES_SERIAL; j++)begin: g_xtimes
                xtimes ut_xtimes(
                    .clock (clock ),
                    .nreset(nreset),
                    .x_data(xtimes_matrix_data[i][j-1]),
                    .y_data(xtimes_matrix_data[i][j]),
                    .ena   (ena   )
                );
            end 

            for(j = 0; j < STAGES_XTIMES_SERIAL; j++)begin: g_term
                assign and_xtimes_expand_bits[i][j] = {(8){y_data[i][j]}} & xtimes_matrix_data[i][j];
            end

            assign xor_xtimes_expand_bits[i][0] = and_xtimes_expand_bits[i][0];
            assign c_data[i] = xor_xtimes_expand_bits[i][STAGES_XTIMES_SERIAL-1];

            for(j = 1; j < STAGES_XTIMES_SERIAL ; j++)begin: g_acc
                assign xor_xtimes_expand_bits[i][j] = xor_xtimes_expand_bits[i][j-1] ^ and_xtimes_expand_bits[i][j];
            end

        end
    endgenerate
endmodule
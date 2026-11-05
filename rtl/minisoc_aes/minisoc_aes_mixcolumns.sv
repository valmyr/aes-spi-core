module mixcolumns#(parameter STAGES_XTIMES_SERIAL = 2, STAGES_XTIMES_PARALLEL =4 )(
    input  logic       clock,
    input  logic       nreset,
    input  logic [7:0] x_data[STAGES_XTIMES_PARALLEL-1:0],
    input  logic [7:0] y_data[STAGES_XTIMES_PARALLEL-1:0],
    output logic [7:0] z_data
);
logic [7:0] connect_data[STAGES_XTIMES_SERIAL-1:0][STAGES_XTIMES_PARALLEL-1:0];


    generate
        genvar  i, j;
        for(i = 0; i < STAGES_XTIMES_PARALLEL; i++)begin
            assign connect_data[i][0] = x_data[i];
            for(j = 1; j < STAGES_XTIMES_SERIAL; j++)begin
                xtimes uut_xtimes1(
                    .clock (clock ),
                    .nreset(nreset),
                    .x_data(connect_data[i][j-1]),
                    .y_data(connect_data[i][j]),
                    .ena   (ena   )
                );
            end 
        end
    endgenerate

    logic [7:0]pre_xor[STAGES_XTIMES_SERIAL-1:0];

    generate
        genvar  k, l;
        for(k = 0; k < STAGES_XTIMES_PARALLEL; k++)begin
            for(l = 0; l < STAGES_XTIMES_SERIAL; l++)begin
                assign pre_xor[i] = ({8{y_data[l]}} & connect_data[k][l]);
            end 
        end
    endgenerate

    
endmodule
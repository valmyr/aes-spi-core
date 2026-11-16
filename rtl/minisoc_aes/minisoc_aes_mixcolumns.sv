module mixcolumns#(parameter STAGES_XTIMES_SERIAL = 2, STAGES_XTIMES_PARALLEL = 4)(
    input  logic        clock,
    input  logic        nreset,
    input  logic        ena,
    output logic        done,
    input  logic [7:0]  gf_input_data[0:STAGES_XTIMES_PARALLEL-1][0:STAGES_XTIMES_PARALLEL-1],
    input  logic [7:0]  op_input_data[0:STAGES_XTIMES_PARALLEL-1][0:STAGES_XTIMES_PARALLEL-1], 
    output logic [7:0]  fg_output_data[0:STAGES_XTIMES_PARALLEL-1][0:STAGES_XTIMES_PARALLEL-1]
);
logic [2:0] counter;
logic [2:0] counter_nt;

logic [7:0]  op_input_data_intern[0:STAGES_XTIMES_PARALLEL-1];
logic [7:0]  fg_output_data_intern[0:STAGES_XTIMES_PARALLEL-1];
generate
    genvar i, j;
    for(i = 0; i < 4; i++)begin
                gf_256#(.STAGES_XTIMES_SERIAL(STAGES_XTIMES_SERIAL), .STAGES_XTIMES_PARALLEL(STAGES_XTIMES_PARALLEL)) gf_256_ut(
                .clock(clock),
                .nreset(nreset),
                .ena(ena),
                .gf_input_data(gf_input_data[i]),
                .op_input_data(op_input_data_intern), 
                .fg_output_data(fg_output_data_intern[i])
            );
    end
endgenerate


assign done = counter_nt == STAGES_XTIMES_PARALLEL-1;

//always_comb op_input_data_intern = op_input_data[counter];
always_ff@(posedge clock, negedge nreset) begin
    if(!nreset)begin
        counter <= 0;
        counter_nt <= 0;
        fg_output_data <= '{default:0};
        op_input_data_intern <= '{default:0};
    end else begin
        if(ena)begin
            counter <=  (counter == STAGES_XTIMES_PARALLEL-1) ? 0 :counter + 1;
            counter_nt <= counter;
            op_input_data_intern <= op_input_data[counter];
            fg_output_data[counter_nt] <= fg_output_data_intern;
        end 
        
    end
end





endmodule
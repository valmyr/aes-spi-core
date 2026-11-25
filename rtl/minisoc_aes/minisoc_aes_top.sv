module aes_core(
    input logic clock,
    input logic nreset,
    input logic [127:0] data_input,
    input logic [127:0] ut_addroundkey_key,
    output logic [127:0] data_output_subbytes,
    output logic [127:0] data_output_shiftrows
);
localparam MATRIX_LEN = 4;
// Sinais ShiftRows Rotacional...
logic [7:0] ut_shiftrows_input_data[0:3][0:3];
logic [7:0] ut_shiftrows_output_data[0:3][0:3];
    
// Sinais SubBytes...
logic       ut_subbytes_clock;
logic       ut_subbytes_nreset;
logic [7:0] ut_subbytes_input_data[0:3][0:3];
logic [7:0] ut_subbytes_output_data[0:3][0:3];
logic       ut_subbytes_valid_i;
logic       ut_subbytes_ready_o ;
logic       ut_subbytes_rvalid_o;
logic       ut_subbytes_rready_i;

// roundkey_data
logic [127:0] ut_addroundkey_data_out;

//MixColumns
logic      ut_mixcolumns_clock;
logic      ut_mixcolumns_nreset;
logic      ut_mixcolumns_ena;
logic [7:0]ut_mixcolumns_gf_input_data[0:3][0:3];
logic [3:0][3:0][7:0] ut_mixcolumns_op_input_data_unpacked;
logic [7:0] ut_mixcolumns_op_input_data_packed[3:0][3:0];


assign ut_mixcolumns_op_input_data_unpacked = '{
    '{8'h02, 8'h03, 8'h01, 8'h01},
    '{8'h01, 8'h02, 8'h03, 8'h01},
    '{8'h01, 8'h01, 8'h02, 8'h03},
    '{8'h03, 8'h01, 8'h01, 8'h02}
};
always_comb begin
    for (int i = 0; i < 4; i++) begin
        for (int j = 0; j < 4; j++) begin
            ut_mixcolumns_op_input_data_packed[i][j] = ut_mixcolumns_op_input_data_unpacked[i][j];
        end
    end
end


logic [7:0]ut_mixcolumns_fg_output_data[0:3][0:3];
    
assign ut_subbytes_clock = clock;
assign ut_subbytes_nreset = nreset;

assign ut_mixcolumns_nreset = nreset;
assign ut_mixcolumns_clock = clock;

assign ut_mixcolumns_gf_input_data =ut_shiftrows_output_data;
assign ut_mixcolumns_ena = ut_subbytes_rvalid_o;
addroundkey ut_addroundkey(
    .data_in(data_input),
    .key(ut_addroundkey_key),
    .data_out(ut_addroundkey_data_out)
);

//vec2matrix
vec2matrix #(.MATRIX_LEN(MATRIX_LEN))vex2matrix_unflatten(
    .data_in(ut_addroundkey_data_out),
    .data_out(ut_subbytes_input_data)
);

//ShiftRows ut

shiftrows #(.MATRIX_LEN(MATRIX_LEN))ut_shiftrows(
    .input_data(ut_shiftrows_input_data),
    .output_data(ut_shiftrows_output_data)
);
    
//SubBytes ut
//assign ut_subbytes_input_data = ut_shiftrows_output_data; 
assign ut_shiftrows_input_data = ut_subbytes_output_data; 
assign ut_subbytes_valid_i =1'b1;
subbytes ut_subbytes(
    .clock(ut_subbytes_clock),
    .nreset(ut_subbytes_nreset),
    .input_data(ut_subbytes_input_data),
    .output_data(ut_subbytes_output_data),
    .valid_i(ut_subbytes_valid_i),
    .ready_o(ut_subbytes_ready_o),
    .rvalid_o(ut_subbytes_rvalid_o),
    .rready_i(ut_subbytes_rready_i),
    .matrix_len(4)

);
    
mixcolumns#(.STAGES_XTIMES_SERIAL(8),.STAGES_XTIMES_PARALLEL(4)) mixcolumns_uut(
    .clock(ut_mixcolumns_clock),
    .nreset(ut_mixcolumns_nreset),
    .ena(ut_mixcolumns_ena),
    .gf_input_data(ut_mixcolumns_gf_input_data),
    .op_input_data(ut_mixcolumns_op_input_data_packed), 
    .fg_output_data(ut_mixcolumns_fg_output_data)
);


matrix2vec #(.MATRIX_LEN(MATRIX_LEN))matrix2vec_flatten0(
    .data_in(ut_subbytes_output_data),
    .data_out(data_output_subbytes)
);
matrix2vec #(.MATRIX_LEN(MATRIX_LEN))matrix2vec_flatten1(
    .data_in(ut_shiftrows_output_data),
    .data_out(data_output_shiftrows)
);
endmodule
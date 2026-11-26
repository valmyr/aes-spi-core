module aes_core(
    input  logic         clock,
    input  logic         nreset,
    input  logic [127:0] aes_core_data_input,
    input  logic [127:0] aes_core_key_input,
    output logic [127:0] aes_core_data_output,
    input  logic         aes_core_valid_i,
    output logic         aes_core_ready_o ,
    output logic         aes_core_rvalid_o,
    input  logic         aes_core_rready_i

);
localparam MATRIX_LEN = 4;
//ShiftRows Rotacional...
logic [7:0] ut_shiftrows_input_data[0:3][0:3];
logic [7:0] ut_shiftrows_output_data[0:3][0:3];
    
//SubBytes...
logic [7:0] ut_subbytes_input_data[0:3][0:3];
logic [7:0] ut_subbytes_output_data[0:3][0:3];
logic       ut_subbytes_valid_i;
logic       ut_subbytes_ready_o ;
logic       ut_subbytes_rvalid_o;
logic       ut_subbytes_rready_i;

// Round key
logic [127:0] ut_addroundkey_data_out;

//Mix Columns
logic       ut_mixcolumns_ena;
logic [7:0] ut_mixcolumns_gf_input_data[0:3][0:3];
logic [7:0] ut_mixcolumns_op_input_data_packed[3:0][3:0];
logic [3:0][3:0][7:0] ut_mixcolumns_op_input_data_unpacked;

//Key Expansion
logic [127:0]  ut_aes_key_exp_key_current;
logic [7:0]    ut_aes_key_exp_iteration_current;
logic [7:0]    ut_aes_key_exp_iteration_next;
logic [127:0]  ut_aes_key_exp_key_next;
logic          ut_aes_key_exp_valid_i;
logic          ut_aes_key_exp_ready_o;
logic          ut_aes_key_exp_rvalid_o;
logic          ut_aes_key_exp_rready_i;
// Unit control aes
logic          ut_control_unit_subbytes_valid_i;
logic          ut_control_unit_subbytes_ready_o;
logic          ut_control_unit_subbytes_rvalid_o;
logic          ut_control_unit_subbytes_rready_i;
logic          ut_control_unit_aes_key_exp_valid_i;
logic          ut_control_unit_aes_key_exp_ready_o;
logic          ut_control_unit_aes_key_exp_rvalid_o;
logic          ut_control_unit_aes_key_exp_rready_i;
logic          ut_control_unit_aes_core_valid_i;
logic          ut_control_unit_aes_core_ready_o;
logic          ut_control_unit_aes_core_rvalid_o;
logic          ut_control_unit_aes_core_rready_i;
logic          ut_control_unit_mixcolumns_ena;
logic [7:0]ut_mixcolumns_fg_output_data[0:3][0:3];


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
    


addroundkey ut_addroundkey(
    .data_in(data_input),
    .key(ut_addroundkey_key),
    .data_out(ut_addroundkey_data_out)
);



subbytes ut_subbytes(
    .clock(clock),
    .nreset(nreset),
    .input_data(ut_subbytes_input_data),
    .output_data(ut_subbytes_output_data),
    .valid_i(ut_subbytes_valid_i),
    .ready_o(ut_subbytes_ready_o),
    .rvalid_o(ut_subbytes_rvalid_o),
    .rready_i(ut_subbytes_rready_i),
    .matrix_len(4)

);
    
mixcolumns#(.STAGES_XTIMES_SERIAL(8),.STAGES_XTIMES_PARALLEL(4)) ut_mixcolumns(
    .clock(clock),
    .nreset(nreset),
    .ena(ut_mixcolumns_ena),
    .gf_input_data(ut_mixcolumns_gf_input_data),
    .op_input_data(ut_mixcolumns_op_input_data_packed), 
    .fg_output_data(ut_mixcolumns_fg_output_data)
);


aes_key_exp ut_aes_key_exp(
   .clock(clock),
   .nreset(nreset),
   .key_current(ut_aes_key_exp_key_current),
   .iteration_current(ut_aes_key_exp_iteration_current),
   .iteration_next(ut_aes_key_exp_iteration_next),
   .key_next(ut_aes_key_exp_key_next),
   .valid_i(ut_aes_key_exp_valid_i),
   .ready_o(ut_aes_key_exp_ready_o),
   .rvalid_o(ut_aes_key_exp_rvalid_o),
   .rready_i(ut_aes_key_exp_rready_i)
);


assign ut_subbytes_valid_i                 = ut_control_unit_subbytes_valid_i;
assign ut_control_unit_subbytes_ready_o    = ut_subbytes_ready_o ;
assign ut_control_unit_subbytes_rvalid_o   = ut_subbytes_rvalid_o ;
assign ut_subbytes_rready_i                = ut_control_unit_subbytes_rready_i;
assign ut_aes_key_exp_valid_i              = ut_control_unit_aes_key_exp_valid_i;
assign ut_control_unit_aes_key_exp_ready_o = ut_aes_key_exp_ready_o;
assign ut_control_unit_aes_key_exp_rvalid_o= ut_aes_key_exp_rvalid_o;
assign ut_aes_key_exp_rready_i             = ut_control_unit_aes_key_exp_rready_i;
assign ut_control_unit_aes_core_valid_i    = aes_core_valid_i;
assign aes_core_ready_o                    = ut_control_unit_aes_core_ready_o;
assign aes_core_rvalid_o                   = ut_control_unit_aes_core_rvalid_o ;
assign ut_control_unit_aes_core_rready_i   = aes_core_rready_i;
assign ut_mixcolumns_ena                   = ut_control_unit_mixcolumns_ena;


aes_control_unit ut_aes_control_unit(
   .clock(clock),
   .nreset(nreset),
   .subbytes_valid_i(ut_control_unit_subbytes_valid_i),
   .subbytes_ready_o(ut_control_unit_subbytes_ready_o),
   .subbytes_rvalid_o(ut_control_unit_subbytes_rvalid_o),
   .subbytes_rready_i(ut_control_unit_subbytes_rready_i),
   .aes_key_exp_valid_i(ut_control_unit_aes_key_exp_valid_i),
   .aes_key_exp_ready_o(ut_control_unit_aes_key_exp_ready_o),
   .aes_key_exp_rvalid_o(ut_control_unit_aes_key_exp_rvalid_o),
   .aes_key_exp_rready_i(ut_control_unit_aes_key_exp_rready_i),
   .aes_core_valid_i(ut_control_unit_aes_core_valid_i),
   .aes_core_ready_o(ut_control_unit_aes_core_ready_o), 
   .aes_core_rvalid_o(ut_control_unit_aes_core_rvalid_o),
   .aes_core_rready_i(ut_control_unit_aes_core_rready_i),
   .mixcolumns_ena(ut_control_unit_mixcolumns_ena)
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
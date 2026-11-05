module aes_core(
    input logic clock,
    input logic nreset,
    input logic [127:0] data_input,
    output logic [127:0] data_output_subbytes,
    output logic [127:0] data_output_shiftrows
);
localparam MATRIX_LEN = 4;
// Sinais ShiftRows Rotacional...
logic [7:0] uut_shiftrows_input_data[0:3][0:3];
logic [7:0] uut_shiftrows_output_data[0:3][0:3];
    
// Sinais SubBytes...
logic       uut_subbytes_clock;
logic       uut_subbytes_nreset;
logic [7:0] uut_subbytes_input_data[0:3][0:3];
logic [7:0] uut_subbytes_output_data[0:3][0:3];
logic       uut_subbytes_valid_i;
logic       uut_subbytes_ready_o ;
logic       uut_subbytes_rvalid_o;
logic       uut_subbytes_rready_i;


//
assign uut_subbytes_clock = clock;
assign uut_subbytes_nreset = nreset;

//vec2matrix
vec2matrix #(.MATRIX_LEN(MATRIX_LEN))vex2matrix_unflatten(
    .data_in(data_input),
    .data_out(uut_subbytes_input_data)
);
//ShiftRows UUT

shiftrows #(.MATRIX_LEN(MATRIX_LEN))uut_shiftrows(
    .input_data(uut_shiftrows_input_data),
    .output_data(uut_shiftrows_output_data)
);
    
//SubBytes UUT
//assign uut_subbytes_input_data = uut_shiftrows_output_data; 
assign uut_shiftrows_input_data = uut_subbytes_output_data; 
assign uut_subbytes_valid_i =1'b1;
subbytes uut_subbytes(
    .clock(uut_subbytes_clock),
    .nreset(uut_subbytes_nreset),
    .input_data(uut_subbytes_input_data),
    .output_data(uut_subbytes_output_data),
    .valid_i(uut_subbytes_valid_i),
    .ready_o(uut_subbytes_ready_o),
    .rvalid_o(uut_subbytes_rvalid_o),
    .rready_i(uut_subbytes_rready_i)
);
    

matrix2vec #(.MATRIX_LEN(MATRIX_LEN))matrix2vec_flatten0(
    .data_in(uut_subbytes_output_data),
    .data_out(data_output_subbytes)
);
matrix2vec #(.MATRIX_LEN(MATRIX_LEN))matrix2vec_flatten1(
    .data_in(uut_shiftrows_output_data),
    .data_out(data_output_shiftrows)
);
endmodule
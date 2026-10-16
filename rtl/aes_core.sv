module aes_core();

// Sinais ShiftRows Rotacional...
logic [7:0] uut_shiftrows_input_data[3:0][3:0];
logic [7:0] uut_shiftrows_output_data[3:0][3:0];
    
// Sinais SubBytes...
logic       uut_subbytes_clock;
logic       uut_subbytes_nreset;
logic [7:0] uut_subbytes_input_data[3:0][3:0];
logic [7:0] uut_subbytes_output_data[3:0][3:0];
logic       uut_subbytes_valid_i;
logic       uut_subbytes_ready_o ;
logic       uut_subbytes_rvalid_o;
logic       uut_subbytes_rready_i;



//ShiftRows UUT

shiftrows #(.MATRIX_LEN(MATRIX_LEN))uut_shiftrows(
    .input_data(uut_shiftrows_input_data),
    .output_data(uut_shiftrows_output_data)
);
    
//SubBytes UUT

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
    
endmodule
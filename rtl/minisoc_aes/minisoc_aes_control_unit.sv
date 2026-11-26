module aes_control_unit(
    input   logic clock,
    input   logic nreset,
    output  logic subbytes_valid_i,
    input   logic subbytes_ready_o,
    input   logic subbytes_rvalid_o,
    output  logic subbytes_rready_i,
    output  logic aes_key_exp_valid_i,
    input   logic aes_key_exp_ready_o,
    input   logic aes_key_exp_rvalid_o,
    output  logic aes_key_exp_rready_i,
    input   logic aes_core_valid_i,
    output  logic aes_core_ready_o, 
    output  logic aes_core_rvalid_o,
    input   logic aes_core_rready_i,
    output  logic mixcolumns_ena
);





endmodule
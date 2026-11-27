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
    output  logic mixcolumns_ena,
    output  logic shift_rows_ena,
    output  logic addroundkey_ena
);



//typedef enum logic [2:0] {
//    IDLE,
//    SHIFTROWS,
//    ROUNDKEY,
//    SUBBYTES,
//    KEY_EXPANSION,
//    DONE
//} state_t;
//state_t current, next;
//
//
//always_ff@(posedge clock, negedge nreset)begin
//    if(!nreset)begin    
//        current <= IDLE;
//    end else begin
//        current <= next;
//    end
//    
//end 
//
//
//always_comb case(current)
//    IDLE:begin
//        
//    end
//    SHIFTROWS:begin
//        
//    end
//    ROUNDKEY:begin
//        
//    end
//    SUBBYTES:begin
//        
//    end
//    KEY_EXPANSION:begin
//        
//    end
//    DONE:begin
//        
//    end
//    default:begin
//        
//    end
//endcase 
endmodule
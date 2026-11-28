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
    output  logic addroundkey_ena,
    output logic [3:0]round_count
);



typedef enum logic [2:0] {
    IDLE,
    ROUNDKEY,
    SHIFTROWS,
    SUBBYTES,
    KEY_EXPANSION,
    DONE
} state_t;
state_t current, next;
logic [3:0]round_count_next;


always_ff@(posedge clock, negedge nreset)begin
    if(!nreset)begin    
        current <= IDLE;
        round_count <= 0;
    end else begin
        current <= next;
        if(aes_key_exp_rvalid_o)round_count <= (round_count == 10) ? 0 :round_count_next;
    end
    
end 


always_comb case(current)
    IDLE:begin
        next =  aes_core_valid_i ? ROUNDKEY:IDLE;
        aes_core_ready_o = 1;
        aes_core_rvalid_o = 0;
        addroundkey_ena = 0;
        shift_rows_ena = 0;
        mixcolumns_ena = 0;
        subbytes_valid_i = 0;
        subbytes_rready_i = 0;
        aes_key_exp_rready_i = 0;
        aes_key_exp_valid_i = 0;
        round_count_next = round_count;
    end
    ROUNDKEY:begin
        next =  SHIFTROWS;
        aes_core_ready_o = 0;
        aes_core_rvalid_o = 0;
        addroundkey_ena = 1;
        shift_rows_ena = 0;
        mixcolumns_ena = 0;
        subbytes_valid_i = 0;
        subbytes_rready_i = 0;
        aes_key_exp_rready_i = (round_count != 0); // Aualização da chave obtida do key expansion
        aes_key_exp_valid_i = 0;
        round_count_next = round_count;
    end
    SHIFTROWS:begin
        next =  subbytes_ready_o ? SUBBYTES :SHIFTROWS;
        aes_core_ready_o = 0;
        aes_core_rvalid_o = 0;
        addroundkey_ena = 0;
        shift_rows_ena = 1;
        mixcolumns_ena = 0;
        subbytes_valid_i = 0;
        subbytes_rready_i = 0;
        aes_key_exp_rready_i = 0;
        aes_key_exp_valid_i = 0;      
        round_count_next = round_count;
    end
    SUBBYTES:begin
        next = subbytes_rvalid_o ? KEY_EXPANSION:SUBBYTES ;
        aes_core_ready_o = 0;
        aes_core_rvalid_o = 0;
        addroundkey_ena = 0;
        shift_rows_ena = 0;
        mixcolumns_ena = 0;
        subbytes_valid_i = 1;
        subbytes_rready_i = 0;
        aes_key_exp_rready_i = 0;
        aes_key_exp_valid_i = 0;
        round_count_next = round_count;
        
    end
    KEY_EXPANSION:begin
        next = aes_key_exp_rvalid_o ? ROUNDKEY  : KEY_EXPANSION;
        aes_core_ready_o = 0;
        aes_core_rvalid_o = 0;
        addroundkey_ena = 0;
        shift_rows_ena = 0;
        mixcolumns_ena = 0;
        subbytes_valid_i = 0;
        subbytes_rready_i = 1;
        aes_key_exp_rready_i = 0;
        aes_key_exp_valid_i = 1;
        round_count_next = aes_key_exp_rvalid_o ? round_count+1: round_count;
    end
    DONE:begin
        next =  SHIFTROWS;
        aes_core_ready_o = 0;
        aes_core_rvalid_o = 0;
        addroundkey_ena = 0;
        shift_rows_ena = 0;
        mixcolumns_ena = 0;
        subbytes_valid_i = 0;
        subbytes_rready_i = 0;
        aes_key_exp_rready_i = 1;
        aes_key_exp_valid_i = 0; 
        round_count_next =round_count;
    end
    default:begin
        next =  aes_core_valid_i ? IDLE: ROUNDKEY;
        aes_core_ready_o = 1;
        aes_core_rvalid_o = 0;
        addroundkey_ena = 0;
        shift_rows_ena = 0;
        mixcolumns_ena = 0;
        subbytes_valid_i = 0;
        subbytes_rready_i = 0;
        aes_key_exp_rready_i = 0;
        aes_key_exp_valid_i = 0;
        round_count_next = round_count;
    end
endcase 
endmodule
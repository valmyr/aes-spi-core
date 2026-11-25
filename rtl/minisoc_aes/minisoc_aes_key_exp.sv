module aes_key_exp(
    input   logic          clock,
    input   logic          nreset,
    input   logic [127:0]  key_current,
    input   logic [7:0]    iteration_current,
    output  logic [7:0]    iteration_next,
    output  logic [127:0]  key_next,
    input   logic          valid_i,
    output  logic          ready_o ,
    output  logic          rvalid_o,
    input   logic          rready_i
);


logic [7:0]  key_master_matrix [0:3][0:3];
logic [7:0]  key_master_matrix0 [0:3][0:3];
logic [0:9][31:0] rcon_rounds_rom;
logic [31:0] rcon_round;
logic       ut_subbytes_clock;
logic       ut_subbytes_nreset;
logic [7:0] ut_subbytes_input_data[0:3][0:3];
logic [7:0] ut_subbytes_output_data[0:3][0:3];
logic       ut_subbytes_valid_i;
logic       ut_subbytes_ready_o ;
logic       ut_subbytes_rvalid_o;
logic       ut_subbytes_rready_i;


typedef enum logic [2:0] {
    IDLE,
    ROTWORD,
    SUBWORD,
    NEXT_WORD,
    DONE
} state_t;


state_t current_state, next;

logic [3:0]counter_word;
logic [3:0]next_counter_word;
assign rcon_rounds_rom = {
    32'h01000000,32'h02000000,32'h04000000,32'h08000000,32'h10000000,32'h20000000,32'h40000000,32'h80000000,32'h1b000000,32'h36000000

};

logic [31:0] subword, temporary0,temporary1,temporary2;

logic [31:0] xor_stage0;
always_comb rcon_round = rcon_rounds_rom[iteration_current];
assign ut_subbytes_clock = clock;
assign ut_subbytes_nreset = nreset;


assign temporary0 = {<<8{ut_subbytes_input_data[3]}} ;
assign temporary1 = {<<8{ut_subbytes_input_data[3-counter_word-1]}} ;
assign temporary2 = {>>8{key_master_matrix[counter_word]}} ;
always_ff@(posedge clock, negedge nreset)begin
    if(!nreset)begin
        current_state <= IDLE;
        subword <=0;
        counter_word <=0;
        xor_stage0 <= 0;    
        key_master_matrix <= {default:0};
    end else begin
        current_state <= next;
        counter_word <= next_counter_word;
        if(current_state == ROTWORD)begin
            subword <= {subword[23:0],subword[31:24]};
            xor_stage0 <= {subword[23:0],subword[31:24]} ^ rcon_round ^ temporary0;
            // deslocamento com composição de xor's
           {>>{key_master_matrix[0]}} = {subword[23:0],subword[31:24]} ^ rcon_round ^ temporary0; 
        end
        if(current_state == NEXT_WORD)begin
            //{>>{key_master_matrix[counter_word+1]}} <= key_master_matrix[counter_word] ^ temporary0;
            {>>{key_master_matrix[counter_word+1]}} <= temporary1 ^ temporary2;
        end
        if(current_state == DONE)begin
            iteration_next <= iteration_current +1;
        end
       if(current_state == SUBWORD)begin
            subword <= {ut_subbytes_output_data[0][3],ut_subbytes_output_data[0][2],ut_subbytes_output_data[0][1],ut_subbytes_output_data[0][0]};
        end
        
    end
end
always_comb case(current_state)
        IDLE:begin
            ready_o = 1;
            rvalid_o = 0;
            next = ready_o && valid_i ? SUBWORD: IDLE;
            ut_subbytes_valid_i =0;
            ut_subbytes_rready_i =0;
            next_counter_word = 0;
        end
        SUBWORD:begin
            ready_o = 0;
            rvalid_o = 0;
            ut_subbytes_valid_i =1;
            ut_subbytes_rready_i =0;
            next = ut_subbytes_rvalid_o ?  ROTWORD: SUBWORD;
            next_counter_word = 0;

        end
        ROTWORD:begin
            ready_o = 0;
            rvalid_o = 0;
            ut_subbytes_valid_i =0;
            ut_subbytes_rready_i =1;
            next = NEXT_WORD;
            next_counter_word = 0;

        end
        NEXT_WORD:begin
            ready_o = 0;
            rvalid_o = 0;
            ut_subbytes_valid_i =0;
            ut_subbytes_rready_i =0;
            next = counter_word < 2 ? NEXT_WORD: DONE;
            next_counter_word =  counter_word+1;

        end
        DONE:begin
            ready_o = 0;
            rvalid_o = 1;
            next = rvalid_o && rready_i ? IDLE : DONE;
            ut_subbytes_valid_i =0;
            ut_subbytes_rready_i =0;
            next_counter_word = 0;
            
        end
        default:begin
            ready_o = 1;
            rvalid_o = 0;
            next = ready_o && valid_i ? SUBWORD: IDLE;
            ut_subbytes_valid_i =0;
            ut_subbytes_rready_i =0;
            next_counter_word = 0;

        end
endcase
    




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




vec2matrix #(.MATRIX_LEN(4))vex2matrix_unflatten(
    .data_in(key_current),
    .data_out(key_master_matrix0)
);

matrix2vec #(.MATRIX_LEN(4))matrix2vec_flatten1(
    .data_in(key_master_matrix),
    .data_out(key_next)
);
assign ut_subbytes_input_data = key_master_matrix0;
endmodule
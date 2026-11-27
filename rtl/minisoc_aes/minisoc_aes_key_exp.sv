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


logic [7:0]  new_key_matrix [0:3][0:3];
logic [7:0]  old_key_matrix [0:3][0:3];
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


state_t current, next;

logic [3:0]counter_word;
logic [3:0]next_counter_word;
logic [31:0] subword, word_w3_old,word_w_i_old,word_w_i_new;
assign rcon_rounds_rom = {
    32'h01000000,32'h02000000,32'h04000000,32'h08000000,32'h10000000,32'h20000000,32'h40000000,32'h80000000,32'h1b000000,32'h36000000
};
always_ff@(posedge clock, negedge nreset)begin
    if(!nreset)begin
        current <= IDLE;
        subword <=0;
        counter_word <=0;
        new_key_matrix <= {default:0};
        iteration_next <=0;
    end else begin
        current <= next;
        counter_word <= (counter_word ==2) ? 0 : next_counter_word;
        case(current)
            ROTWORD:begin
            // deslocamento com composição de xor's
                {<<8{new_key_matrix[3]}} <= {subword[23:0],subword[31:24]} ^ rcon_round ^ word_w3_old; 
            end
            NEXT_WORD:begin
                {<<8{new_key_matrix[3-(counter_word+1)]}} <= word_w_i_old ^ word_w_i_new;
            end
            DONE:begin
                iteration_next <= iteration_current +1;
            end
            SUBWORD:begin
                //subword <= {ut_subbytes_output_data[0][3],ut_subbytes_output_data[0][2],ut_subbytes_output_data[0][1],ut_subbytes_output_data[0][0]};
                subword<= {<<8{ut_subbytes_output_data[0]}};
            end
        endcase
    end
end
always_comb case(current)
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
            next = counter_word < 2? NEXT_WORD: DONE;
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
    .data_out(old_key_matrix)
);

matrix2vec #(.MATRIX_LEN(4))matrix2vec_flatten1(
    .data_in(new_key_matrix),
    .data_out(key_next)
);
assign ut_subbytes_input_data = old_key_matrix;
assign ut_subbytes_clock = clock;
assign ut_subbytes_nreset = nreset;
assign word_w3_old = {<<8{ut_subbytes_input_data[3]}} ;
assign word_w_i_old = {<<8{ut_subbytes_input_data[3-counter_word-1]}} ;
assign word_w_i_new = {<<8{new_key_matrix[3-counter_word]}} ;
always_comb rcon_round = rcon_rounds_rom[iteration_current];


endmodule
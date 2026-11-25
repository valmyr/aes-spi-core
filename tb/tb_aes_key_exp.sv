module tb;
logic clock,nreset;
logic [127:0] data;
logic [127:0] key;

//
//logic          ut_aes_key_exp_clock;
//logic          ut_aes_key_exp_nreset;
//logic [127:0]  ut_aes_key_exp_key_current;
//logic [7:0]    ut_aes_key_exp_iteration_current;
//logic [7:0]    ut_aes_key_exp_iteration_next;
//logic [127:0]  ut_aes_key_exp_key_next;
//logic          ut_aes_key_exp_valid_i;
//logic          ut_aes_key_exp_ready_o;
//logic          ut_aes_key_exp_rvalid_o;
//logic          ut_aes_key_exp_rready_i;


logic          ut_aes_key_exp_clock;
logic          ut_aes_key_exp_nreset;


logic [127:0]  ut_aes_key_exp_key_current[11];
logic [7:0]    ut_aes_key_exp_iteration_current[11];
logic [7:0]    ut_aes_key_exp_iteration_next[11];
logic [127:0]  ut_aes_key_exp_key_next[11];
logic          ut_aes_key_exp_valid_i[11];
logic          ut_aes_key_exp_ready_o[11];
logic          ut_aes_key_exp_rvalid_o[11];
logic          ut_aes_key_exp_rready_i[11];

assign ut_aes_key_exp_iteration_next[0] = 0;
assign ut_aes_key_exp_key_current[0] = 128'h000102030405060708090a0b0c0d0e0f;
assign ut_aes_key_exp_valid_i[0] = 1 ;
assign ut_aes_key_exp_rvalid_o[0] =1;
assign ut_aes_key_exp_key_next[0] = 0;
generate;
    genvar i;

    for(i = 1; i < 11; i++)begin
        aes_key_exp ut_aes_key_exp0(
            .clock(ut_aes_key_exp_clock),
            .nreset(ut_aes_key_exp_nreset),
            .key_current(ut_aes_key_exp_key_current[i-1]),
            .iteration_current(ut_aes_key_exp_iteration_next[i-1]),
            .iteration_next(ut_aes_key_exp_iteration_next[i]),
            .key_next(ut_aes_key_exp_key_current[i]),
            .valid_i(ut_aes_key_exp_rvalid_o[i-1]),
            .ready_o(),
            .rvalid_o(ut_aes_key_exp_rvalid_o[i]),
            .rready_i(0)
        );
      assign ut_aes_key_exp_key_next[i] = ut_aes_key_exp_key_current[i-1];
    end
endgenerate



assign ut_aes_key_exp_clock = clock;
assign ut_aes_key_exp_nreset = nreset;
initial begin 
	// Basic: dump all signals from tb_top downward, all hierarchy
    $fsdbDumpfile("waves.fsdb");
    // Dump multi-dimensional arrays (memories, packed arrays)
    $fsdbDumpMDA();
    $fsdbDumpvars(0, tb);         // 0 = all levels of hierarchy
    

	clock = 0;
	nreset =1;
	#1
	nreset = 0;
	#1
	nreset=1;


	#(320);
    $fsdbDumpoff;
    $finish;

end

//assign ut_aes_key_exp_key_current = key;
//assign ut_aes_key_exp_iteration_current = 0;
assign data=128'h00112233445566778899aabbccddeeff;
assign key =128'h000102030405060708090a0b0c0d0e0f;
//assign key =128'h2b7e151628aed2a6abf7158809cf4f3c;
//


always #1 clock = ~clock;

endmodule

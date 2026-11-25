module tb;
logic clock,nreset;
logic [127:0] data;
logic [127:0] key;


logic          ut_aes_key_exp_clock;
logic          ut_aes_key_exp_nreset;
logic [127:0]  ut_aes_key_exp_key_current;
logic [7:0]    ut_aes_key_exp_iteration_current;
logic [7:0]    ut_aes_key_exp_iteration_next;
logic [127:0]  ut_aes_key_exp_key_next;
logic          ut_aes_key_exp_valid_i;
logic          ut_aes_key_exp_ready_o;
logic          ut_aes_key_exp_rvalid_o;
logic          ut_aes_key_exp_rready_i;


aes_key_exp ut_aes_key_exp(
    .clock(ut_aes_key_exp_clock),
    .nreset(ut_aes_key_exp_nreset),
    .key_current(ut_aes_key_exp_key_current),
    .iteration_current(ut_aes_key_exp_iteration_current),
    .iteration_next(ut_aes_key_exp_iteration_next),
    .key_next(ut_aes_key_exp_key_next),
    .valid_i(ut_aes_key_exp_valid_i),
    .ready_o(ut_aes_key_exp_ready_o),
    .rvalid_o(ut_aes_key_exp_rvalid_o),
    .rready_i(ut_aes_key_exp_rready_i)
);

assign ut_aes_key_exp_valid_i = 1;
assign ut_aes_key_exp_clock = clock;
assign ut_aes_key_exp_nreset = nreset;
assign ut_aes_key_exp_rready_i = 0;
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


	#(180);
    $fsdbDumpoff;
    $finish;

end

assign ut_aes_key_exp_key_current = key;
assign ut_aes_key_exp_iteration_current = 0;
assign data=128'h00112233445566778899aabbccddeeff;
assign key =128'h2b7e151628aed2a6abf7158809cf4f3c;
always #1 clock = ~clock;

endmodule

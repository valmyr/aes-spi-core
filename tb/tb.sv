module tb;
logic clock,nreset;
logic [127:0] data;
logic [127:0] key;


logic [127:0] tb_aes_core_data_input;
logic [127:0] tb_aes_core_key_input;
logic [127:0] tb_aes_core_data_output;
logic         tb_aes_core_valid_i;
logic         tb_aes_core_ready_o ;
logic         tb_aes_core_rvalid_o;
logic         tb_aes_core_rready_i;

aes_core uut_aes_core(
    .clock(clock),
    .nreset(nreset),
    .aes_core_data_input(tb_aes_core_data_input),
    .aes_core_key_input(tb_aes_core_key_input),
    .aes_core_data_output(tb_aes_core_valid_i),
    .aes_core_valid_i(tb_aes_core_valid_i),
    .aes_core_ready_o(tb_aes_core_ready_o),
    .aes_core_rvalid_o(tb_aes_core_rvalid_o),
    .aes_core_rready_i(tb_aes_core_rready_i)
);







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
assign tb_aes_core_data_input=128'h00112233445566778899aabbccddeeff;
assign tb_aes_core_key_input =128'h000102030405060708090a0b0c0d0e0f;
always #1 clock = ~clock;

endmodule

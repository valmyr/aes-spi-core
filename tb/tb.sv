module tb;
logic clock,nreset;
logic [127:0] data;
logic [127:0] key;


aes_core uut_aes_core(
    .clock(clock),
    .nreset(nreset),
    .data_input(data),
    .ut_addroundkey_key(key),
    .data_output_subbytes(),
    .data_output_shiftrows()
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
assign data=128'h00112233445566778899aabbccddeeff;
assign key =128'h000102030405060708090a0b0c0d0e0f;
always #1 clock = ~clock;

endmodule

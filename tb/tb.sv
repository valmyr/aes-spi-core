module tb;
logic clock,nreset;
logic [127:0] data;
aes_core uut_aes_core(
    .clock(clock),
    .nreset(nreset),
    .data_input(data),
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
assign data =128'h193de3bea0f4e22b9ac68d2ae9f84808;

always #1 clock = ~clock;

endmodule

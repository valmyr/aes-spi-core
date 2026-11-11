module tb;
logic clock,nreset;
logic [127:0] data;
logic [7:0]x_data[4];
logic [7:0]y_data[4];
logic [7:0]c_data[4-1:0];
mixcolumns #(.STAGES_XTIMES_SERIAL(8),.STAGES_XTIMES_PARALLEL(4)) mixcolumns_uut(
    .clock(clock),
    .nreset(nreset),
    .ena(1'b1),
    .x_data(x_data),
    .y_data(y_data)
);

initial begin 
	// Basic: dump all signals from tb_top downward, all hierarchy
    $fsdbDumpfile("waves.fsdb");
    // Dump multi-dimensional arrays (memories, packed arrays)
    $fsdbDumpMDA();
    $fsdbDumpvars(0, tb);         // 0 = all levels of hierarchy
    x_data[0] = 8'h57;
    x_data[1] = 8'h10;
    x_data[2] = 8'h42;
    x_data[3] = 8'h99;
    y_data[0] = 8'h13;
    y_data[1] = 8'h1;
    y_data[2] = 8'h2;
    y_data[3] = 8'h3;

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

module tb;
logic clock,nreset;
logic [127:0] data;
logic [7:0]x_data[0:3][0:3];
logic [7:0]y_data[0:3][0:3];
logic [7:0]c_data[0:3][0:3];
logic ena;

mixcolumns#(.STAGES_XTIMES_SERIAL(8),.STAGES_XTIMES_PARALLEL(4)) mixcolumns_uut(
    .clock(clock),
    .nreset(nreset),
    .ena(ena),
    .gf_input_data(x_data),
    .op_input_data(y_data), 
    .fg_output_data(c_data)
);
initial begin 
	// Basic: dump all signals from tb_top downward, all hierarchy
    $fsdbDumpfile("waves.fsdb");
    // Dump multi-dimensional arrays (memories, packed arrays)
    $fsdbDumpMDA();
    $fsdbDumpvars(0, tb);         // 0 = all levels of hierarchy
    x_data[0][0] = 8'h63;
    x_data[1][0] = 8'heb;
    x_data[2][0] = 8'h9f;
    x_data[3][0] = 8'ha0;
    x_data[0][1] = 8'h2f;
    x_data[1][1] = 8'h93;
    x_data[2][1] = 8'h92;
    x_data[3][1] = 8'hc0;
    x_data[0][2] = 8'haf;
    x_data[1][2] = 8'hc7;
    x_data[2][2] = 8'hab;
    x_data[3][2] = 8'h30;
    x_data[0][3] = 8'ha2;
    x_data[1][3] = 8'h20;
    x_data[2][3] = 8'hcb;
    x_data[3][3] = 8'h2b;

    y_data[0][0] = 8'h2;
    y_data[0][1] = 8'h3;
    y_data[0][2] = 8'h1;
    y_data[0][3] = 8'h1;
    y_data[1][0] = 8'h1;
    y_data[1][1] = 8'h2;
    y_data[1][2] = 8'h3;
    y_data[1][3] = 8'h1;
    y_data[2][0] = 8'h1;
    y_data[2][1] = 8'h1;
    y_data[2][2] = 8'h2;
    y_data[2][3] = 8'h3;
    y_data[3][0] = 8'h3;
    y_data[3][1] = 8'h1;
    y_data[3][2] = 8'h1;
    y_data[3][3] = 8'h2;


	clock = 0;
	nreset =1;
    ena   =0;
    #(1)
	nreset = 0;
	#(1)
	nreset=1;
    ena = 1;


	#(180);
    $fsdbDumpoff;
    $finish;

end
assign data =128'h193de3bea0f4e22b9ac68d2ae9f84808;

always #4 clock = ~clock;

endmodule

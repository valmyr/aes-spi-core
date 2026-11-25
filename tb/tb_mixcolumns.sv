module tb;

parameter BYTE = 8;
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
    //6353e08c0960e104cd70b751bacad0e7
    $fsdbDumpMDA();
    $fsdbDumpvars(0, tb);         // 0 = all levels of hierarchy
    x_data[3][3] = data[ 1*BYTE-1: 0*BYTE];
    x_data[2][3] = data[ 2*BYTE-1: 1*BYTE];
    x_data[1][3] = data[ 3*BYTE-1: 2*BYTE];
    x_data[0][3] = data[ 4*BYTE-1: 3*BYTE];
    x_data[3][2] = data[ 5*BYTE-1: 4*BYTE];
    x_data[2][2] = data[ 6*BYTE-1: 5*BYTE];
    x_data[1][2] = data[ 7*BYTE-1: 6*BYTE];
    x_data[0][2] = data[ 8*BYTE-1: 7*BYTE];
    x_data[3][1] = data[ 9*BYTE-1: 8*BYTE];
    x_data[2][1] = data[10*BYTE-1: 9*BYTE];
    x_data[1][1] = data[11*BYTE-1:10*BYTE];
    x_data[0][1] = data[12*BYTE-1:11*BYTE];
    x_data[3][0] = data[13*BYTE-1:12*BYTE];
    x_data[2][0] = data[14*BYTE-1:13*BYTE];
    x_data[1][0] = data[15*BYTE-1:14*BYTE];
    x_data[0][0] = data[16*BYTE-1:15*BYTE];



    //x_data[0][3] = data[ 1*BYTE-1: 0*BYTE];
    //x_data[0][2] = data[ 2*BYTE-1: 1*BYTE];
    //x_data[0][1] = data[ 3*BYTE-1: 2*BYTE];
    //x_data[0][0] = data[ 4*BYTE-1: 3*BYTE];
    //x_data[1][3] = data[ 5*BYTE-1: 4*BYTE];
    //x_data[1][2] = data[ 6*BYTE-1: 5*BYTE];
    //x_data[1][1] = data[ 7*BYTE-1: 6*BYTE];
    //x_data[1][0] = data[ 8*BYTE-1: 7*BYTE];
    //x_data[2][3] = data[ 9*BYTE-1: 8*BYTE];
    //x_data[2][2] = data[10*BYTE-1: 9*BYTE];
    //x_data[2][1] = data[11*BYTE-1:10*BYTE];
    //x_data[2][0] = data[12*BYTE-1:11*BYTE];
    //x_data[3][3] = data[13*BYTE-1:12*BYTE];
    //x_data[3][2] = data[14*BYTE-1:13*BYTE];
    //x_data[3][1] = data[15*BYTE-1:14*BYTE];
    //x_data[3][0] = data[16*BYTE-1:15*BYTE];

    //x_data[0][0] = data[ 1*BYTE-1: 0*BYTE];
    //x_data[0][1] = data[ 2*BYTE-1: 1*BYTE];
    //x_data[0][2] = data[ 3*BYTE-1: 2*BYTE];
    //x_data[0][3] = data[ 4*BYTE-1: 3*BYTE];
    //x_data[1][0] = data[ 5*BYTE-1: 4*BYTE];
    //x_data[1][1] = data[ 6*BYTE-1: 5*BYTE];
    //x_data[1][2] = data[ 7*BYTE-1: 6*BYTE];
    //x_data[1][3] = data[ 8*BYTE-1: 7*BYTE];
    //x_data[2][0] = data[ 9*BYTE-1: 8*BYTE];
    //x_data[2][1] = data[10*BYTE-1: 9*BYTE];
    //x_data[2][2] = data[11*BYTE-1:10*BYTE];
    //x_data[2][3] = data[12*BYTE-1:11*BYTE];
    //x_data[3][0] = data[13*BYTE-1:12*BYTE];
    //x_data[3][1] = data[14*BYTE-1:13*BYTE];
    //x_data[3][2] = data[15*BYTE-1:14*BYTE];
    //x_data[3][3] = data[16*BYTE-1:15*BYTE];

    //x_data[0][0] = 8'h63;
    //x_data[1][0] = 8'heb;
    //x_data[2][0] = 8'h9f;
    //x_data[3][0] = 8'ha0;
    //x_data[0][1] = 8'h2f;
    //x_data[1][1] = 8'h93;
    //x_data[2][1] = 8'h92;
    //x_data[3][1] = 8'hc0;
    //x_data[0][2] = 8'haf;
    //x_data[1][2] = 8'hc7;
    //x_data[2][2] = 8'hab;
    //x_data[3][2] = 8'h30;
    //x_data[0][3] = 8'ha2;
    //x_data[1][3] = 8'h20;
    //x_data[2][3] = 8'hcb;
    //x_data[3][3] = 8'h2b;


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
assign data =128'h6353e08c0960e104cd70b751bacad0e7;

always #4 clock = ~clock;

endmodule

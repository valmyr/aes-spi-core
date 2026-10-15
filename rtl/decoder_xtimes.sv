module decoder_xtimes#(parameter STAGES_XTIMES = 1)(
    input logic  [7:0] y,
    input  logic [7:0] x[STAGES_XTIMES-1:0],
    output logic [7:0] z
);
assign z          = ({8{y[0]}} & x[0]) ^
                    ({8{y[1]}} & x[1]) ^
                    ({8{y[2]}} & x[2]) ^
                    ({8{y[3]}} & x[3]) ^
                    ({8{y[4]}} & x[4]) ^
                    ({8{y[5]}} & x[5]);
endmodule
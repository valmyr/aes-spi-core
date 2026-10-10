module somador(
	input  logic clock,
	input  logic signed [31:0] a,
	input  logic signed [31:0] b,
	output logic signed [31:0] c,
	input  logic ena
);
always_ff@(posedge clock)begin
	if(ena) c <= a+b;
	else c <=0;
end
endmodule

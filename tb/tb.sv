module tb;

logic signed [31:0] a;
logic signed [31:0] b;
logic signed [31:0] c;
logic ena;
logic [31:0] counter;
logic clock;
logic [31:0] ref_result;
somador u_somador(
	.ena(ena),
	.a(a),
	.b(b),
	.c(c),
	.clock(clock)
);

initial begin 
	clock = 0;
	ena =1;
end

always clock = ~clock;

always_ff@(posedge clock)begin
	a <= $random();
	b <= $random();
	ref_result <= a + b;
	if(ref_result == c)
		$display("Pass");
	else
		$display("Fail %d + %d = %d, %d",a,b,ref_result,c);

end
endmodule

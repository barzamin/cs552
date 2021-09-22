module fulladder1_tb;

reg A, B, Cin;
reg [1:0] goldsum;
wire S, Cout;

fulladder1 adder(.A(A), .B(B), .Cin(Cin), .Cout(Cout), .S(S));

wire clk, rst, err;
clkrst clkrst1 (.clk(clk), .rst(rst), .err(err));


initial begin
	A = 0; B = 0; Cin = 0;
	#3200 $finish();
end

always @(posedge clk) begin
	A = $random;
	B = $random;
	Cin = $random;
end

always @(negedge clk) begin
	goldsum = A + B + Cin;
	//$display("A: %d, B: %d, Cin: %d, S: %d", A, B, Cin, goldsum);
	//$display("real: S: %d, Cout: %d", S, Cout);
	if (goldsum[0] !== S)    $display ("ERRORCHECK sum error");
	if (goldsum[1] !== Cout) $display ("ERRORCHECK Cout error");
end


endmodule

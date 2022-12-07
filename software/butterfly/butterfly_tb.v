module butterfly_tb();

	reg signed [15:0] A, B, C, D;
	reg signed [7:0]  W;
	wire signed [15:0]  out1, out2, out3, out4;


	butterfly b0(
		.A(A), .B(B), .C(C), .D(D), .W(W), .out1(out1), .out2(out2), .out3(out3), .out4(out4)
	);


	


endmodule
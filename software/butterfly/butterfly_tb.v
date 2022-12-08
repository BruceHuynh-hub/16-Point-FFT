module butterfly_tb();

	reg signed  [15:0] Ar, Br, Cr, Dr,
	reg signed  [15:0] Ai, Bi, Ci, Di,
	wire signed [15:0] out0r, out1r, out2r, out3r,
	wire signed [15:0] out0i, out1i, out2i, out3i


	butterfly but0 (.Ar(Ar), .Ai(Ai), .Br(Br), .Bi(Bi), .Cr(Cr), .Ci(Ci), Dr(Dr), Di(Di),
	.out0r(out0r), .out0i(out0i), .out1r(out1r), .out1i(out1i), .out2r(out2r), .out2i(out2i), .out3r(out3r), .out3i(out3i));





endmodule
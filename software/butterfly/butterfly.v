module butterfly (
	input signed  [15:0] Ar, Br, Cr, Dr,
	input signed  [15:0] Ai, Bi, Ci, Di,
	output signed [15:0] out0r, out1r, out2r, out3r,
	output signed [15:0] out0i, out1i, out2i, out3i
);

	// define parameters for twiddle factor here

	parameter [15:0] W0r = ;
	parameter [15:0] W0i = ;
	parameter [15:0] W1r = ;
	parameter [15:0] W1i = ;
	parameter [15:0] W2r = ;
	parameter [15:0] W2i = ;
	parameter [15:0] W3r = ;
	parameter [15:0] W3i = ;

	/*
	assign out1r = Ar + Br + Cr + Dr;
	assign out1i = Ai + Bi + Ci + Di;

	assign out2r = Ar + Bi - Cr - Di;
	assign out2i = Ai - Br - Ci + Dr;

	assign out3r = Ar - Br + Cr - Dr;
	assign out3i = Ai - Bi + Ci - Di;

	assign out4r = Ar - Bi - Cr + Di;
	assign out4i = Ai + Br - Ci - Dr;

	*/


endmodule 
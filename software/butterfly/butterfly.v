module butterfly (
	input signed [15:0] Ar, Br, Cr, Dr,
	input signed [15:0] Ai, Bi, Ci, Di,
	output signed[15:0] out1r, out2r, out3r, out4r,
	output signed[15:0] out1i, out2i, out3i, out4i
);

	// define parameters for twiddle factor here


	assign out1r = Ar + Br + Cr + Dr;
	assign out1i = Ai + Bi + Ci + Di;

	assign out2r = Ar + Bi - Cr - Di;
	assign out2i = Ai - Br - Ci + Dr;

	assign out3r = Ar - Br + Cr - Dr;
	assign out3i = Ai - Bi + Ci - Di;

	assign out4r = Ar - Bi - Cr + Di;
	assign out4i = Ai + Br - Ci - Dr;


endmodule 
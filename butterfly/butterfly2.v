module butterfly (
	input signed  [15:0] Ar, Br, Cr, Dr,
	input signed  [15:0] Ai, Bi, Ci, Di,


	output signed [15:0] out0r, out1r, out2r, out3r,
	output signed [15:0] out0i, out1i, out2i, out3i

);
 
	assign out0r = Ar + Br + Cr + Dr;
	assign out0i = Ai + Bi + Ci + Di;

	assign out1r = Ar + Bi - Cr - Di;
	assign out1i = Ai - Br - Ci + Dr;

	assign out2r = Ar - Br + Cr - Dr;
	assign out2i = Ai - Bi + Ci - Di;

	assign out3r = Ar - Bi - Cr + Di;
	assign out3i = Ai + Br - Ci - Dr;

endmodule 
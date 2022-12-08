module butterfly2 (
	input signed  [15:0] din0_Ar, din0_Br, din0_Cr, din0_Dr;
	input signed  [15:0] din0_Ai, din0_Bi, din0_Ci, din0_Di,

	input signed  [15:0] din1_Ar, din1_Br, din1_Cr, din1_Dr;
	input signed  [15:0] din1_Ai, din1_Bi, din1_Ci, din1_Di,

	input signed  [15:0] din2_Ar, din2_Br, din2_Cr, din2_Dr;
	input signed  [15:0] din2_Ai, din2_Bi, din2_Ci, din2_Di,

	input signed  [15:0] din3_Ar, din3_Br, din3_Cr, din3_Dr;
	input signed  [15:0] din3_Ai, din3_Bi, din3_Ci, din3_Di,

	output signed [15:0] out0r, out1r, out2r, out3r,

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
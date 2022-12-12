module butterfly (
	input signed  [15:0] Ar, Br, Cr, Dr,
	input signed  [15:0] Ai, Bi, Ci, Di,
	output signed [15:0] out0r, out1r, out2r, out3r,
	output signed [15:0] out0i, out1i, out2i, out3i
);

	// define parameters for twiddle factor here


	parameter W0r = 16'b01_00000000000000; // real(W) = 1.000000000000, imag(W) = 0.000000000000
	parameter W0i = 16'b0;
	parameter W1r = 16'b00_11101100100000; // real(W) = 0.923879532511, imag(W) = -0.382683432365  
	parameter W1i = 16'b11_10011110000010; 
	parameter W2r = 16'b00_10110101000001; // real(W) = 0.707106781187, imag(W) = -0.707106781187
	parameter W2i = 16'b11_01001010111111;  
	parameter W3r = 16'b00_01100001111101; // real(W) = 0.382683432365, imag(W) = -0.923879532511
	parameter W3i = 16'b11_00010011011111;  
	parameter W4r = 16'b00_00000000000000; // real(W) = 0.000000000000, imag(W) = -1.000000000000
	parameter W4i = 16'b10_00000000000000;
	parameter W5r = 16'b11_10011110000010; // real(W) = -0.382683432365, imag(W) = -0.923879532511
	parameter W5i = 16'b11_00010011011111;    
	parameter W6r = 16'b11_01001010111111; // real(W) = -0.707106781187, imag(W) = -0.707106781187
	parameter W6i = 16'b11_01001010111111;  
	parameter W7r = 16'b11_00010011011111; // real(W) = -0.923879532511, imag(W) = -0.382683432365
	parameter W7i = 16'b11_10011110000010; 
	parameter W8r = 16'b10_00000000000000; // real(W) = -1.000000000000, imag(W) = -0.000000000000
	parameter W8i = 16'b00_00000000000000;  
	parameter W9r = 16'b11_00010011011111; // real(W) = -0.923879532511, imag(W) = 0.382683432365
	parameter W9i = 16'b00_01100001111101;  

	wire signed [15:0] W1P1r, W1P1i, W2P2r, W2P2i, W3P3r, W3P3i;
	wire signed [15:0] WrWi1P, WrWi2P, WrWi3P, WrWi1S, WrWi2S, WrWi3S; 
	wire signed [15:0] PrPi1P, PrPi2P, PrPi3P, PrPi1S, PrPi2S, PrPi3S; 
	wire signed [15:0] PrW1, WiP1, PiW1, PrW2, WiP2, PiW2, PrW3, WiP3, PiW3;

	assign WrWi1P = W1r + W1i;  // W values used may be wrong, change later if needed
	assign WrWi1S = W1r - W1i;
	assign WrWi2P = W2r + W2i;
	assign WrWi2S = W2r - W2i;
	assign WrWi3P = W3r + W3i;
	assign WrWi3S = W3r - W3i;

	assign PrPi1P = Br + Bi;
	assign PrPi1S = Br - Bi;
	assign PrPi2P = Cr + Ci;
	assign PrPi2S = Cr - Ci;
	assign PrPi3P = Dr + Di;
	assign PrPi3S = Dr - Di;

	signed_multiplier sm0 (Br, WrWi1P, PrW1);
	signed_multiplier sm1 (PrPi1P, W1i, WiP1);
	signed_multiplier sm2 (Bi, WrWi1S, PiW1);
	assign W1P1r = PrW1 - WiP1;
	assign W1P1i = PiW1 + WiP1;

	signed_multiplier sm3 (Cr, WrWi2P, PrW2);
	signed_multiplier sm4 (PrPi2P, W2i, WiP2);
	signed_multiplier sm5 (Ci, WrWi2S, PiW2);
	assign W2P2r = PrW2 - WiP2;
	assign W2P2i = PiW2 + WiP2;

	signed_multiplier sm6 (Dr, WrWi3P, PrW3);
	signed_multiplier sm7 (PrPi3P, W3i, WiP3);
	signed_multiplier sm8 (Di, WrWi3S, PiW3);
	assign W3P3r = PrW3 - WiP3;
	assign W3P3i = PiW3 + WiP3;


	assign out0r = Ar + W1P1r + W2P2r + W3P3r;
	assign out0i = Ai + W1P1i + W2P2i + W3P3i;
	assign out1r = Ar + W1P1i - W2P2r - W3P3i;
	assign out1i = Ai - W1P1r - W2P2i + W3P3r;
	assign out2r = Ar - W1P1r + W2P2r - W3P3r;
	assign out2i = Ai - W1P1i + W2P2i - W3P3i;
	assign out3r = Ar - W1P1i - W2P2r + W3P3i;
	assign out3i = Ai + W1P1r - W2P2i - W3P3r;

endmodule 
module twiddle (
	input [15:0] din_r0, din_r1, din_r2, din_r3, din_r4, din_r5, din_r6, din_r7, din_r8, din_r9, din_r10, din_r11, din_r12, din_r13, din_r14, din_r15,
	input [15:0] din_i0, din_i1, din_i2, din_i3, din_i4, din_i5, din_i6, din_i7, din_i8, din_i9, din_i10, din_i11, din_i12, din_i13, din_i14, din_i15,

	output [15:0] dout_r0, dout_r1, dout_r2, dout_r3, dout_r4, dout_r5, dout_r6, dout_r7, dout_r8, dout_r9, dout_r10, dout_r11, dout_r12, dout_r13, dout_r14, dout_r15,
	output [15:0] dout_i0, dout_i1, dout_i2, dout_i3, dout_i4, dout_i5, dout_i6, dout_i7, dout_i8, dout_i9, dout_i10, dout_i11, dout_i12, dout_i13, dout_i14, dout_i15

);

	parameter W0r = 16'b01_00000000000000; // real(W) = 1.000000000000, imag(W) = 0.000000000000
	parameter W0i = 16'b0;
	parameter W1r = 16'b00_11101100100000; // real(W) = 0.923879532511, imag(W) = -0.382683432365  
	parameter W1i = 16'b11_10011110000010; 
	parameter W2r = 16'b00_10110101000001; // real(W) = 0.707106781187, imag(W) = -0.707106781187
	parameter W2i = 16'b11_01001010111111;  
	parameter W3r = 16'b00_01100001111101; // real(W) = 0.382683432365, imag(W) = -0.923879532511
	parameter W3i = 16'b11_00010011011111;  
	parameter W4r = 16'b00_00000000000000; // real(W) = 0.000000000000, imag(W) = -1.000000000000
	parameter W4i = 16'b11_00000000000000;
	parameter W5r = 16'b11_10011110000010; // real(W) = -0.382683432365, imag(W) = -0.923879532511
	parameter W5i = 16'b11_00010011011111;    
	parameter W6r = 16'b11_01001010111111; // real(W) = -0.707106781187, imag(W) = -0.707106781187
	parameter W6i = 16'b11_01001010111111;  
	parameter W7r = 16'b11_00010011011111; // real(W) = -0.923879532511, imag(W) = -0.382683432365
	parameter W7i = 16'b11_10011110000010; 
	parameter W8r = 16'b11_00000000000000; // real(W) = -1.000000000000, imag(W) = -0.000000000000
	parameter W8i = 16'b00_00000000000000;  
	parameter W9r = 16'b11_00010011011111; // real(W) = -0.923879532511, imag(W) = 0.382683432365
	parameter W9i = 16'b00_01100001111101;





	// dout[3:0]
	assign dout_r0 = din_r0;
	assign dout_i0 = din_i0;
	assign dout_r1 = din_r1;
	assign dout_i1 = din_i1;
	assign dout_r2 = din_r2;
	assign dout_i2 = din_i2;
	assign dout_r3 = din_r3;
	assign dout_i3 = din_i3;

	// dout[7:4]
	wire [15:0] din_5rW1r, din_5rW1i, din_5iW1r, din_5iW1i;
	wire [15:0] din_6rW2r, din_6iW2r;
	wire [15:0] din_7rW3r, din_7rW3i, din_7iW3r, din_7iW3i;

	assign dout_r4 = din_r4;
	assign dout_i4 = din_i4;

	signed_multiplier sm_5rW1r(.din(din_r5), .W(W1r), .dout(din_5rW1r));
	signed_multiplier sm_5rW1i(.din(din_r5), .W(W1i), .dout(din_5rW1i));
	signed_multiplier sm_5iW1r(.din(din_i5), .W(W1r), .dout(din_5iW1r));
	signed_multiplier sm_5iW1i(.din(din_i5), .W(W1i), .dout(din_5iW1i));
	assign dout_r5 = din_5rW1r - din_5iW1i;
	assign dout_i5 = din_5rW1i + din_5iW1r;

	signed_multiplier sm_6r_ADD_iW2r(.din(din_r6 + din_i6), .W(W2r), .dout(din_6rW2r));
	signed_multiplier sm_6i_SUB_rW2r(.din(din_i6 - din_r6), .W(W2r), .dout(din_6iW2r));
	assign dout_r6 = din_6rW2r;
	assign dout_i6 = din_6iW2r;

	signed_multiplier sm_7rW3r(.din(din_r7), .W(W3r), .dout(din_7rW3r));
	signed_multiplier sm_7rW3i(.din(din_r7), .W(W3i), .dout(din_7rW3i));
	signed_multiplier sm_7iW3r(.din(din_i7), .W(W3r), .dout(din_7iW3r));
	signed_multiplier sm_7iW3i(.din(din_i7), .W(W3i), .dout(din_7iW3i));
	assign dout_r7 = din_7rW3r - din_7iW3i;
	assign dout_i7 = din_7rW3i + din_7iW3r;

	// dout[11:8]
	wire [15:0] din_9rW2r, din_9iW2r;
	wire [15:0] din_11rW6r, din_11iW6r;
	assign dout_r8 = din_r8;
	assign dout_i8 = din_i8;

	signed_multiplier sm_9r_ADD_iW2r(.din(din_r9 + din_i9), .W(W2r), .dout(din_9rW2r));
	signed_multiplier sm_9i_SUB_rW2r(.din(din_i9 - din_r9), .W(W2r), .dout(din_9iW2r));
	assign dout_r9 = din_9rW2r;
	assign dout_i9 = din_9iW2r;

	assign dout_r10 = ~din_r10 + 1'b1;
	assign dout_i10 = ~din_i10 + 1'b1;

	signed_multiplier sm_11r_SUB_iW6r(.din(din_r11 - din_i11), .W(W6r), .dout(din_11rW6r));
	signed_multiplier sm_11i_ADD_rW6r(.din(din_i11 + din_r11), .W(W6r), .dout(din_11iW6r));
	assign dout_r11 = din_11rW6r;
	assign dout_i11 = din_11iW6r;

	// dout[15:12]
	wire [15:0] din_13rW3r, din_13rW3i, din_13iW3r, din_13iW3i;
	wire [15:0] din_14rW6r, din_14iW6r;
	wire [15:0] din_15rW9r, din_15rW9i, din_15iW9r, din_15iW9i;

	assign dout_r12 = din_r12;
	assign dout_i12 = din_i12;

	signed_multiplier sm_13rW3r(.din(din_r13), .W(W3r), .dout(din_13rW3r));
	signed_multiplier sm_13rW3i(.din(din_r13), .W(W3i), .dout(din_13rW3i));
	signed_multiplier sm_13iW3r(.din(din_i13), .W(W3r), .dout(din_13iW3r));
	signed_multiplier sm_13iW3i(.din(din_i13), .W(W3i), .dout(din_13iW3i));
	assign dout_r13 = din_13rW3r - din_13iW3i;
	assign dout_i13 = din_13rW3i + din_13iW3r;

	signed_multiplier sm_14r_SUB_iW6r(.din(din_r14 - din_i14), .W(W6r), .dout(din_14rW6r));
	signed_multiplier sm_14i_ADD_rW6r(.din(din_i14 + din_r14), .W(W6r), .dout(din_14iW6r));
	assign dout_r14 = din_14rW6r;
	assign dout_i14 = din_14iW6r;	

	signed_multiplier sm_15rW9r(.din(din_r15), .W(W9r), .dout(din_15rW9r));
	signed_multiplier sm_15rW9i(.din(din_r15), .W(W9i), .dout(din_15rW9i));
	signed_multiplier sm_15iW9r(.din(din_i15), .W(W9r), .dout(din_15iW9r));
	signed_multiplier sm_15iW9i(.din(din_i15), .W(W9i), .dout(din_15iW9i));
	assign dout_r15 = din_15rW9r - din_15iW9i;
	assign dout_i15 = din_15rW9i + din_15iW9r;



endmodule
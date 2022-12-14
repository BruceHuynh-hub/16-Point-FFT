module FFT (

	input  [13:0] per_addr,  // address bus  

	input signed [15:0] din0_Ar, din0_Br, din0_Cr, din0_Dr,   // data input
	input signed [15:0] din0_Ai, din0_Bi, din0_Ci, din0_Di,

	input signed [15:0] din1_Ar, din1_Br, din1_Cr, din1_Dr,   // data input
	input signed [15:0] din1_Ai, din1_Bi, din1_Ci, din1_Di,

	input signed [15:0] din2_Ar, din2_Br, din2_Cr, din2_Dr,   // data input
	input signed [15:0] din2_Ai, din2_Bi, din2_Ci, din2_Di,

	input signed [15:0] din3_Ar, din3_Br, din3_Cr, din3_Dr,   // data input
	input signed [15:0] din3_Ai, din3_Bi, din3_Ci, din3_Di,


	input         mclk,      // system clock
	input         per_en,    // active bus cycle enable
	input [1:0]   per_we,    // write control
	input         puc_rst,    // power-up clear reset
	output [15:0] per_dout  // data output
	);

	reg [15:0] 		    dmux;
	

	// butterfly outputs

	wire signed [15:0] but0_Ar, but0_Br, but0_Cr, but0_Dr;
	wire signed [15:0] but0_Ai, but0_Bi, but0_Ci, but0_Di;

	wire signed [15:0] but1_Ar, but1_Br, but1_Cr, but1_Dr;
	wire signed [15:0] but1_Ai, but1_Bi, but1_Ci, but1_Di;

	wire signed [15:0] but2_Ar, but2_Br, but2_Cr, but2_Dr;
	wire signed [15:0] but2_Ai, but2_Bi, but2_Ci, but2_Di;

	wire signed [15:0] but3_Ar, but3_Br, but3_Cr, but3_Dr;
	wire signed [15:0] but3_Ai, but3_Bi, but3_Ci, but3_Di;

	reg signed [15:0] but0_Ar_n, but0_Br_n, but0_Cr_n, but0_Dr_n;
	reg signed [15:0] but0_Ai_n, but0_Bi_n, but0_Ci_n, but0_Di_n;

	reg signed [15:0] but1_Ar_n, but1_Br_n, but1_Cr_n, but1_Dr_n;
	reg signed [15:0] but1_Ai_n, but1_Bi_n, but1_Ci_n, but1_Di_n;

	reg signed [15:0] but2_Ar_n, but2_Br_n, but2_Cr_n, but2_Dr_n;
	reg signed [15:0] but2_Ai_n, but2_Bi_n, but2_Ci_n, but2_Di_n;

	reg signed [15:0] but3_Ar_n, but3_Br_n, but3_Cr_n, but3_Dr_n;
	reg signed [15:0] but3_Ai_n, but3_Bi_n, but3_Ci_n, but3_Di_n;


	// butterfly units

	butterfly2 but0 (.Ar(din0_Ar), .Ai(din0_Ai), .Br(din0_Br), .Bi(din0_Bi), .Cr(din0_Cr), .Ci(din0_Ci), .Dr(din0_Dr), .Di(din0_Di),
	.out0r(but0_Ar), .out0i(but0_Ai), .out1r(but0_Br), .out1i(but0_Bi), .out2r(but0_Cr), .out2i(but0_Ci), .out3r(but0_Dr), .out3i(but0_Di));

	butterfly2 but1 (.Ar(din1_Ar), .Ai(din1_Ai), .Br(din1_Br), .Bi(din1_Bi), .Cr(din1_Cr), .Ci(din1_Ci), .Dr(din1_Dr), .Di(din1_Di),
	.out0r(but1_Ar), .out0i(but1_Ai), .out1r(but1_Br), .out1i(but1_Bi), .out2r(but1_Cr), .out2i(but1_Ci), .out3r(but1_Dr), .out3i(but1_Di));

    butterfly2 but2 (.Ar(din2_Ar), .Ai(din2_Ai), .Br(din2_Br), .Bi(din2_Bi), .Cr(din2_Cr), .Ci(din2_Ci), .Dr(din2_Dr), .Di(din2_Di),
	.out0r(but2_Ar), .out0i(but2_Ai), .out1r(but2_Br), .out1i(but2_Bi), .out2r(but2_Cr), .out2i(but2_Ci), .out3r(but2_Dr), .out3i(but2_Di));

	butterfly2 but3 (.Ar(din3_Ar), .Ai(din3_Ai), .Br(din3_Br), .Bi(din3_Bi), .Cr(din3_Cr), .Ci(din3_Ci), .Dr(din3_Dr), .Di(din3_Di),
	.out0r(but3_Ar), .out0i(but3_Ai), .out1r(but3_Br), .out1i(but3_Bi), .out2r(but3_Cr), .out2i(but3_Ci), .out3r(but3_Dr), .out3i(but3_Di));


	// Perform next-state logic with clock and reset line
	always @(posedge mclk or posedge puc_rst)
		begin
			if (puc_rst)
				begin
					
					/*
					but0_Ar   <= 16'b0;
					but0_Br   <= 16'b0;
					but0_Cr   <= 16'b0;
					but0_Dr   <= 16'b0;
					but0_Ai   <= 16'b0;
					but0_Bi   <= 16'b0;
					but0_Ci   <= 16'b0;
					but0_Di   <= 16'b0;

					but1_Ar   <= 16'b0;
					but1_Br   <= 16'b0;
					but1_Cr   <= 16'b0;
					but1_Dr   <= 16'b0;
					but1_Ai   <= 16'b0;
					but1_Bi   <= 16'b0;
					but1_Ci   <= 16'b0;
					but1_Di   <= 16'b0;

					but2_Ar   <= 16'b0;
					but2_Br   <= 16'b0;
					but2_Cr   <= 16'b0;
					but2_Dr   <= 16'b0;
					but2_Ai   <= 16'b0;
					but2_Bi   <= 16'b0;
					but2_Ci   <= 16'b0;
					but2_Di   <= 16'b0;

					but3_Ar   <= 16'b0;
					but3_Br   <= 16'b0;
					but3_Cr   <= 16'b0;
					but3_Dr   <= 16'b0;
					but3_Ai   <= 16'b0;
					but3_Bi   <= 16'b0;
					but3_Ci   <= 16'b0;
					but3_Di   <= 16'b0;
					*/
					but0_Ar_n <= 16'b0;
					but0_Br_n <= 16'b0;
					but0_Cr_n <= 16'b0;
					but0_Dr_n <= 16'b0;
					but0_Ai_n <= 16'b0;
					but0_Bi_n <= 16'b0;
					but0_Ci_n <= 16'b0;
					but0_Di_n <= 16'b0;

					but1_Ar_n <= 16'b0;
					but1_Br_n <= 16'b0;
					but1_Cr_n <= 16'b0;
					but1_Dr_n <= 16'b0;
					but1_Ai_n <= 16'b0;
					but1_Bi_n <= 16'b0;
					but1_Ci_n <= 16'b0;
					but1_Di_n <= 16'b0;

					but2_Ar_n <= 16'b0;
					but2_Br_n <= 16'b0;
					but2_Cr_n <= 16'b0;
					but2_Dr_n <= 16'b0;
					but2_Ai_n <= 16'b0;
					but2_Bi_n <= 16'b0;
					but2_Ci_n <= 16'b0;
					but2_Di_n <= 16'b0;

					but3_Ar_n <= 16'b0;
					but3_Br_n <= 16'b0;
					but3_Cr_n <= 16'b0;
					but3_Dr_n <= 16'b0;
					but3_Ai_n <= 16'b0;
					but3_Bi_n <= 16'b0;
					but3_Ci_n <= 16'b0;
					but3_Di_n <= 16'b0;



				end else begin

					but0_Ar_n <= but0_Ar;
					but0_Br_n <= but0_Br;
					but0_Cr_n <= but0_Cr;
					but0_Dr_n <= but0_Dr;
					but0_Ai_n <= but0_Ai;
					but0_Bi_n <= but0_Bi;
					but0_Ci_n <= but0_Ci;
					but0_Di_n <= but0_Di;

					but1_Ar_n <= but1_Ar;
					but1_Br_n <= but1_Br;
					but1_Cr_n <= but1_Cr;
					but1_Dr_n <= but1_Dr;
					but1_Ai_n <= but1_Ai;
					but1_Bi_n <= but1_Bi;
					but1_Ci_n <= but1_Ci;
					but1_Di_n <= but1_Di;

					but2_Ar_n <= but2_Ar;
					but2_Br_n <= but2_Br;
					but2_Cr_n <= but2_Cr;
					but2_Dr_n <= but2_Dr;
					but2_Ai_n <= but2_Ai;
					but2_Bi_n <= but2_Bi;
					but2_Ci_n <= but2_Ci;
					but2_Di_n <= but2_Di;

					but3_Ar_n <= but3_Ar;
					but3_Br_n <= but3_Br;
					but3_Cr_n <= but3_Cr;
					but3_Dr_n <= but3_Dr;
					but3_Ai_n <= but3_Ai;
					but3_Bi_n <= but3_Bi;
					but3_Ci_n <= but3_Ci;
					but3_Di_n <= but3_Di;

				end
		end
	
	// Compute next-state logic
	always @*
		begin	
			dmux    = 16'h0;	
			if (per_en)
				begin
					// Take data from the per_din bus and write it to an internal register
					case (per_addr)
						14'h88 : begin

						end
						14'h89 : begin end
						14'h8a : begin end
						14'h8b : begin end
						14'h8c : begin end
						14'h8d : begin end
						14'h8e : begin end
						14'h8f : begin end
						14'h90 : begin end
						14'h98 : begin end
					endcase
					// Put data from the transposition wires onto the per_dout bus
					case (per_addr)
						14'h88 : begin end
						14'h89 : begin end
						14'h8a : begin end
						14'h8b : begin end
						14'h8c : begin end
						14'h8d : begin end
						14'h8e : begin end
						14'h8f : begin end
						14'h90 : begin end
						14'h98 : begin end
					endcase
				end
		end
	
	// Define the transposition in terms of bit positions in registers

	             
	//assign per_dout = dmux;
	
endmodule

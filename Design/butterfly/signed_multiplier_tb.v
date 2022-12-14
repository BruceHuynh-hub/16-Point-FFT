module signed_multiplier_tb();


	reg signed  [15:0] din;
	reg signed  [15:0] W;
	wire signed [15:0] dout;

	signed_multiplier sm(.din(din), .W(W), .dout(dout));

	initial begin

		din = 0;
		W = 0;
		$dumpfile("trace_sm.vcd");
		$dumpvars(0, signed_multiplier_tb);
		#20

		din = 16'b00000100_00000000;
		W =   16'b01_00000000000000;
		// 4 * 1 = 4
		#20
		din = 16'b00000100_00000000;
		W =   16'b00_11111111111111;
		// 4 * 0.9999 = 3.9996
		#20
		din = 16'b00000100_00000000;
		W =   16'b11_00000000000000;
		// 4 * -1 = -4
		#20

		din = 16'b11111100_00000000;
		W =   16'b11_00000000000000;
		// -4 * -1 = 4
		#20

		din = 16'b10111100_00000000;
		W =   16'b11_10000000000000;
		// -68 * -0.5 = 34
		#20

		din = 16'b11110110_00000000;
		W =   16'b11_11100000000000;
		// -10 * -0.125 = 1.25
		#20

		$display(dout);
		#50
		$finish;
	end



endmodule 
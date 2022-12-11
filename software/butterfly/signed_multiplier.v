module signed_multiplier(

	input  [15:0] din,
	input  [15:0] W,
	output [15:0] dout

);


	reg [15:0] din_stored;
	reg [15:0] W_stored;
	reg [31:0] dinW;
	reg [31:0] dinW_2;
	reg [15:0] dinW_o;
	reg [1:0] flag;

	always @(din or W) begin
	din_stored = (din[15]) ? ~din + 1'b1 : din; // if negative then flip
	W_stored   = (W[15])    ? ~W + 1'b1 : W; // if negative then flip

		flag = (din[15] + W[15]);
		if ((din[15] + W[15]) == 1'b1) begin
			$display("negative detected");
			dinW = din_stored * W_stored;
			dinW_2 = ~dinW + 1'b1;
			dinW_o = dinW_2[29:14];

		end
		else begin
			$display("negative not detected");
			dinW = din_stored * W_stored;
			dinW_o = dinW[29:14];

		end
	end

	assign dout = dinW_o;

endmodule
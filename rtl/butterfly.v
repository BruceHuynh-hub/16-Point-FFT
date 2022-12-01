module butterfly (
	input signed [15:0] A, B, C, D,
	input signed [7:0] W, // twiddle factor
	output signed[15:0] out1, out2, out3, out4
);

	wire [15:0] B_stored;
	wire [15:0] C_stored;
	wire [15:0] D_stored;
	wire [7:0]  W_stored;

	reg  [23:0] BW;
	reg  [23:0] BW_2;
	reg  [15:0] BW_o;

	reg  [23:0] CW;
	reg  [23:0] CW_2;
	reg  [15:0] CW_o;

	reg  [23:0] DW;
	reg  [23:0] DW_2;
	reg  [15:0] DW_o;


	assign B_stored = (B[15]) ? ~B + 1'b1 : B; // if negative then flip
	assign C_stored = (C[15]) ? ~C + 1'b1 : C; // if negative then flip
	assign D_stored = (D[15]) ? ~D + 1'b1 : D; // if negative then flip
	assign W_stored = (W[7])  ? ~W + 1'b1 : W; // if negative then flip

	always @(A, B, C, D) begin

		if (B[15] + W[7]) begin
			BW = B_stored * W;
			BW_2 = ~BW + 1'b1;
			BW_o = {BW[23:15], BW[14:7]};
		end
		else begin
			BW = B_stored * W;
			BW_o = {BW[23:15], BW[14:7]};
		end

		if (C[15] + W[7]) begin
			CW = C_stored * W;
			CW_2 = ~CW + 1'b1;
			CW_o = {CW[23:15], CW[14:7]};
		end
		else begin
			CW = C_stored * W;
			CW_o = {CW[23:15], CW[14:7]};
		end

		if (D[15] + W[7]) begin
			DW = D_stored * W;
			DW_2 = ~DW + 1'b1;
			DW_o = {DW[23:15], DW[14:7]};
		end
		else begin
			DW = D_stored * W;
			DW_o = {DW[23:15], DW[14:7]};
		end

	end







endmodule 
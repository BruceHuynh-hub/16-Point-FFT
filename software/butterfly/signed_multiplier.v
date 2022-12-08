module signed_multiplier(

	input  [15:0] din,
	input   [7:0] W,
	output [15:0] dout

);


	wire [15:0] din_stored;
	wire [7:0] W_stored;
	reg  [23:0] dinW;
	reg  [23:0] dinW_2;
	reg  [15:0] dinW_o;



	assign din_stored = (din[15]) ? ~din + 1'b1 : din; // if negative then flip
	assign W_stored = (W[15]) ? ~W + 1'b1 : W; // if negative then flip
	always @(din) begin

		if (din[15] + W[7]) begin
			dinW = din_stored * W_stored;
			dinW_2 = ~dinW + 1'b1;
			dinW_o = {dinW[23:15], dinW[14:7]};
		end
		else begin
			dinW = din_stored * W_stored;
			dinW_o = {dinW[23:15], dinW[14:7]};
		end
	end

endmodule
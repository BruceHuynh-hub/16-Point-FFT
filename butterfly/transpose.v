module transpose(
	output [15:0] per_dout,  // data output
	input         mclk,      // system clock
	input  [13:0] per_addr,  // address bus  
	input  [15:0] per_din,   // data input
	input         per_en,    // active bus cycle enable
	input [1:0]   per_we,    // write control
	input         puc_rst    // power-up clear reset
	);


	reg [15:0] 		    r1;          // mapped to 0x110
	reg [15:0] 		    r1_next;     
	reg [15:0] 		    r2;          // mapped to 0x112
	reg [15:0] 		    r2_next;
	reg [15:0] 		    r3;          // mapped to 0x114
	reg [15:0] 		    r3_next;
	reg [15:0] 		    r4;          // mapped to 0x116
	reg [15:0] 		    r4_next;
	reg [15:0] 		    dmux;
	
	wire [15:0] t1, t2, t3, t4;

	// Perform next-state logic with clock and reset line
	always @(posedge mclk or posedge puc_rst)
		begin
			if (puc_rst)
				begin
					r1 <= 16'b0;
					r2 <= 16'b0;
					r3 <= 16'b0;
					r4 <= 16'b0;
				end else begin
					r1 <= r1_next;
					r2 <= r2_next;
					r3 <= r3_next;
					r4 <= r4_next;
				end
		end
	
	// Compute next-state logic
	always @*
		begin	
			r1_next = r1;
			r2_next = r2;
			r3_next = r3;
			r4_next = r4;
			dmux    = 16'h0;	
			if (per_en)
				begin
					// Take data from the per_din bus and write it to an internal register
					case (per_addr)
						14'h88 : r1_next = ( per_we[0] &  per_we[1] ) ? per_din : r1;
						14'h89 : r2_next = ( per_we[0] &  per_we[1] ) ? per_din : r2;
						14'h8a : r3_next = ( per_we[0] &  per_we[1] ) ? per_din : r3;
						14'h8b : r4_next = ( per_we[0] &  per_we[1] ) ? per_din : r4;
					endcase
					// Put data from the transposition wires onto the per_dout bus
					case (per_addr)
						14'h88 : dmux = ( ~per_we[0] & ~per_we[1] ) ? t1 : 16'h0;
						14'h89 : dmux = ( ~per_we[0] & ~per_we[1] ) ? t2 : 16'h0;
						14'h8a : dmux = ( ~per_we[0] & ~per_we[1] ) ? t3 : 16'h0;
						14'h8b : dmux = ( ~per_we[0] & ~per_we[1] ) ? t4 : 16'h0;
					endcase
				end
		end
	
	// Define the transposition in terms of bit positions in registers
	assign t1 = {r1[15], r1[ 7], r2[15], r2[ 7], r3[15], r3[ 7], r4[15], r4[ 7],
	             r1[14], r1[ 6], r2[14], r2[ 6], r3[14], r3[ 6], r4[14], r4[ 6]};
	assign t2 = {r1[13], r1[ 5], r2[13], r2[ 5], r3[13], r3[ 5], r4[13], r4[ 5],
	             r1[12], r1[ 4], r2[12], r2[ 4], r3[12], r3[ 4], r4[12], r4[ 4]};
	assign t3 = {r1[11], r1[ 3], r2[11], r2[ 3], r3[11], r3[ 3], r4[11], r4[ 3],
	             r1[10], r1[ 2], r2[10], r2[ 2], r3[10], r3[ 2], r4[10], r4[ 2]};
	assign t4 = {r1[ 9], r1[ 1], r2[ 9], r2[ 1], r3[ 9], r3[ 1], r4[ 9], r4[ 1],
	             r1[ 8], r1[ 0], r2[ 8], r2[ 0], r3[ 8], r3[ 0], r4[ 8], r4[ 0]};
	             
	assign per_dout = dmux;
	
endmodule

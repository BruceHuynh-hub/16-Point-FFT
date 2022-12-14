module FFT (
		output [15:0] per_dout,  // data output
		input         mclk,      // system clock
		input  [13:0] per_addr,  // address bus  
		input  [15:0] per_din,   // data input
		input         per_en,    // active bus cycle enable
		input [1:0]   per_we,    // write control
		input         puc_rst    // power-up clear reset 
	);

   reg [15:0] a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15;
   reg [15:0] a0n, a1n, a2n, a3n, a4n, a5n, a6n, a7n, a8n, a9n, a10n, a11n, a12n, a13n, a14n, a15n;
   reg [15:0] dmux;
   
   wire [15:0] bre [15:0];
   wire [15:0] bim [15:0];
   wire [15:0] cre [15:0];
   wire [15:0] cim [15:0];
   wire [15:0] dre [15:0];
   wire [15:0] dim [15:0];
   
	butterfly butA0(
  	a0, a4, a8, a12, 16'h0, 16'h0, 16'h0, 16'h0,
  	bre[0], bre[1], bre[2], bre[3],
  	bim[0], bim[1], bim[2], bim[3]);
	butterfly butA1(
  	a1, a5, a9, a13, 16'h0, 16'h0, 16'h0, 16'h0,
  	bre[4], bre[5], bre[6], bre[7],
  	bim[4], bim[5], bim[6], bim[7]);
	butterfly butA2(
  	a2, a6, a10, a14, 16'h0, 16'h0, 16'h0, 16'h0,
  	bre[8], bre[9], bre[10], bre[11],
  	bim[8], bim[9], bim[10], bim[11]);
	butterfly butA3(
  	a3, a7, a11, a15, 16'h0, 16'h0, 16'h0, 16'h0,
  	bre[12], bre[13], bre[14], bre[15],
  	bim[12], bim[13], bim[14], bim[15]);
  	
  twiddle twid(
  	bre[0], bre[1], bre[2], bre[3], bre[4], bre[5], bre[6], bre[7],
  	bre[8], bre[9], bre[10], bre[11], bre[12], bre[13], bre[14], bre[15],
  	bim[0], bim[1], bim[2], bim[3], bim[4], bim[5], bim[6], bim[7],
  	bim[8], bim[9], bim[10], bim[11], bim[12], bim[13], bim[14], bim[15],
  	cre[0], cre[1], cre[2], cre[3], cre[4], cre[5], cre[6], cre[7],
  	cre[8], cre[9], cre[10], cre[11], cre[12], cre[13], cre[14], cre[15],
  	cim[0], cim[1], cim[2], cim[3], cim[4], cim[5], cim[6], cim[7],
  	cim[8], cim[9], cim[10], cim[11], cim[12], cim[13], cim[14], cim[15]);
  	
	butterfly butC0(
  	cre[0], cre[4], cre[8], cre[12],
  	cim[0], cim[4], cim[8], cim[12],
  	dre[0], dre[4], dre[8], dre[12],
  	dim[0], dim[4], dim[8], dim[12]);
	butterfly butC1(
  	cre[1], cre[5], cre[9], cre[13],
  	cim[1], cim[5], cim[9], cim[13],
  	dre[1], dre[5], dre[9], dre[13],
  	dim[1], dim[5], dim[9], dim[13]);
	butterfly butC2(
  	cre[2], cre[6], cre[10], cre[14],
  	cim[2], cim[6], cim[10], cim[14],
  	dre[2], dre[6], dre[10], dre[14],
  	dim[2], dim[6], dim[10], dim[14]);
	butterfly butC3(
  	cre[3], cre[7], cre[11], cre[15],
  	cim[3], cim[7], cim[11], cim[15],
  	dre[3], dre[7], dre[11], dre[15],
  	dim[3], dim[7], dim[11], dim[15]);
   
	always @(posedge mclk or posedge puc_rst)
		begin
			if (puc_rst)
				begin
					a0 <= 16'h0; a1 <= 16'h0; a2 <= 16'h0; a3 <= 16'h0;
					a4 <= 16'h0; a5 <= 16'h0; a6 <= 16'h0; a7 <= 16'h0;
					a8 <= 16'h0; a9 <= 16'h0; a10 <= 16'h0; a11 <= 16'h0;
					a12 <= 16'h0; a13 <= 16'h0; a14 <= 16'h0; a15 <= 16'h0;
				end else begin
					a0 <= a0n; a1 <= a1n; a2 <= a2n; a3 <= a3n;
					a4 <= a4n; a5 <= a5n; a6 <= a6n; a7 <= a7n;
					a8 <= a8n; a9 <= a9n; a10 <= a10n; a11 <= a11n;
					a12 <= a12n; a13 <= a13n; a14 <= a14n; a15 <= a15n;
				end
		end
   
	always @*
		begin	
			a0n = a0; a1n = a1; a2n = a2; a3n = a3;
			a4n = a4; a5n = a5; a6n = a6; a7n = a7;
			a8n = a8; a9n = a9; a10n = a10; a11n = a11;
			a12n = a12; a13n = a13; a14n = a14; a15n = a15;
			dmux = 16'h0;	
			if (per_en)
				begin
					// write
					case (per_addr)
						14'ha0 : begin
						if (per_we[0] & per_we[1])
							begin
								a0n = per_din;
								a1n = a0; a2n = a1; a3n = a2; a4n = a3;
								a5n = a4; a6n = a5; a7n = a6; a8n = a7;
								a9n = a8; a10n = a9; a11n = a10; a12n = a11;
								a13n = a12; a14n = a13; a15n = a14;
							end
						end
					endcase
					// read
					case (per_addr)
						14'h88 : dmux = ( ~per_we[0] & ~per_we[1] ) ? dre[0] : 16'h0;
						14'h89 : dmux = ( ~per_we[0] & ~per_we[1] ) ? dim[0] : 16'h0;
						14'h8a : dmux = ( ~per_we[0] & ~per_we[1] ) ? dre[1] : 16'h0;
						14'h8b : dmux = ( ~per_we[0] & ~per_we[1] ) ? dim[1] : 16'h0;
						14'h8c : dmux = ( ~per_we[0] & ~per_we[1] ) ? dre[2] : 16'h0;
						14'h8d : dmux = ( ~per_we[0] & ~per_we[1] ) ? dim[2] : 16'h0;
						14'h8e : dmux = ( ~per_we[0] & ~per_we[1] ) ? dre[3] : 16'h0;
						14'h8f : dmux = ( ~per_we[0] & ~per_we[1] ) ? dim[3] : 16'h0;
						14'h9a : dmux = ( ~per_we[0] & ~per_we[1] ) ? dre[4] : 16'h0; //cannot use 14'h90
						14'h91 : dmux = ( ~per_we[0] & ~per_we[1] ) ? dim[4] : 16'h0;
						14'h92 : dmux = ( ~per_we[0] & ~per_we[1] ) ? dre[5] : 16'h0;
						14'h93 : dmux = ( ~per_we[0] & ~per_we[1] ) ? dim[5] : 16'h0;
						14'h94 : dmux = ( ~per_we[0] & ~per_we[1] ) ? dre[6] : 16'h0;
						14'h95 : dmux = ( ~per_we[0] & ~per_we[1] ) ? dim[6] : 16'h0;
						14'h96 : dmux = ( ~per_we[0] & ~per_we[1] ) ? dre[7] : 16'h0;
						14'h97 : dmux = ( ~per_we[0] & ~per_we[1] ) ? dim[7] : 16'h0;
						14'h98 : dmux = ( ~per_we[0] & ~per_we[1] ) ? dre[8] : 16'h0;
						14'h99 : dmux = ( ~per_we[0] & ~per_we[1] ) ? dim[8] : 16'h0;
					endcase
				end
		end

	assign per_dout = dmux;

	endmodule

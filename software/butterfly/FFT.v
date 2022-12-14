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
	      14'h98 : begin
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
	      14'h88 : dmux = ( ~per_we[0] & ~per_we[1] ) ? a0 : 16'h0;
	      14'h89 : dmux = ( ~per_we[0] & ~per_we[1] ) ? a1 : 16'h0;
	      14'h8a : dmux = ( ~per_we[0] & ~per_we[1] ) ? a2 : 16'h0;
	    endcase
	  end
     end
   
   assign per_dout = dmux;
 
endmodule

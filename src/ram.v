module ram#(
	parameter DATA_WIDTH = 8,
	parameter ADDR_BIT = 9,
	parameter ADDR_DEPTH = 512
)(
		wrclk,
		wren,
		wrdata,
		wraddress,
		rst_n,
		rden,
		rdclk,
		rddata,
		rdaddress	
);

	input 									wrclk;
	input										wren;
	input		 [DATA_WIDTH-1:0]			wrdata;
	input 	 [ADDR_BIT-1:0]			wraddress;
	input 									rst_n;
	input 									rden;
	input 									rdclk;
	input 	 [ADDR_BIT-1:0]			rdaddress;
	output reg[DATA_WIDTH-1:0]			rddata;
	
	reg 		 [DATA_WIDTH-1:0]			mem[ADDR_DEPTH-1:0];
	
	integer i;
	always@(posedge wrclk)
	if(!rst_n)
		for(i=0;i<ADDR_DEPTH;i=i+1)
			mem[i] <= 0;
	else if( wren )
		mem[wraddress] <= wrdata;
	
	always@(posedge rdclk)
	if(!rst_n)
		rddata <= 0;
	else if( rden )
		rddata <= mem[rdaddress];
		
endmodule

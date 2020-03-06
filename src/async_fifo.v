module async_fifo#(
	parameter DATA_WIDTH = 8,
	parameter ADDR_DEPTY_BIT = 9,
	parameter ADDR_DEPTY = 512
)(
		rst_n_i,
		fifo_w_req_i,
		fifo_w_clk_i,
		fifo_w_data_i,
		fifo_w_full_o,
		
		fifo_r_req_i,
		fifo_r_clk_i,
		fifo_r_data_o,
		fifo_r_empty_o
		
);

	input									rst_n_i;
	input									fifo_w_req_i;
	input									fifo_w_clk_i;
	input	[DATA_WIDTH-1:0]			fifo_w_data_i;
	output								fifo_w_full_o;
	input									fifo_r_req_i;
	input									fifo_r_clk_i;
	output[DATA_WIDTH-1:0]			fifo_r_data_o;
	output								fifo_r_empty_o;
	
	wire									w_req;
	wire [ADDR_DEPTY_BIT:0]			w_addr_async_gray;
	wire [ADDR_DEPTY_BIT:0]			w_addr_sync_gray;
	wire [ADDR_DEPTY_BIT:0]			w_addr;
	wire									r_req;
	wire [ADDR_DEPTY_BIT:0]			r_addr_async_gray;
	wire [ADDR_DEPTY_BIT:0]			r_addr_sync_gray;
	wire [ADDR_DEPTY_BIT:0]			r_addr;
	
	//for test
/*	wire	[DATA_WIDTH-1:0]			q;
	wire									rdempty;
	wire									wrfull;
	
	
	fifo_ip fifo_ip(
		.data					( fifo_w_data_i ),
		.rdclk				( fifo_r_clk_i ),
		.rdreq				( fifo_r_req_i ),
		.wrclk				( fifo_w_clk_i ),
		.wrreq				( fifo_w_req_i ),
		.q						( q ),
		.rdempty				( fifo_r_empty_o ),
		.wrfull				( fifo_w_full_o )
	);
*/
	write_control#(
		.ADD_WIDTH 			( ADDR_DEPTY_BIT )
	)write_control(
		.w_clk_i				( fifo_w_clk_i ),
		.rst_n_i				( rst_n_i ),
		.w_req_i				( fifo_w_req_i ),
		.r_g_addr			( r_addr_sync_gray ),
		.w_req_o				( w_req ),
		.w_full_o			( fifo_w_full_o ),
		.w_addr_bin			( w_addr ),
		.w_addr_gray		( w_addr_async_gray )
	);
	
	sync
	#(
		.WIDTH				( ADDR_DEPTY_BIT )	
	)sync_w(
		.clk_i				( fifo_r_clk_i ),
		.rst_n_i				( rst_n_i ),
		.async_data_i		( w_addr_async_gray ),
		.sync_data_o		( w_addr_sync_gray )
	);
	
	
	read_control#(
	   .ADD_WIDTH			( ADDR_DEPTY_BIT )
	)read_control(
		.r_clk_i				( fifo_r_clk_i ),
		.rst_n_i				( rst_n_i ),
		.r_req_i				( fifo_r_req_i ),
		.w_g_addr			( w_addr_sync_gray ),
		.r_req_o				( r_req ),
		.r_empty_o			( fifo_r_empty_o ),
		.r_addr_bin			( r_addr ),
		.r_addr_gray		( r_addr_async_gray )
	);
	
	sync
	#(
		.WIDTH				( ADDR_DEPTY_BIT )	
	)sync_r(
		.clk_i				( fifo_w_clk_i ),
		.rst_n_i				( rst_n_i ),
		.async_data_i		( r_addr_async_gray ),																																																			
		.sync_data_o		( r_addr_sync_gray )
	);
	
	ram#(
		.DATA_WIDTH ( DATA_WIDTH ),
		.ADDR_BIT   ( ADDR_DEPTY_BIT ),
		.ADDR_DEPTH ( ADDR_DEPTY )
)ram(
		.wrclk				( fifo_w_clk_i ),
		.wren					( w_req ),
		.wrdata				( fifo_w_data_i ),
		.wraddress			( w_addr[ADDR_DEPTY_BIT-1:0] ),
		.rst_n				( RST_n_i ),
		.rden					( r_req ),
		.rdclk				( fifo_r_clk_i ),
		.rddata					( fifo_r_data_o ),
		.rdaddress			( r_addr[ADDR_DEPTY_BIT-1:0] )	
);

endmodule

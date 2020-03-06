`timescale 1ns/1ns
module async_fifo_tb;
	
	reg						rst_n_i;
	reg						fifo_w_req_i;
	reg						fifo_w_clk_i;
	reg	[7:0]				fifo_w_data_i;
	reg						fifo_r_req_i;
	reg						fifo_r_clk_i;
	
	wire						fifo_w_full_o;
	wire	[7:0]				fifo_r_data_o;
	wire						fifo_r_empty_o;
	
	async_fifo#(
		.DATA_WIDTH ( 8 ),
		.ADDR_DEPTY_BIT ( 9 )
	)async_fifo(
		.rst_n_i								( rst_n_i ),
		
		.fifo_w_req_i						( fifo_w_req_i ),
		.fifo_w_clk_i						( fifo_w_clk_i ),
		.fifo_w_data_i						( fifo_w_data_i ),
		.fifo_w_full_o						( fifo_w_full_o ),
		
		.fifo_r_req_i						( fifo_r_req_i ),
		.fifo_r_clk_i						( fifo_r_clk_i ),
		.fifo_r_data_o						( fifo_r_data_o ),
		.fifo_r_empty_o					( fifo_r_empty_o )
	);
	
	integer i;

	initial begin
		
		rst_n_i = 0;
		fifo_w_req_i = 0;
		fifo_r_req_i = 0;
		fifo_r_clk_i = 0;
		fifo_w_clk_i = 0;
		#1000;
		rst_n_i = 1;
		
		#200;
		fifo_w_req_i = 1;
			
		#20000;
		fifo_w_req_i = 0;
	
		#200;
		fifo_r_req_i = 1;
			
		#20000;
		fifo_r_req_i = 0;
		
		#8000;
		fifo_w_req_i = 1;
		#2000;
		fifo_r_req_i = 1;
			
		#3000;
		fifo_r_req_i = 0;
		#6000;
		fifo_w_req_i = 0;	
		
		#4000;
		
		$stop;
		
	
	end
	
	always #10 fifo_w_clk_i = ~fifo_w_clk_i;

	always #8	fifo_r_clk_i = ~fifo_r_clk_i;
	
	always @(posedge fifo_w_clk_i or negedge rst_n_i)
	if(!rst_n_i)
		fifo_w_data_i <= 16'd0;
	else if(fifo_w_req_i && ~fifo_w_full_o)
		fifo_w_data_i <= fifo_w_data_i + 1'b1;
		
endmodule

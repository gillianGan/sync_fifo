module read_control#(
	parameter ADD_WIDTH = 9
)(
		r_clk_i,
		rst_n_i,
		r_req_i,
		w_g_addr,
		r_req_o,
		r_empty_o,
		r_addr_bin,
		r_addr_gray
);
	
	input								r_clk_i;
	input								rst_n_i;
	input								r_req_i;
	input	[ADD_WIDTH:0]			w_g_addr;
	output 							r_req_o;
	output							r_empty_o;
	output reg[ADD_WIDTH:0]		r_addr_bin;
	
	output [ADD_WIDTH:0]			r_addr_gray;
	
	always@(posedge r_clk_i or negedge rst_n_i)
	if(!rst_n_i)
		r_addr_bin <= 0;
	else if(r_req_i && ~r_empty_o)
		r_addr_bin <= r_addr_bin + 1;
	
	bin_to_gray#(
		.WIDTH 				( ADD_WIDTH )
	)bin_to_gray_r(
		.bin_data_i			( r_addr_bin ),
		.gray_data_o		( r_addr_gray )
		
	);
	
	assign r_empty_o = ( r_addr_gray== w_g_addr )?1'b1:1'b0;
	
	assign r_req_o = r_req_i;
	
endmodule

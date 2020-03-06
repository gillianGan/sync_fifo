module write_control#(
	parameter ADD_WIDTH = 9
)(
		w_clk_i,
		rst_n_i,
		w_req_i,
		r_g_addr,
		w_req_o,
		w_full_o,
		w_addr_bin,
		w_addr_gray
);
	
	input								w_clk_i;
	input								rst_n_i;
	input								w_req_i;
	input	[ADD_WIDTH:0]			r_g_addr;
	output 							w_req_o;
	output							w_full_o;
	output reg[ADD_WIDTH:0]		w_addr_bin;
	output [ADD_WIDTH:0]			w_addr_gray;
	
	always@(posedge w_clk_i or negedge rst_n_i)
	if(!rst_n_i)
		w_addr_bin <= 0;
	else if(w_req_i && ~w_full_o)
		w_addr_bin <= w_addr_bin + 1;
	
	bin_to_gray#(
		.WIDTH 				( ADD_WIDTH )
	)bin_to_gray_w(
		.bin_data_i			( w_addr_bin ),
		.gray_data_o		( w_addr_gray )
		
	);
	
	assign w_full_o = ({~w_addr_gray[ADD_WIDTH],~w_addr_gray[ADD_WIDTH-1],~w_addr_gray[ADD_WIDTH-2:0]} == r_g_addr)?1'b1:1'b0;
	
	assign w_req_o = w_req_i;
	
endmodule

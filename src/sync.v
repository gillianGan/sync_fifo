module sync
#(
		parameter WIDTH = 5	
)(
		clk_i,
		rst_n_i,
		async_data_i,
		sync_data_o
);
		input   						clk_i;
		input							rst_n_i;
		input 	[WIDTH:0]		async_data_i;
		output 	[WIDTH:0]		sync_data_o;
		
		reg[WIDTH:0]	sync_data_1,sync_data_2;
		
		always@(posedge clk_i or negedge rst_n_i)
		if(!rst_n_i) begin
			sync_data_1 <= 0;
			sync_data_2 <= 0;
		end
		else begin
			sync_data_1 <= async_data_i;
			sync_data_2 <= sync_data_1;
		end
			
		assign	sync_data_o = sync_data_2;
			
endmodule

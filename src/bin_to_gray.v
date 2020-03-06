module bin_to_gray#(
	parameter WIDTH = 5
)(
		bin_data_i,
		gray_data_o
		
);

	input	[WIDTH:0]					bin_data_i;
	output[WIDTH:0]					gray_data_o;
	
	wire 						gray_c_d_h;
	reg	[WIDTH-1:0]		gray_c_d;
	
	assign gray_c_d_h = bin_data_i[WIDTH];
	
	integer i;
	always @(*)
		for( i = 0 ; i<WIDTH;i=i+1)
			gray_c_d[i] = bin_data_i[i]^bin_data_i[i+1];

	assign gray_data_o = {gray_c_d_h,gray_c_d};
	
endmodule

interface dec_interface_if(input clk, rstn);
	logic		dt_i;
	logic 		valid_i;
	logic [7:0] dt_o;
	logic		valid_o;


	modport mst(input clk, rstn, dt_o, valid_o, output dt_i, valid_i);
	modport slv(input clk, rstn, input dt_i, valid_i, output dt_o, valid_o);

endinterface : dec_interface_if

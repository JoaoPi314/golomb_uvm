interface interface_if(input clk, rstn);
	logic [7:0] dt_i;
	logic 		valid_i;
	logic		dt_o;
	logic		valid_o;
	logic		busy_o;


	modport mst(input clk, rstn, dt_o, valid_o, busy_o, output dt_i, valid_i);
	modport slv(input clk, rstn, input dt_i, valid_i, output dt_o, valid_o, busy_o);

endinterface : interface_if

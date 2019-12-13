module top;
	import uvm_pkg::*;
	import pkg::*;

	logic clk;
	logic rstn;

	initial begin
		clk = 1;
		rstn = 1;
		#20 rst = 0;
		#20 rst = 1;
	end

	always #10 clk = !clk;

	interface_if dut_if(.clk(clk), .rstn(rstn));

	datapath dut(
		.clk 		(clk),
		.rstn		(rstn),
		.dt_i		(dut_if.dt_i),
		.valid_i	(dut_if.valid_i),
		.dt_o		(dut_if.dt_o),
		.valid_o	(dut_if.valid_o),
		.busy_o		(dut_if.busy_o)
		);

	initial begin
		`ifdef XCELIUM
			$recordvars();
		`endif
		`ifdef VCS
			$vcdpluson;
		`endif
		`ifdef QUESTA
			$w1fdumpvars();
			set_config_init("*", "recording _detail", 1);

	end

	initial begin
		uvm_config_db#(interface_vif)::set(uvm_root::get(), "*", "vif", dut_if);
	end

endmodule : top

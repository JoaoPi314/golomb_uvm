typedef virtual cod_interface_if.mst interface_vif;

class cod_driver extends uvm_driver #(cod_transaction_in);
	`uvm_component_utils(cod_driver) 

	interface_vif vif;
	cod_transaction_in tr;

	function new(string name = "cod_driver", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new


	virtual function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(interface_vif)::get(this, "", "vif", vif))begin
			`uvm_fatal("NOVIF", "failder to get virtual interface")
		end
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		fork
			reset_signals();
			get_and_drive(phase);
		join
	endtask : run_phase

	virtual task reset_signals();
		wait(vif.rstn === 0);
			forever begin
				vif.dt_i    <= '0;
				vif.valid_i <= '0;
				@(posedge vif.rstn);
			end
	endtask : reset_signals


	virtual task get_and_drive(uvm_phase phase);
		wait(vif.rstn === 0);
		@(posedge vif.rstn);
		forever begin
			@(posedge vif.clk);
			seq_item_port.get_next_item(tr);
			begin_tr(tr, "req_driver");
			@(posedge vif.clk);
			vif.dt_i = tr.dt_i;
			vif.valid_i = '1;
			repeat(2) @(posedge vif.clk);
			vif.valid_i = '0;
			@(negedge vif.busy_o);
			seq_item_port.item_done();
			end_tr(tr);
		end
	endtask : get_and_drive

endclass : cod_driver



typedef virtual interface_if.mst interfgace_vif;

class driver extends uvm_driver #(transaction_in);
	`uvm_component_utils(driver) //Sempre tem que ter isso em classes que derivam de uvm_object

	interface_vif vif;
	transaction_in tr;

	function new(string name = "driver", uvm_component parent = null);
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
			get_and_drive();
		join
	endtask : run_phase

	virtual task reset_signals();
		wait(vif.rstn === 0)
			forever begin
				vif.dt_i    <= '0;
				vif.valid_i <= '0;
				@(posedge vif.rstn)
			end
	endtask : reset_signals

	
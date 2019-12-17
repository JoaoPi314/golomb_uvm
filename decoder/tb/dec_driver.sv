typedef virtual dec_interface_if.mst interface_vif;

class dec_driver extends uvm_driver #(dec_transaction_in);
	`uvm_component_utils(dec_driver) //Sempre tem que ter isso em classes que derivam de uvm_object

	dec_interface_vif vif;
	dec_transaction_in tr;

	int cont, c;
	bit [16:0] auxiliar;

	function new(string name = "dec_driver", uvm_component parent = null);
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
			conta();
			c = cont;
			valid_i = 1;
			while(c > 0)begin
				@(posedge vif.clk);
				vif.dt_i = tr.dt_i[c];
			end
			valid_i = 0;

		end
	endtask : get_and_drive


	virtual function void conta();
		auxiliar = tr.dt_i + 1;
		cont = 0;
		while (auxiliar[16] === 0 && cont < 17)begin
			auxiliar = auxiliar << 1;
			cont +=1 ;
		end
		//$display("cont do monitor = %d", cont);
		cont = 17 - cont;
		cont = (cont == 0) ? 17 : cont; 
	endfunction : conta

endclass : dec_driver



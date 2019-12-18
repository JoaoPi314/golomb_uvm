typedef virtual dec_interface_if.mst interface_vif;

class dec_driver extends uvm_driver #(dec_transaction_in);
	`uvm_component_utils(dec_driver) //Sempre tem que ter isso em classes que derivam de uvm_object

	interface_vif vif;
	dec_transaction_in tr;

	int cont, c;

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
			@(posedge vif.clk);
			seq_item_port.get_next_item(tr);
			conta();
			c = 2*cont;
			//$display("dt_i = %b", tr.dt_i);
			while(c >= 0)begin
				@(posedge vif.clk);
				vif.valid_i = 1;
				vif.dt_i = tr.dt_i[c];
				//$display("tr.dt_i[%d] = %d", c, tr.dt_i[c]);
				c -= 1;
				//$display("vif.dt_i = %d", vif.dt_i);
			end
			begin_tr(tr, "driver");
			@(posedge vif.clk);
			vif.valid_i = 0;
			@(negedge vif.clk);
			seq_item_port.item_done();
			end_tr(tr);
			@(posedge vif.valid_o);

		end
	endtask : get_and_drive


	virtual function void conta();
		cont = 16;
		while (tr.dt_i[cont] != 1'b1 && cont >= 0)begin
			cont -=1;
		end
		//$display("cont do driver = %d", cont);
		cont = (cont == -1) ? 8 : cont;
		//if(cont > 8) cont = 8; 
		//$display("Cont = %d", cont);
	endfunction : conta

endclass : dec_driver



typedef virtual dec_interface_if.mst interface_vif;

class dec_driver extends uvm_driver #(dec_transaction_in);
	`uvm_component_utils(dec_driver)
	interface_vif vif;
	dec_transaction_in tr;

	int cont, cont2;
	bit timeOut;

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
			contaTimeOut();
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
			//@(posedge vif.clk);
			seq_item_port.get_next_item(tr);
			//$display("dt_i = %b", tr.dt_i);
			conta();
			cont = 2*cont;
			while(cont >= 0)begin
				@(posedge vif.clk);
				vif.valid_i = 1;
				vif.dt_i = tr.dt_i[cont];
				cont -= 1;
			end
			begin_tr(tr, "driver");
			@(posedge vif.clk);
			vif.valid_i = 0;
			@(negedge vif.clk);
			seq_item_port.item_done();
			end_tr(tr);
			//$display("Travei aqui?");
			@(posedge vif.clk iff vif.valid_o or timeOut);

		end
	endtask : get_and_drive


	virtual function void conta();
		cont = 16;
		while (tr.dt_i[cont] != 1'b1 && cont >= 0)begin
			cont -=1;
		end
		cont = (cont == -1) ? 8 : cont;
		cont = (cont > 8 ) ? 8 : cont;
		//$display("Cont = %d", cont);
	endfunction : conta

	virtual task contaTimeOut();
		forever begin
			@(posedge vif.valid_i);
			@(negedge vif.valid_i);
			timeOut = 0;
			cont2 = 0;
			while(~timeOut)begin 
				cont2 += 1;
				if(cont2 >= 20)
					timeOut = 1'b1;
				else
					timeOut = 1'b0;
				if(vif.valid_o)
					break;
				@(posedge vif.clk);	
				//$display("TimeOut = %b; contador = %d", timeOut, cont2);
			end 
		end
	endtask : contaTimeOut

endclass : dec_driver



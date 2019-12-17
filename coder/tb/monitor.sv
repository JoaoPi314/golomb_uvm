class monitor extends uvm_monitor;
	`uvm_component_utils(monitor)

	interface_vif vif;
	event begin_rec_in, begin_rec_out, end_rec_in, end_rec_out;
	transaction_in tr_in;
	transaction_out tr_out;

	int index;
	int cont;
	bit [7:0] auxiliar;
	bit [16:0] dt_o;

	uvm_analysis_port #(transaction_in)  req_port;
	uvm_analysis_port #(transaction_out) resp_port;

	function new(string name, uvm_component parent);
		super.new(name, parent);
		req_port = new ("req_port", this);
		resp_port = new("resp_port", this);
		index = 0;
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(interface_vif)::get(this, "", "vif", vif)) begin 
			`uvm_fatal("NOVIF", "failed to get virtual interface")
		end
		tr_in = transaction_in::type_id::create("tr_in", this);
		tr_out = transaction_out::type_id::create("tr_out", this);
	endfunction : build_phase

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);	
		fork

			collect_tr(phase);
		join		
	endtask : run_phase

	virtual task record_in();
		@(begin_rec_in);
		begin_tr(tr_in, "req");
		@(end_rec_in);
		end_tr(tr_in);
	endtask : record_in


	virtual task collect_tr(uvm_phase phase);
		forever begin 
			fork
				record_in();
				collect_tr_in(phase);
				collect_tr_out(phase);
			join

		end 
	endtask : collect_tr



	virtual task collect_tr_in(uvm_phase phase);
			@(posedge vif.clk iff vif.valid_i) begin
			->begin_rec_in;
			tr_in.dt_i = vif.dt_i;
			req_port.write(tr_in);
			@(negedge vif.clk);
			->end_rec_in;
			end 
		
	endtask : collect_tr_in

	virtual task collect_tr_out(uvm_phase phase);
			@(posedge vif.clk iff vif.valid_o);
			conta();
			while(vif.valid_o) begin
				dt_o[cont - index - 1] = vif.dt_o;
				index += 1;
				@(posedge vif.clk);
				//$display("vif.dt_o = %b", vif.dt_o);
				//$display("dt_o[%d] = %b", cont - index - 1, vif.dt_o);
			end
			//$display("dt_o = %b", dt_o);
			tr_out.dt_o = dt_o;
			begin_tr(tr_out, "resp");
			resp_port.write(tr_out);
			//$display("Escrevi");
			if(~vif.valid_o)
				index = 0;
			@(negedge vif.clk);
			end_tr(tr_out);
		 
	endtask : collect_tr_out

	virtual function void conta();
		auxiliar = vif.dt_i + 1;
		cont = 0;
		while (auxiliar[7] === 0 && cont < 8)begin
			auxiliar = auxiliar << 1;
			cont +=1 ;
		end
		//$display("cont do monitor = %d", cont);
		cont = 8 - cont;
		cont = (cont == 0) ? 9 : cont; 
		cont = (cont - 1)*2 + 1;
	endfunction : conta
	

endclass : monitor
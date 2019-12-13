class monitor extends uvm_monitor;
	`uvm_component_utils(monitor)

	interface_vif vif;
	event begin_rec_in, begin_rec_out, end_rec_in, end_rec_out;
	transaction_in tr_in;
	transaction_out tr_out;

	int index;
	int counter;

	uvm_analysis_port #(transaction_in)  req_port;
	uvm_analysis_port #(transaction_out) resp_port;

	function new(string name, uvm_component parent);
		super.new(name, parent);
		req_port = new ("req_port", this);
		resp_port = new("resp_port", this);
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
			$display("Eu escrevi?");
			@(negedge vif.clk);
			->end_rec_in;
			end 
		
	endtask : collect_tr_in

	virtual task collect_tr_out(uvm_phase phase);
			@(posedge vif.clk iff vif.valid_o);
			while(vif.valid_o) begin
				begin_tr(tr_out, "resp");
				tr_out.dt_o = vif.dt_o;
				tr_out.index = index;
				index += 1;
				resp_port.write(tr_out);
				$display("Escrevi a resp? ");
				@(negedge vif.clk);
				end_tr(tr_out);
				@(posedge vif.clk);
			end
			if(~vif.valid_o)
				index = 0;
		 
	endtask : collect_tr_out
	

endclass : monitor
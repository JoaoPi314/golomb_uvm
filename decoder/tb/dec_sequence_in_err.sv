class dec_sequence_in_err extends uvm_sequence #(dec_transaction_in);
	`uvm_object_utils(dec_sequence_in_err)


	function new(string name="dec_sequence_in_err");
		super.new(name);
	endfunction : new


	task body();
		dec_transaction_in tr;
		forever begin
			tr = dec_transaction_in::type_id::create("tr");
			start_item(tr);
			assert(tr.randomize()with{tr.dt_i == '0;});
			finish_item(tr);
		end
	endtask : body


endclass : dec_sequence_in_err
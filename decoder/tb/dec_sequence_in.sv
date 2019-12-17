class dec_sequence_in extends uvm_sequence #(dec_transaction_in);
	`uvm_object_utils(dec_sequence_in)


	function new(string name="dec_sequence_in");
		super.new(name);
	endfunction : new


	task body();
		dec_transaction_in tr;
		forever begin
			tr = dec_transaction_in::type_id::create("tr");
			start_item(tr);
			assert(tr.randomize()with{tr.dt_i == 17'b0000_0000_0_000_1100;});
			finish_item(tr);
		end
	endtask : body


endclass : dec_sequence_in

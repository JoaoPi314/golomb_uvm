class dec_transaction_out extends uvm_sequence_item;

	rand bit [7:0] dt_o;
	rand bit invalid_output;

	function new(string name = "");
		super.new(name);
	endfunction : new


	`uvm_object_param_utils_begin(dec_transaction_out)
		`uvm_field_int(dt_o , UVM_UNSIGNED)
	`uvm_object_utils_end


	function string convert2string();
		return $sformatf("dt_o = %b", dt_o);
	endfunction

endclass : dec_transaction_out

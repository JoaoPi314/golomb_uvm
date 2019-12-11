class transaction_out extends uvm_sequence_item;

	rand bit dt_o;
	rand bit index;

	function new(string name = "");
		super.new(name);
	endfunction : new


	`uvm_object_param_utils_begin(transaction_out)
		`uvm_field_int(dt_o , UVM_UNSIGNED)
		`uvm_field_int(index , UVM_UNSIGNED)
	`uvm_objects_utils_end


	function string convert2string();
		return $sformatf("dt_o = %h", dt_o);
	endfunction

endclass : transaction_out

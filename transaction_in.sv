class transaction_in extends uvm_sequence_item;

	rand bit [7:0] dt_i;

	function new(string name = "");
		super.new(name);
	endfunction : new


	`uvm_object_param_utils_begin(transaction_in)
		`uvm_field_int(dt_i, UVM_UNSIGNED)
	`uvm_objects_utils_end


	function string convert2string();
		return $sformatf("dt_i = %h", dt_i);
	endfunction

endclass : transaction_in
package pkg;
	`include "uvm_macros.svh"
	import uvm_pkg::*;

	`include "./dec_transaction_in.sv"
	`include "./dec_transaction_out.sv"
	`include "./dec_sequence_in.sv"
	`include "./dec_driver.sv"
	`include "./monitor.sv"
	`include "./agent.sv"

	`include "./coverage.sv"
	`include "./refmod.sv"
	`include "./scoreboard.sv"

	`include "./env.sv"
	`include "./simple_test.sv"

endpackage : pkg
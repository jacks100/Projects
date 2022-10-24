//===============================================================================
// Testbench Module for Simon
//===============================================================================
`timescale 1ns/100ps

`include "HopfieldControl_v1.v"
`include "defines.v"

`define ASSERT_EQ(ONE, TWO, MSG)               \
	begin                                      \
		if ((ONE) !== (TWO)) begin             \
			$display("\t[FAILURE]:%s", (MSG)); \
		end                                    \
	end #0

`define SET(VAR, VALUE) $display("Setting %s to %s...", "VAR", "VALUE"); #1; VAR = (VALUE); #1

`define CLOCK $display("Pressing uclk..."); #1; clk = 1; #1; clk = 0; #1

`define SHOW_MODE(MODE) $display("\nEntering Mode: %s\n-----------------------------------", MODE)

module HopfieldcontrolTest;

	// Local Vars
	reg clk; // Clock
    reg rst; // RESET
	// Datapath Control Inputs
	reg same_input; // True if the same input as previous clock cycle
	reg converged; // True if all neurons in same state as previous clock cycle
	// Control outputs
	wire modify_neuron; // True if neuron state is to be modified
	wire modify_neuron_using_input; // True if neuron state should be set to input, only happens if modify_neuron is True
	wire modify_weights; // True if weights are to be modified
    // reg [NEURON_COUNT-1:0] state;

	// VCD Dump
	// integer idx;
	// initial begin
	// 	$dumpfile("SimonTest.vcd");
	// 	$dumpvars;
	// 	for (idx = 0; idx < 64; idx = idx + 1) begin
	// 		$dumpvars(0, simon.dpath.mem.mem[idx]);
	// 	end
	// end

    	// VCD Dump
	initial begin
		$dumpfile("HopfieldControlTest.vcd");
		$dumpvars;
	end

	// Controller Module
	HopfieldControl ctrl(
		.clk(clk),
        .rst(rst),
        .same_input(same_input),
        .converged(converged),
        .modify_neuron(modify_neuron),
        .modify_neuron_using_input(modify_neuron_using_input),
        .modify_weights(modify_weights)
        //.state(state)
	);


	// Main Test Logic
	initial begin
		// Tick the clock
		`SHOW_MODE("Unknown");
        `SET(rst, 1);
		`CLOCK;

        `SET(rst, 0);
        `CLOCK;

		//-----------------------------------------------
		// INPUT Mode
		// ----------------------------------------------
		`SHOW_MODE("Input");
        //`ASSERT_EQ(state, STATE_INPUT, "The state should be STATE_INPUT!");

        `CLOCK;

        //-----------------------------------------------
		// INPUT Mode
		// ----------------------------------------------
		`SHOW_MODE("Input");
       // `ASSERT_EQ(state, STATE_INPUT, "The state should be STATE_INPUT!");
        `SET(same_input, 1);
        `CLOCK;

        //-----------------------------------------------
		// UPDATING Mode
		// ----------------------------------------------
		`SHOW_MODE("UPDATING");
        //`ASSERT_EQ(state, STATE_UPDATING, "The state should be STATE_UPDATING!");
		`ASSERT_EQ(modify_neuron, 1, "Modify neuron should be 1 !");
        `ASSERT_EQ(modify_neuron_using_input, 0, "Modify neuron using input should be 0!");

		// Set converged to be 1
		`SET(converged, 1);
        
        `CLOCK;
        // // LEARNING MODE
		// ----------------------------------------------
		`SHOW_MODE("LEARNING");
        //`ASSERT_EQ(state, STATE_LEARNING, "The state should be STATE_LEARNING!");
		`ASSERT_EQ(modify_weights, 1, "Modify weights should be 1 !");


		$display("\nTESTS COMPLETED");
		$finish;
	end
endmodule
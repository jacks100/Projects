//===============================================================================
// Testbench Module for Simon
//===============================================================================
`timescale 1ns/100ps

`include "HopfieldDatapath_v1.v"
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

module HopfielddpathTest;

	// Local Vars
	reg clk; // Clock
    reg rst; // RESET
    reg [`NEURON_INDEX_MAX:0] pattern_input; // neuron input pattern
    reg modify_neuron; // True if neuron state is to be modified
	reg modify_neuron_using_input; // True if neuron state should be set to input, only happens if modify_neuron is True
	reg modify_weights; // True if weights are to be modified

    wire same_input; // True if the same input was present at the previous clock cycle
    wire converged; // True if same neuron values occur at consecutive clock cycles for all neurons
    wire [`NEURON_INDEX_MAX: 0] neuron_states; // states of all neurons, should the [] go after the neuron_states
    // wire [15:0] weights_out;


   



    	// VCD Dump
	initial begin
		$dumpfile("HopfieldDatapathTest.vcd");
        // for (idx = 0; idx < 64; idx = idx + 1) begin
		// 	$dumpvars(0, simon.dpath.mem.mem[idx]);
		// end
		$dumpvars;
	end

	// Controller Module
	HopfieldDatapath dpath(
		.clk(clk),
        .rst(rst),
        .pattern_input(pattern_input),
        .modify_neuron(modify_neuron),
        .modify_neuron_using_input(modify_neuron_using_input),
        .modify_weights(modify_weights),
        .same_input(same_input),
        .converged(converged),
        .neuron_states(neuron_states)

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
		// New Input
		// ----------------------------------------------
        `SHOW_MODE("INPUT");
        `SET(modify_neuron, 1);
        `SET(modify_neuron_using_input, 1);
        `SET(pattern_input, `PATTERN_INPUT_1);

        `CLOCK;

		//-----------------------------------------------
		// CONFIRM INPUT
		// ----------------------------------------------
        `ASSERT_EQ(neuron_states, `PATTERN_INPUT_1, "The neuron statesd should be PATTERN_INPUT_1!");

        `CLOCK;




         //-----------------------------------------------
		// New Input
		// ----------------------------------------------
        `SHOW_MODE("INPUT");
        `SET(modify_neuron, 1);
        `SET(modify_neuron_using_input, 0);
        `CLOCK;

		// //-----------------------------------------------
		// // CONFIRM INPUT
		// // ----------------------------------------------
        // `ASSERT_EQ(neuron_states, `PATTERN_INPUT_1, "The neuron statesd should be PATTERN_INPUT_1!");

        `CLOCK;
        `CLOCK;
        `CLOCK;

        //-----------------------------------------------
		// LEARN
		// ----------------------------------------------
        `SHOW_MODE("MODIFY WEIGHTs");
        `SET(modify_weights, 1);
        `SET(modify_neuron, 0);
        `CLOCK;
        `CLOCK;
        `SET(modify_weights, 0);
        `SET(modify_neuron, 1);
        `CLOCK;
        `CLOCK;
         //-----------------------------------------------
		// New Input
		// ----------------------------------------------
        `SHOW_MODE("INPUT");
        `SET(modify_neuron, 1);
        `SET(modify_neuron_using_input, 1);
        `SET(pattern_input, `PATTERN_INPUT_2);
        `CLOCK
        `CLOCK
        `SET(modify_neuron, 1);
        `SET(modify_neuron_using_input, 0);
        `CLOCK;
        `CLOCK;
        `CLOCK

        //-----------------------------------------------
		// LEARN
		// ----------------------------------------------
        `SHOW_MODE("MODIFY WEIGHTs");
        `SET(modify_weights, 1);
        `SET(modify_neuron, 0);
        `CLOCK;
        `CLOCK;
        `SET(modify_weights, 0);
        `SET(modify_neuron, 1);
        `CLOCK;
        `CLOCK;
        //-----------------------------------------------
		// New Input
		// ----------------------------------------------
        `SHOW_MODE("INPUT");
        `SET(modify_neuron, 1);
        `SET(modify_neuron_using_input, 1);
        `SET(pattern_input, `PATTERN_INPUT_3);
        `CLOCK
        `CLOCK
        `SET(modify_neuron, 1);
        `SET(modify_neuron_using_input, 0);
        `CLOCK;
        `CLOCK;
        `CLOCK;
        `CLOCK;
        `CLOCK;
        `CLOCK;

        //-----------------------------------------------
		// New Input
		// ----------------------------------------------
        `SHOW_MODE("INPUT");
        `SET(modify_neuron, 1);
        `SET(modify_neuron_using_input, 1);
        `SET(pattern_input, `PATTERN_INPUT_4);
        `CLOCK
        `CLOCK
        `SET(modify_neuron, 1);
        `SET(modify_neuron_using_input, 0);
        `CLOCK;
        `CLOCK;
        `CLOCK;
        `CLOCK;
        `CLOCK;
        `CLOCK;



        


		$display("\nTESTS COMPLETED");
		$finish;
	end
endmodule
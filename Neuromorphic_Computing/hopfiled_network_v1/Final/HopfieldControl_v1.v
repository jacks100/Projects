
//==============================================================================
// Control Module for Simon Project
//==============================================================================
`include "defines.v"
module HopfieldControl(
	// External Inputs
	input clk,           // Clock

	// Datapath Control Inputs
	input rst,
	input same_input, // True if the same input as previous clock cycle
	input converged, // True if all neurons in same state as previous clock cycle

	// Control outputs
	output reg modify_neuron, // True if neuron state is to be modified
	output reg modify_neuron_using_input, // True if neuron state should be set to input, only happens if modify_neuron is True
	output reg modify_weights // True if weights are to be modified
	
	// External Outputs
	//output reg [2:0] state

);

	// Declare Local Vars Here
	reg [2:0] state;
	reg [2:0] next_state;

	// Output Combinational Logic
	always @( * ) begin
		// Set defaults
		// signal_one = 0; ...
		modify_neuron = 0;
		modify_neuron_using_input = 0;
		modify_weights = 0;

		// Write your output logic here
		if (state == `STATE_INPUT) begin
			modify_neuron = 1; 
			modify_neuron_using_input = 1; // override update

		end
		else if (state == `STATE_UPDATING) begin
			modify_neuron = 1; 
			modify_neuron_using_input = 0; // do not override update
		end
		else if (state == `STATE_LEARNING) begin
			modify_weights = 1;
		end
	end

	// Next State Combinational Logic
	always @( * ) begin
		// Write your Next State Logic Here
		next_state = state; // default
		case (state)
			// INPUT
			`STATE_INPUT: begin
				if (same_input) begin
					next_state = `STATE_UPDATING;
				end
			end

			// UPDATING
			`STATE_UPDATING: begin
				if (converged) begin
					next_state = `STATE_LEARNING;
				end
				else if (~same_input) begin
					next_state = `STATE_INPUT;
				end
			end

			// LEARNING
			`STATE_LEARNING: begin
				if (~same_input) begin
					next_state = `STATE_INPUT;
				end
			end
		endcase

		// DONE: stay in state unless rst
	end

	//// State Update Sequential Logic
	always @(posedge clk) begin
		if (rst) begin
			// Update state to reset state
			state <= `STATE_INPUT;
		end
		else begin
			// Update state to next state
			state <= next_state;
			//state <= STATE_INPUT;
		end
	end

endmodule

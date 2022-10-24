//==============================================================================
// Datapath for Simon Project
//==============================================================================

`include "defines.v"

module HopfieldDatapath(
	// External Inputs
	input clk, // Clock
	input rst, // RESET
	input  [`NEURON_INDEX_MAX:0] pattern_input,       // neuron input pattern

	

	//Datapath control signals
	input modify_neuron, // True if neuron state is to be modified
	input modify_neuron_using_input, // True if neuron state should be set to input, only happens if modify_neuron is True
	input modify_weights, // True if weights are to be modified
	
	// Datapath Outputs to Control
	output reg same_input, // True if the same input was present at the previous clock cycle
	output reg converged, // True if same neuron values occur at consecutive clock cycles for all neurons

	// External Outputs
	output reg [`NEURON_INDEX_MAX: 0] neuron_states // states of all neurons, should the [] go after the neuron_states

	// output reg [15: 0] weights_out // N regs where each reg has N - 1 entries


);

	// Declare Local Vars Here
	// weights and neurons
	reg [`NEURON_INDEX_MAX: 0][`NEURON_INDEX_MAX:0] weights; // N regs where each reg has N - 1 entries
	reg [`NEURON_INDEX_MAX: 0][`NEURON_INDEX_MAX:0] new_weights; // N regs where each reg has N - 1 entries
	
	reg [`NEURON_INDEX_MAX: 0] neuron_states_new; // new states of all neurons, should the [] go after the neuron_states
	reg [`NEURON_INDEX_MAX:0] pattern_input_prev;       // neuron input pattern previous timestep
	// updating
	reg [`NEURON_INDEX_MAX:0] products; // each activation multiplied by each weight
	reg [`NEURON_INDEX_MAX:0][`NEURON_INDEX_MAX:0] activation; // sum of products for a neuron

	reg [`NEURON_INDEX_MAX:0] vec;


	integer i;
	integer j;
	integer k;
	integer l;
	integer z;

	// 

	//----------------------------------------------------------------------
	// Internal Logic -- Manipulate Registers, ALU's, Memories Local to
	// the Datapath
	//----------------------------------------------------------------------
		
	
	always @(posedge clk) begin
		// Sequential Internal Logic Here
		pattern_input_prev <= pattern_input;
		activation <= 0;
		
		if (modify_weights) begin // learning
			weights <= new_weights;
			// for (z = 0; z < `NEURON_COUNT; z+=1) begin
			// 	weights[z] <= new_weights[z];
			// end
			
			// weights_out <= { << { weights}};
		end

		if (modify_neuron & ~modify_neuron_using_input) begin // updating
			neuron_states <= neuron_states_new;
		
		end

		else if (modify_neuron) begin // input
			neuron_states <= pattern_input;
		end
		if (rst) begin
		  weights <= 0;//16'b0101101001001000;
		  new_weights <= 0;
		  activation <= 0;
		end
		
	end

	

	//----------------------------------------------------------------------
	// Output Logic -- Set Datapath Outputs
	//----------------------------------------------------------------------

	always @( * ) begin
		// Output Logic Here
		same_input = (pattern_input == pattern_input_prev); // same input
		converged = (neuron_states == neuron_states_new); // True if no further updating occuring
		// Updating
		
		for (i = 0; i < `NEURON_COUNT; i+=1) begin
			products = neuron_states & weights[i];//~(neuron_states ^ weights[i]);
			// activation = 0;
			// sum the bits
			for (j = 0; j < `NEURON_COUNT; j +=1) begin
				if (i != j) begin
					activation[i] = activation[i] + products[j];
				end
			end
			//activation[i] = activation[i] - (`NEURON_COUNT - 1 - activation[i]); // do not include self neuron
			neuron_states_new[i] = (activation[i] >= `THRESHOLD_LOWER);// & activation[i] < `THRESHOLD_UPPER); // ReLu
		end
		// new weights, learning
		for (k=0; k < `NEURON_COUNT; k += 1) begin
			if (pattern_input[k] == 1) begin
				vec = 0 - 1;
			end
			else if (pattern_input[k] == 0) begin
				vec = 0;
			end
			//new_weights[k] = weights[k] | (~(pattern_input ^ vec));
			new_weights[k] = weights[k] | (pattern_input & vec);
			
		end

	end


	

endmodule

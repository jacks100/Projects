//==============================================================================
// Simon Module for Simon Project
//==============================================================================

`include "ButtonDebouncer.v"
`include "defines.v"

module HopfieldNetwork(
	input        clk,
	input  [NEURON_COUNT-1:0] pattern_input,

	output [NEURON_COUNT - 1:0] neuron_states,
);

	// Declare local connections here
	// wire localconn1; ...
	// inputs to controller (datapath outputs)
	wire same_input,
	wire converged,
	wire modify_neuron,
	wire modify_neuron_using_input,
	wire modify_weights,





	// Datapath -- Add port connections
	HopfieldDatapath dpath(
		.clk(clk),
		.pattern_input(pattern_input),
		.modify_neuron(modify_neuron),
		.modify_neuron_using_input(modify_neuron_using_input),
		.modify_weights(modify_weights),
		.same_input(same_input),
		.converged(converged),
		.neuron_states(neuron_states),
	);


	// Control -- Add port connections
	HopfieldControl ctrl(
		.clk(clk),
		.same_input(same_input),
		.converged(converged),
		.modify_neuron(modify_neuron),
		.modify_neuron_using_input(modify_neuron_using_input),
		.modify_weights(modify_weights),

	);



endmodule

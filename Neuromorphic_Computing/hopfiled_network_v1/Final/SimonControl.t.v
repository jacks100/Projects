//===============================================================================
// Testbench Module for Simon Controller
//===============================================================================
`timescale 1ns/100ps

`include "SimonControl.v"

// Print an error message (MSG) if value ONE is not equal
// to value TWO.
`define ASSERT_EQ(ONE, TWO, MSG)               \
	begin                                      \
		if ((ONE) !== (TWO)) begin             \
			$display("\t[FAILURE]:%s", (MSG)); \
		end                                    \
	end #0

// Set the variable VAR to the value VALUE, printing a notification
// to the screen indicating the variable's update.
// The setting of the variable is preceeded and followed by
// a 1-timestep delay.
`define SET(VAR, VALUE) $display("Setting %s to %s...", "VAR", "VALUE"); #1; VAR = (VALUE); #1

// Cycle the clock up and then down, simulating
// a button press.
`define CLOCK $display("Pressing uclk..."); #1; clk = 1; #1; clk = 0; #1

module SimonControlTest;

	// Local Vars
	reg clk = 0;
	reg rst = 0;
	// More vars here...
	wire counter_rst; // resets counter
	wire counter_enable; // enable counter to store new values
	wire current_rst; // reset the current register
	wire current_enable; // enable the current register to store new values
	wire level_enable; // enable the level to be changed
	wire display_choice; // choice of whether to display input pattern or pattern from register
	wire write_enable; // enable writing to pattern register

	// External Outputs
	wire [2:0] mode_leds;

	// Datapath Control Inputs
	reg pattern_valid = 0; // is the pattern valid for the level
	reg pattern_same = 0; // does the input pattern match the pattern at the specific register
	reg SeenAll = 0; // have all of the registers in use been iterated through



	// LED Light Parameters
	localparam LED_MODE_INPUT    = 3'b001;
	localparam LED_MODE_PLAYBACK = 3'b010;
	localparam LED_MODE_REPEAT   = 3'b100;
	localparam LED_MODE_DONE     = 3'b111;

	// VCD Dump
	initial begin
		$dumpfile("SimonControlTest.vcd");
		$dumpvars;
	end

	// Simon Control Module
	SimonControl ctrl(
		.clk (clk),
		.rst (rst),
		.counter_rst(counter_rst),
		.current_rst(current_rst),
		.current_enable(current_enable),
		.counter_enable(counter_enable),
		.level_enable(level_enable),
		.display_choice(display_choice),
		.write_enable(write_enable),
		.pattern_valid(pattern_valid),
		.pattern_same(pattern_same),
		.SeenAll(SeenAll),
		.mode_leds(mode_leds)

		// More ports here...
	);

	// Main Test Logic
	initial begin
		// Reset the game
		`SET(rst, 1);
		`CLOCK;
		`SET(rst, 0);

		// STATE_INPUT: 
		`ASSERT_EQ(mode_leds, LED_MODE_INPUT, "Input: Error LED_MODE_Input");	
		`ASSERT_EQ(write_enable, 1, "Input: Error write_enable");
		`ASSERT_EQ(level_enable, rst, "Input: Error level_enable");
		`ASSERT_EQ(display_choice, 0, "Input: Error display_choice");
	
		`ASSERT_EQ(current_enable, 0, "Input: Error current_enable");
		`ASSERT_EQ(current_rst, 0, "Input: Error current_rst");
		`ASSERT_EQ(current_rst, 0, "Input: Error counter_rst");

		// Stay in STATE_INPUT since clk edge not reached
		`SET(pattern_valid, 1);
		`ASSERT_EQ(mode_leds, LED_MODE_INPUT, "Input: Error LED_MODE_Input");	
		`ASSERT_EQ(write_enable, 1, "Input: Error write_enable");
		`ASSERT_EQ(level_enable, rst, "Input: Error level_enable");
		`ASSERT_EQ(display_choice, 0, "Input: Error display_choice");
	
		`ASSERT_EQ(current_enable, 0, "Input: Error current_enable");
		`ASSERT_EQ(current_rst, 0, "Input: Error current_rst");
		`ASSERT_EQ(current_rst, 0, "Input: Error counter_rst");





		// Your Test Logic Here
		// move to STATE_PLAYBACK
		`SET(pattern_valid, 1);
		`SET(SeenAll, 0);
		`CLOCK;

		`ASSERT_EQ(mode_leds, LED_MODE_PLAYBACK, "Playback: Error mode_leds");
		`ASSERT_EQ(write_enable, 0, "Playback: Error write_enable");
		`ASSERT_EQ(level_enable, rst, "Playback: Error level_enable");
		`ASSERT_EQ(counter_enable, 1, "Playback: Error counter_enable");
		`ASSERT_EQ(counter_rst, SeenAll, "Playback: Error counter_rst");
		`ASSERT_EQ(display_choice, 1, "Playback: Error display_choice")
		

	

		// stay in STATE_PLAYBACK
		`SET(SeenAll, 0);
		`CLOCK;

		`ASSERT_EQ(mode_leds, LED_MODE_PLAYBACK, "Playback: Error mode_leds");
		`ASSERT_EQ(write_enable, 0, "Playback: Error write_enable");
		`ASSERT_EQ(level_enable, rst, "Playback: Error level_enable");
		`ASSERT_EQ(counter_enable, 1, "Playback: Error counter_enable");
		`ASSERT_EQ(counter_rst, SeenAll, "Playback: Error counter_rst");
		`ASSERT_EQ(display_choice, 1, "Playback: Error display_choice");

		//  move to STATE_REPEAT
		`SET(SeenAll, 1);
		`CLOCK;

		`ASSERT_EQ(mode_leds, LED_MODE_REPEAT, "Repeat: Error mode_leds");
		`ASSERT_EQ(write_enable, 0, "Repeat: Error write_enable");
		`ASSERT_EQ(level_enable, rst, "Playback: Error level_enable");
		`ASSERT_EQ(current_enable, SeenAll, "Playback: Error current_enable");
		`ASSERT_EQ(display_choice, 1, "Playback: Error display_choice");
		`ASSERT_EQ(counter_enable, pattern_same, "Playback: Error counter_enable");
		`ASSERT_EQ(counter_rst, ~pattern_same, "Playback: Error counter_rst");
		`ASSERT_EQ(display_choice, 1, "Playback: Error display_choice");


			

		
	
		// move to STATE_DONE
		`SET(pattern_same, 0);
		`CLOCK;

		`ASSERT_EQ(mode_leds, LED_MODE_DONE, "Done: Error mode_leds");
		`ASSERT_EQ(write_enable, 0, "Done: Error write_enable");
		`ASSERT_EQ(level_enable, rst, "Done: Error level_enable");
		`ASSERT_EQ(display_choice, 1, "Done: Error display_choice");
		`ASSERT_EQ(counter_enable, 1, "Done: Error counter_enable");
		`ASSERT_EQ(counter_rst, SeenAll, "Done: Error counter_rst");
		`ASSERT_EQ(current_enable, 0, "Done: Error current_enable");
		`ASSERT_EQ(display_choice, 1, "Done: Error display_choice");

		// stay in STATE_DONE
		`CLOCK;
		`ASSERT_EQ(mode_leds, LED_MODE_DONE, "Done: Error mode_leds");
		`ASSERT_EQ(write_enable, 0, "Done: Error write_enable");
		`ASSERT_EQ(level_enable, rst, "Done: Error level_enable");
		`ASSERT_EQ(display_choice, 1, "Done: Error display_choice");
		`ASSERT_EQ(counter_enable, 1, "Done: Error counter_enable");
		`ASSERT_EQ(counter_rst, SeenAll, "Done: Error counter_rst");
		`ASSERT_EQ(current_enable, 0, "Done: Error current_enable");
		`ASSERT_EQ(display_choice, 1, "Done: Error display_choice");

		// reset and go back to STATE_INPUT
		// Reset the game
		`SET(rst, 1);
		`CLOCK;
		`SET(rst, 0);

		// STATE_INPUT: 
		`ASSERT_EQ(mode_leds, LED_MODE_INPUT, "Input: Error LED_MODE_Input");	
		`ASSERT_EQ(write_enable, 1, "Input: Error write_enable");
		`ASSERT_EQ(level_enable, rst, "Input: Error level_enable");
		`ASSERT_EQ(display_choice, 0, "Input: Error display_choice");
	
		`ASSERT_EQ(current_enable, 0, "Input: Error current_enable");
		`ASSERT_EQ(current_rst, 0, "Input: Error current_rst");
		`ASSERT_EQ(current_rst, 0, "Input: Error counter_rst");

		// stay in STATE_INPUT
		`SET(pattern_valid, 0);
		`CLOCK;
		`ASSERT_EQ(mode_leds, LED_MODE_INPUT, "Input: Error LED_MODE_Input");	
		`ASSERT_EQ(write_enable, 1, "Input: Error write_enable");
		`ASSERT_EQ(level_enable, rst, "Input: Error level_enable");
		`ASSERT_EQ(display_choice, 0, "Input: Error display_choice");
	
		`ASSERT_EQ(current_enable, 0, "Input: Error current_enable");
		`ASSERT_EQ(current_rst, 0, "Input: Error current_rst");
		`ASSERT_EQ(current_rst, 0, "Input: Error counter_rst");

		
		// move to STATE_PLAYBACK
		`SET(pattern_valid, 1);
		`SET(SeenAll, 0);
		`CLOCK;

		`ASSERT_EQ(mode_leds, LED_MODE_PLAYBACK, "Playback: Error mode_leds");
		`ASSERT_EQ(write_enable, 0, "Playback: Error write_enable");
		`ASSERT_EQ(level_enable, rst, "Playback: Error level_enable");
		`ASSERT_EQ(counter_enable, 1, "Playback: Error counter_enable");
		`ASSERT_EQ(counter_rst, SeenAll, "Playback: Error counter_rst");
		`ASSERT_EQ(display_choice, 1, "Playback: Error display_choice");

		//  move to STATE_REPEAT
		`SET(SeenAll, 1);
		`CLOCK;

		`ASSERT_EQ(mode_leds, LED_MODE_REPEAT, "Repeat: Error mode_leds");
		`ASSERT_EQ(write_enable, 0, "Repeat: Error write_enable");
		`ASSERT_EQ(level_enable, rst, "Playback: Error level_enable");
		`ASSERT_EQ(current_enable, SeenAll, "Playback: Error current_enable");
		`ASSERT_EQ(display_choice, 1, "Playback: Error display_choice");
		`ASSERT_EQ(counter_enable, pattern_same, "Playback: Error counter_enable");
		`ASSERT_EQ(counter_rst, ~pattern_same, "Playback: Error counter_rst");
		`ASSERT_EQ(display_choice, 1, "Playback: Error display_choice");

		// stay in STATE_REPEAT
		`SET(pattern_same,1);
		`SET(SeenAll, 0);
		`CLOCK;

		`ASSERT_EQ(mode_leds, LED_MODE_REPEAT, "Repeat: Error mode_leds");
		`ASSERT_EQ(write_enable, 0, "Repeat: Error write_enable");
		`ASSERT_EQ(level_enable, rst, "Playback: Error level_enable");
		`ASSERT_EQ(current_enable, SeenAll, "Playback: Error current_enable");
		`ASSERT_EQ(display_choice, 1, "Playback: Error display_choice");
		`ASSERT_EQ(counter_enable, pattern_same, "Playback: Error counter_enable");
		`ASSERT_EQ(counter_rst, ~pattern_same, "Playback: Error counter_rst");
		`ASSERT_EQ(display_choice, 1, "Playback: Error display_choice");

		// move to STATE_INPUT
		`SET(pattern_same,1);
		`SET(SeenAll, 1);
		`CLOCK;

		`ASSERT_EQ(mode_leds, LED_MODE_INPUT, "Input: Error LED_MODE_Input");	
		`ASSERT_EQ(write_enable, 1, "Input: Error write_enable");
		`ASSERT_EQ(level_enable, rst, "Input: Error level_enable");
		`ASSERT_EQ(display_choice, 0, "Input: Error display_choice");
	
		`ASSERT_EQ(current_enable, 0, "Input: Error current_enable");
		`ASSERT_EQ(current_rst, 0, "Input: Error current_rst");
		`ASSERT_EQ(current_rst, 0, "Input: Error counter_rst");





		




		



		$finish;
	end

endmodule

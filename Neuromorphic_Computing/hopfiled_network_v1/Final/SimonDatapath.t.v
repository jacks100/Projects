//===============================================================================
// Testbench Module for Simon Datapath
//===============================================================================
`timescale 1ns/100ps

`include "SimonDatapath.v"

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

module SimonDatapathTest;

	// Local Vars
	reg clk;
	reg level;
	reg [3:0] pattern;

	wire [3:0] pattern_leds;
	reg rst; // reset for Pattern_reg
	
	wire pattern_valid; // 
	wire pattern_same; //
	reg display_choice; // check
	reg counter_rst; // 
	
	reg current_rst; // check
	reg counter_enable;  // check
	reg current_enable; // check
	reg write_enable; // able to write to pattern register
	reg level_enable; //
	wire SeenAll; // equality comparator between counter and current_index

	
	// More vars here...

	// LED Light Parameters
	localparam LED_MODE_INPUT    = 3'b001;
	localparam LED_MODE_PLAYBACK = 3'b010;
	localparam LED_MODE_REPEAT   = 3'b100;
	localparam LED_MODE_DONE     = 3'b111;

	// VCD Dump
	integer idx;
	initial begin
		$dumpfile("SimonDatapathTest.vcd");
		$dumpvars;
		for (idx = 0; idx < 64; idx = idx + 1) begin
			$dumpvars(0, dpath.mem.mem[idx]);
		end
	end

	// Simon Control Module
	SimonDatapath dpath(
		.clk     (clk),
		.level   (level),
		.pattern (pattern),
		.display_choice (display_choice),
		.current_rst (current_rst),
		.counter_rst (counter_rst),
		.counter_enable (counter_enable),
		.current_enable (current_enable), 
		.pattern_same (pattern_same),
		.pattern_valid (pattern_valid),
		.level_enable (level_enable),
		.pattern_leds (pattern_leds),
		.write_enable(write_enable),
		.SeenAll(SeenAll),
		.rst (rst)
	);

	always begin 
	#1 clk = ~clk;
	end
	
	
	// Main Test Logic
	// POSSIBLE ERROR --> the way i treat the clock edge and pclk
	initial begin
	    `SET(clk,0);
		
		// ***************RESET_STAGE***************************
		`SET(rst,1);
		`SET(counter_rst,1); 
		`SET(current_rst,1); // COMBINE INTO ONE RESET

		#10;
		`SET(rst,0);
		`SET(counter_rst,0); 
		`SET(current_rst,0); 

		//******************************************************
		
		// // TEST LEVEL WORKS and LEVEL CANNOT CHANGE after
		// `SET(level_enable,1); // enable data writing

		// #10;

		// `SET(level,1); 
		// #10; 
		// `SET(level_enable,0); 
		// #
	
		// #10;
		// `SET(counter_enable,1);
		// `SET(current_enable,1);
		// `ASSERT_EQ(level_enable, 0, "level"); // test that level_reg cannot write
		// `SET(level,0); // attempt to change level
		// #10; 
		


		// // TEST THAT THE pattern_valid works as describes
		// `SET(pattern,0110); 
	 	// #10;
		
		// `ASSERT_EQ(pattern_valid, 1, "pattern_valid"); 
		// #1;

		// `SET(pattern,0110); 
		// #10;
		// `SET(pattern,0010); 
		// #1;
	
    	`ASSERT_EQ(pattern_same, 0, "pattern_same");

		// ***************RESET_STAGE***************************
		`SET(rst,1);
		`SET(counter_rst,1); 
		`SET(current_rst,1); // COMBINE INTO ONE RESET

		#10;
		`SET(rst,0);
		`SET(counter_rst,0); 
		`SET(current_rst,0); 

		//******************************************************


		
		`SET(write_enable,1);
		`SET(current_enable,1);
		`SET(counter_enable,1);
		#1;
		`SET(pattern,0010); 
		`SET(counter_enable,0);
		#1;
		`SET(pattern,0100); 
		#1;
		`SET(current_enable,0);
		`SET(write_enable,0);
		#1;

		`SET(display_choice,1); // test display choice 1...should show pattern

		`ASSERT_EQ(pattern_leds, pattern, "show pattern"); // correct

		
		`SET(display_choice,0); // test display choice 0..... should show previous pattern
		#10;

		`ASSERT_EQ(pattern_leds, 0010, "show previous pattern");
		





	
	 
		
		// ***************************TEST********************************
	
		

	// #1; 
	// $display("\nBegin Testing");

	// pattern = 2; #1 // set pattern to two 
	// ASSERT_EQ(pattern_valid, 1, "pattern valid");

		$finish;
	end

endmodule

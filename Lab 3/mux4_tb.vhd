----------------------------------------------------------------------------------
-- Filename : mux_tb.vhdl
-- Author : Antonio Alejandro Andara Lara
-- Date : 31-Oct-2023
-- Design Name: mux_tb
-- Project Name: ECE 410 lab 3 2023
-- Description : testbench for the multiplexer of the simple CPU design
-- Revision 1.01 - File Modified by Antonio Andara (October 28, 2024)
-- Additional Comments:
-- Lab memebers: Amanvir Dhanoa and Zhiyuan Li
-- Copyright : University of Alberta, 2023
-- License : CC0 1.0 Universal
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux4_tb IS
END mux4_tb;

ARCHITECTURE sim OF mux4_tb IS

    SIGNAL alu0_out       : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL rf0_out        : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL immediate_data : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL user_input     : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL mux_sel        : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
    SIGNAL mux4_out        : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

    uut : ENTITY WORK.mux4(Dataflow)
        PORT MAP( alu0_out       => alu0_out,
                  rf0_out        => rf0_out,
                  immediate_data => immediate_data,
                  user_input     => user_input,
                  mux_sel        => mux_sel,
                  mux4_out        => mux4_out
                );

    stimulus : PROCESS
    BEGIN
        -- Setup test data for all inputs
        alu0_out       <= "1010101010101010";
        rf0_out        <= "1100110011001100";
        immediate_data <= "1111000011110000";
        user_input     <= "0000111100001111";

        -- Test Case 1: Select immediate_data_data (mux_sel = "00")
        mux_sel <= "00";
        WAIT FOR 50 ns;
        ASSERT (mux4_out = alu0_out )
        REPORT "Mismatch for mux_sel = 00 (immediate_data)!" SEVERITY ERROR;

        -- Test Case 2: Select user_input (mux_sel = "01")
        mux_sel <= "01";
        WAIT FOR 50 ns;
        ASSERT (mux4_out = rf0_out )
        REPORT "Mismatch for mux_sel = 01 (user_input)!" SEVERITY ERROR;

        -- Test Case 3: Select rf0_out (mux_sel = "10")
        mux_sel <= "10";
        WAIT FOR 50 ns;
        ASSERT (mux4_out = immediate_data)
        REPORT "Mismatch for mux_sel = 10 (rf0_out)!" SEVERITY ERROR;

        -- Test Case 4: Select alu0_out (mux_sel = "11")
        mux_sel <= "11";
        WAIT FOR 50 ns;
        ASSERT (mux4_out = user_input)
        REPORT "Mismatch for mux_sel = 11 (alu0_out)!" SEVERITY ERROR;

        -- End of test cases
        WAIT;
    END PROCESS stimulus;

END sim;

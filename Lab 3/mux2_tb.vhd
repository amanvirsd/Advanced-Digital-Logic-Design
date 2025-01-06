----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Shyama Gandhi, Bruce Cockburn
-- Lab Members: Amanvir Dhanoa and Zhiyuan Li
-- 
-- Create Date   : 10/29/2020 07:18:24 PM
-- Module Name   : mux2_tb - Behavioral
-- Project Name  : CPU_LAB 3 - ECE 410
-- Target Device : FPGA
-- Tool Versions : Xilinx Vivado
-- Description   : Testbench for verifying the 2-to-1 multiplexer (mux2) functionality.
-- 
-- Additional Comments:
-- - The testbench checks the correct output of the multiplexer for various select signal configurations.
----------------------------------------------------------------------------------


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux2_tb IS
END mux2_tb;

ARCHITECTURE sim OF mux2_tb IS

    SIGNAL mux_sel : STD_LOGIC := '0';
    SIGNAL in0     : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL in1     : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL mux_out : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

    uut : ENTITY WORK.mux2(Dataflow)
        PORT MAP( mux_sel => mux_sel,
                  in0     => in0,
                  in1     => in1,
                  mux_out => mux_out
                );

    stimulus : PROCESS
    BEGIN
        -- Setup test data for in0 and in1
        in0 <= "1010101010101010";
        in1 <= "1100110011001100";

        -- Test Case 1: Select in0 (mux_sel = '0')
        mux_sel <= '0';
        WAIT FOR 50 ns;
        ASSERT (mux_out = in0)
        REPORT "Mismatch for mux_sel = '0' (in0 selected)!" SEVERITY ERROR;

        -- Test Case 2: Select in1 (mux_sel = '1')
        mux_sel <= '1';
        WAIT FOR 50 ns;
        ASSERT (mux_out = in1)
        REPORT "Mismatch for mux_sel = '1' (in1 selected)!" SEVERITY ERROR;

        -- End of test cases
        WAIT;
    END PROCESS stimulus;

END sim;



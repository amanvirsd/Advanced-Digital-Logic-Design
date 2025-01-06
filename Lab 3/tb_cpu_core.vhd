----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Lab Members: Amanvir Dhanoa and Zhiyuan Li
-- 
-- Create Date   : 11/10/2024 06:40:45 PM
-- Module Name   : cpu_core_tb - Behavioral
-- Project Name  : CPU_LAB 3 - ECE 410
-- Target Device : FPGA
-- Tool Versions : Xilinx Vivado 2023.2
-- Description   : Testbench for verifying the CPU core design, including the controller
--                 and datapath integration.
-- 
-- Revision History:

-- Additional Comments:
----------------------------------------------------------------------------------


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY cpu_core_tb IS
END cpu_core_tb;

ARCHITECTURE behavior OF cpu_core_tb IS

    SIGNAL clock          : STD_LOGIC := '0';
    SIGNAL reset          : STD_LOGIC := '0';
    SIGNAL user_input     : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL OPCODE_output  : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL PC_output      : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL CPU_output     : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL enter          : STD_LOGIC;
    SIGNAL done           : STD_LOGIC;

 
    CONSTANT clock_period : TIME := 8 ns;

BEGIN
   
    UUT : ENTITY WORK.cpu_core(Structural)
    PORT MAP(clock => clock,
             reset => reset,
             user_input => user_input,
             OPCODE_output => OPCODE_output,
             PC_output => PC_output,
             CPU_output => CPU_output,
             enter => enter,
             done => done);

    clock_process : PROCESS
    BEGIN
        clock <= '0';
        WAIT FOR clock_period/2;
        clock <= '1';
        WAIT FOR clock_period/2;
    END PROCESS;

    -- Stimulus process
    stim_proc : PROCESS
    BEGIN
        reset <= '1';
        WAIT FOR 10 ns;
        reset <= '0';
   
        enter <= '1';
        WAIT FOR 10ns;
        user_input <= "0000000000000010";
        
        
        
        WAIT;
    END PROCESS;

END behavior;

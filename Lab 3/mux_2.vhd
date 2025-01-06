----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Antonio Andara Lara, Shyama Gandhi and Bruce Cockburn
-- Create Date: 10/29/2020 07:18:24 PM
-- Module Name: cpu - structural(datapath)
-- Description: CPU LAB 3 - ECE 410 (2021)
-- Revision:
-- Revision 0.01 - File Created
-- Revision 1.01 - File Modified by Shyama Gandhi (Nov 2, 2021)
-- Revision 3.01 - File Modified by Antonio Andara (October 31, 2023)
-- Revision 4.01 - File Modified by Antonio Andara (October 28, 2024)
-- Additional Comments:
-- Lab memebers: Amanvir Dhanoa and Zhiyuan Li
--*********************************************************************************
--THIS IS A 2x1 MUX that selects between two inputs.
-----------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux2 IS
    PORT( mux_sel  : IN STD_LOGIC;
          in0      : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
          in1      : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
          mux_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
END mux2;

ARCHITECTURE Dataflow OF mux2 IS
    SIGNAL in0_s, in1_s : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
    -- Assign the input ports to internal signals
    in0_s <= in0;
    in1_s <= in1;

    -- Use internal signals for the mux output selection
    WITH mux_sel SELECT
        mux_out <= in0_s WHEN '0',
                   in1_s WHEN '1',
                   (OTHERS => '0') WHEN OTHERS;
END Dataflow;


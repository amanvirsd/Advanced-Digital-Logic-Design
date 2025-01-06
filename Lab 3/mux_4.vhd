----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Shyama Gandhi and Bruce Cockburn
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
--THIS IS A 4x1 MUX that selects between the four inputs as shown in the lab manual.
-----------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux4 IS
    PORT( alu0_out      : IN STD_LOGIC_VECTOR(15 DOWNTO 0)
        ; rf0_out      : IN STD_LOGIC_VECTOR(15 DOWNTO 0)
        ; immediate_data    : IN STD_LOGIC_VECTOR(15 DOWNTO 0)
        ; user_input      : IN STD_LOGIC_VECTOR(15 DOWNTO 0)
        ; mux_sel  : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
        ; mux4_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
END mux4;

architecture Dataflow of mux4 is
begin
     WITH mux_sel SELECT
        mux4_out <= alu0_out WHEN "00",
                    rf0_out  WHEN "01",
                   immediate_data WHEN "10",
                   user_input WHEN "11",
                   (OTHERS=> '0') WHEN OTHERS;
end Dataflow;


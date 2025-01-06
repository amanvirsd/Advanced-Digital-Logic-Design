----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Shyama Gandhi and Bruce Cockburn
-- Create Date: 10/29/2020 07:18:24 PM
-- Module Name: cpu - structural(datapath)
-- Description: CPU_LAB 3 - ECE 410 (2021)
-- Revision:
-- Revision 0.01 - File Created
-- Revision 2.01 - File Modified by Shyama Gandhi (November 2, 2021)
-- Revision 3.01 - File Modified by Antonio Andara (October 31, 2023)
-- Revision 4.01 - File Modified by Antonio Andara (October 28, 2024)
-- Additional Comments:
-- Lab memebers: Amanvir Dhanoa and Zhiyuan Li
--*********************************************************************************
-- When the enable line is asserted, the output from the accumulator will be stored in the buffer.
-- The value stored in the output buffer will the output of this CPU. 
-----------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tri_state_buffer is
    port(
        output_en     : in std_logic;
        buffer_in  : in std_logic_vector(15 downto 0);
        buffer_out : out std_logic_vector(15 downto 0)
    );
end tri_state_buffer;


architecture Behavioral of tri_state_buffer is

begin
with output_en select 
    buffer_out <= buffer_in when '1', (others => 'Z') when others;
end Behavioral;

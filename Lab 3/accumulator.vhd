----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Shyama Gandhi and Bruce Cockburn
-- Create Date: 10/29/2020 07:18:24 PM
-- Module Name: cpu - structural(datapath)
-- Description: CPU LAB 3 - ECE 410 (2023)
-- Revision:
-- Revision 0.01 - File Created
-- Revision 1.01 - File Modified by Raju Machupalli (October 31, 2021)
-- Revision 2.01 - File Modified by Shyama Gandhi (November 2, 2021)
-- Revision 3.01 - File Modified by Antonio Andara (October 31, 2023)
-- Revision 4.01 - File Modified by Antonio Andara (October 28, 2024)
-- Additional Comments: in order to write to the accumulator acc_write
-- must be set to high, writing of the accumulator only occurs during
-- the rising edge of the clock
-- Lab memebers: Amanvir Dhanoa and Zhiyuan Li
--*********************************************************************************
-- 16-bit accumulator register as shown in the datapath of lab manual
-----------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY accumulator IS
    PORT(
        clock     : IN  std_logic;
        reset     : IN  std_logic;
        acc_in   : IN  std_logic_vector(15 DOWNTO 0);
        acc_write  : IN  std_logic;
        acc_out  : OUT std_logic_vector(15 DOWNTO 0);
        zero_flag : OUT std_logic;
        sign_flag : OUT std_logic
    );
END accumulator;

ARCHITECTURE Behavioral OF accumulator IS
    SIGNAL acc_value : std_logic_vector(15 DOWNTO 0) := (OTHERS => '0');
BEGIN
    PROCESS(clock, reset)
    BEGIN
        IF reset = '1' THEN
            acc_value <= (OTHERS => '0');
            zero_flag <= '0';
            sign_flag <= '0';
        ELSIF rising_edge(clock) THEN
            IF acc_write = '1' THEN
                acc_value <= acc_in;
                IF acc_in = "0000000000000000" THEN
                    zero_flag <= '1';
                ELSE
                    zero_flag <= '0';
                END IF;
                sign_flag <= acc_in(15); -- MSB as sign bit
            END IF;
        END IF;
    END PROCESS;
    acc_out <= acc_value;
END Behavioral;

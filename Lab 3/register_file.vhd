----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Antonio Andara Lara, Shyama Gandhi and Bruce Cockburn
-- Create Date: 10/29/2020 07:18:24 PM
-- Module Name: register file
-- Description: CPU LAB 3 - ECE 410 (2021)
-- Revision:
-- Revision 0.01 - File Created
-- Revision 1.01 - File Modified by Raju Machupalli (October 31, 2021)
-- Revision 2.01 - File Modified by Shyama Gandhi (November 2, 2021)
-- Revision 3.01 - File Modified by Antonio Andara (October 31, 2023)
-- Revision 4.01 - File Modified by Antonio Andara (October 28, 2024)
-- Additional Comments:
-- Lab memebers: Amanvir Dhanoa and Zhiyuan Li
--*********************************************************************************
-- This register_file design provides an 8-location memory array, where each location is 16-bits wide. 
-- The `rf_address` lines select one of the eight registers, R[0] through R[7], and the `rf_write` 
-- signal enables writing data to the selected register. 
-- 
-- The `mode` input determines the access mode:
--   - When `mode = '0'`, the register file operates in "single access mode," where only one register 
--     (selected by `rf_address`) can be written to or read at a time.
--   - When `mode = '1'`, the design allows "dual access mode," enabling simultaneous read or write 
--     operations on two registers. Specifically, the address given by `rf_address` is interpreted to 
--     access paired registers, such that data can be written to or read from the selected register 
--     and another register offset by +/- 4. This feature enables simultaneous access to two registers 

-- Constraints:
--   - Only one type of operation (read or write) is performed per clock cycle, governed by the `rf_write` signal.
--   - Address conflicts between `rf0` and `rf1` in dual mode are prevented by restricting access to complementary register pairs.
-- Lab memebers: Amanvir Dhanoa and Zhiyuan Li
--*********************************************************************************
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
    port (
        clock      : in std_logic;
        rf_write   : in std_logic;
        rf_mode    : in std_logic;
        rf_address : in std_logic_vector(2 downto 0);
        rf0_in     : in std_logic_vector(15 downto 0);
        rf1_in     : in std_logic_vector(15 downto 0);
        rf0_out    : out std_logic_vector(15 downto 0);
        rf1_out    : out std_logic_vector(15 downto 0)
    );
end register_file;

architecture Behavioral of register_file is
    type register_array is array(0 to 7) of std_logic_vector(15 downto 0);
    signal registers : register_array := (others => (others => '0'));
begin
    process (clock)
        variable addr      : integer;
        variable addr_pair : integer;
    begin
        if rising_edge(clock) then
            addr := to_integer(unsigned(rf_address));

            -- Calculate addr_pair by checking the most significant bit (bit 2) of rf_address
            if rf_address(2) = '0' then
                addr_pair := addr + 4;
            else
                addr_pair := addr - 4;
            end if;

            -- Write operation
            if rf_write = '1' then
                if rf_mode = '0' then  -- Single Access Mode
                    registers(addr) <= rf0_in;
                elsif rf_mode = '1' then  -- Dual Access Mode
                    registers(addr) <= rf1_in;
                    registers(addr_pair) <= rf0_in;
                end if;
            end if;

            -- Read operation
            if rf_mode = '0' then  -- Single Access Mode
                rf0_out <= registers(addr);
                rf1_out <= (others => '0');
            elsif rf_mode = '1' then  -- Dual Access Mode
                rf0_out <= registers(addr);
                rf1_out <= registers(addr_pair);
            end if;
        end if;
    end process;
end Behavioral;


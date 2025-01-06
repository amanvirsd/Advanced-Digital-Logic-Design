----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/23/2024 03:04:41 PM
-- Design Name: 
-- Module Name: ASCII_decryptor - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------



-- decryption block 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Entity for XOR decryption block
entity xor_decrypt is
    Port (
        encrypted_data : in  STD_LOGIC_VECTOR (7 downto 0); -- 8-bit ASCII data
        key_in  : in  STD_LOGIC_VECTOR (7 downto 0); -- 8-bit encryption key
        decrypted_data : out STD_LOGIC_VECTOR (7 downto 0) -- 8-bit decrypted data
    );
end xor_decrypt;

-- Architecture for XOR decryption
architecture Behavioral of xor_decrypt is
begin
    -- Perform XOR operation again to retrieve the original data
    decrypted_data <= encrypted_data XOR key_in;
end Behavioral;
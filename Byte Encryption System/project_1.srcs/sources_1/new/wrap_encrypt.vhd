----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/02/2024 01:09:25 PM
-- Design Name: 
-- Module Name: wrap_encrypt - Behavioral
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_encrypt_decrypt is
    port (data_in, key: in  STD_LOGIC_VECTOR (7 downto 0); 
    final_output : out STD_LOGIC_VECTOR (7 downto 0));
end test_encrypt_decrypt;

architecture behavioral of test_encrypt_decrypt is
    component xor_encrypt
    port (data_in, key_in: in STD_LOGIC_VECTOR (7 downto 0);  
    data_out : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

    component xor_decrypt
    port (encrypted_data, key_in: in STD_LOGIC_VECTOR (7 downto 0);
    decrypted_data : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

    signal intermediate: STD_LOGIC_VECTOR (7 downto 0);
    
begin
    -- Instantiate the XOR Encryption Component
    e_out: xor_encrypt 
        port map (
            data_in  => data_in,         -- Input data
            key_in   => key,             -- Encryption key
            data_out => intermediate     -- Encrypted output (to be passed to decryption)
        );

    -- Instantiate the XOR Decryption Component
    d_out: xor_decrypt 
        port map (
            encrypted_data => intermediate, -- Encrypted data from the encryptor
            key_in         => key,          -- Same encryption key for decryption
            decrypted_data => final_output  -- Final decrypted output
        );

end behavioral;
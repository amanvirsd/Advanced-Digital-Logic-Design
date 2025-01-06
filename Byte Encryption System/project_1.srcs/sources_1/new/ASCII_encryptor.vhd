library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Entity for XOR encryption block
entity xor_encrypt is
    Port (
        data_in : in  STD_LOGIC_VECTOR (7 downto 0); -- 8-bit ASCII data
        key_in  : in  STD_LOGIC_VECTOR (7 downto 0); -- 8-bit encryption key
        data_out : out STD_LOGIC_VECTOR (7 downto 0) -- 8-bit encrypted data
    );
end xor_encrypt;

-- Architecture for XOR encryption
architecture Behavioral of xor_encrypt is
begin
    -- Perform XOR operation on each bit
    data_out <= data_in XOR key_in;
end Behavioral;

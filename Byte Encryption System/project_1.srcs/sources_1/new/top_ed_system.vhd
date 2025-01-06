library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity encryption_system is
    Port ( 
        ascii_in : in STD_LOGIC_VECTOR (7 downto 0);
        led_out : out STD_LOGIC_VECTOR (2 downto 0);
        final_output : out STD_LOGIC_VECTOR (7 downto 0)
    );
end encryption_system;

architecture Structural of encryption_system is

    component ascii_comparator is
        Port (
            ascii_in : in STD_LOGIC_VECTOR (7 downto 0);
            ascii_out : out STD_LOGIC_VECTOR (7 downto 0);
            led_out : out STD_LOGIC_VECTOR (2 downto 0)
        );
    end component;

    component barrel_shifter is
        Port (
            data_in : in STD_LOGIC_VECTOR (7 downto 0);
            shift_amount : in STD_LOGIC_VECTOR (2 downto 0);
            shift_direction : in STD_LOGIC;
            data_out : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    component xor_encrypt is
        Port (
            data_in : in STD_LOGIC_VECTOR (7 downto 0);
            key_in : in STD_LOGIC_VECTOR (7 downto 0);
            data_out : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    component xor_decrypt is
        Port (
            encrypted_data : in STD_LOGIC_VECTOR (7 downto 0);
            key_in : in STD_LOGIC_VECTOR (7 downto 0);
            decrypted_data : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    component case_converter is
        Port (
            data_in : in STD_LOGIC_VECTOR (7 downto 0);
            data_out : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    signal key : STD_LOGIC_VECTOR (7 downto 0) := "10101100";  -- Predefined key value
    signal shift_direction : STD_LOGIC := '0';  -- Predefined shift direction
    signal valid_ascii, shifted_pre_encrypt, encrypted, decrypted, shifted_post_decrypt : STD_LOGIC_VECTOR (7 downto 0);
    signal reverse_shift_direction : STD_LOGIC;

begin

    -- Compute reverse shift direction
    reverse_shift_direction <= not shift_direction;

    comparator: ascii_comparator
        port map (
            ascii_in => ascii_in,
            ascii_out => valid_ascii,
            led_out => led_out
        );

    pre_encrypt_shift: barrel_shifter
        port map (
            data_in => valid_ascii,
            shift_amount => key(2 downto 0),  -- Use the 3 LSBs of the key as shift amount
            shift_direction => shift_direction,
            data_out => shifted_pre_encrypt
        );

    encryptor: xor_encrypt
        port map (
            data_in => shifted_pre_encrypt, 
            key_in => key,
            data_out => encrypted
        );

    decryptor: xor_decrypt
        port map (
            encrypted_data => encrypted,
            key_in => key,
            decrypted_data => decrypted
        );

    post_decrypt_shift: barrel_shifter
        port map (
            data_in => decrypted,
            shift_amount => key(2 downto 0),  -- Use the same 3 LSBs of the key for reverse shift
            shift_direction => reverse_shift_direction,  -- Use reverse shift direction
            data_out => shifted_post_decrypt
        );

    converter: case_converter
        port map (
            data_in => shifted_post_decrypt,
            data_out => final_output
        );
        
end Structural;
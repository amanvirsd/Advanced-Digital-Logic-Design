LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Testbench entity for the test_encrypt_decrypt system
ENTITY encryption_system IS
END ENTITY encryption_system;

ARCHITECTURE behavior OF encryption_system IS

    -- Signal declarations for connecting to the test_encrypt_decrypt entity
    SIGNAL data_in      : STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL key          : STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL final_output : STD_LOGIC_VECTOR(7 downto 0);

    -- Instantiate the Unit Under Test (UUT)
    COMPONENT test_encrypt_decrypt
        PORT (
            data_in      : in  STD_LOGIC_VECTOR(7 downto 0);
            key          : in  STD_LOGIC_VECTOR(7 downto 0);
            final_output : out STD_LOGIC_VECTOR(7 downto 0)
        );
    END COMPONENT;

BEGIN

    -- Instantiate the test_encrypt_decrypt module (UUT)
    uut: test_encrypt_decrypt
        PORT MAP (
            data_in      => data_in,
            key          => key,
            final_output => final_output
        );

    -- Test process
    process
    begin
        -- Test Case 1: ASCII 'A' and encryption key 10101010
        data_in <= "01000001";  -- ASCII 'A'
        key <= "10101010";      -- Encryption key
        WAIT FOR 10 ns;
        
        -- Check if the decrypted output matches the original input
        assert (final_output = data_in)
        report "Test Case 1 Failed" severity error;

        -- Test Case 2: ASCII 'Z' and encryption key 11001100
        data_in <= "01011010";  -- ASCII 'Z'
        key <= "11001100";      -- Encryption key
        WAIT FOR 10 ns;

        -- Check if the decrypted output matches the original input
        assert (final_output = data_in)
        report "Test Case 2 Failed" severity error;

        -- Test Case 3: Special character '!' and encryption key 00111100
        data_in <= "00100001";  -- ASCII '!'
        key <= "00111100";      -- Encryption key
        WAIT FOR 10 ns;

        -- Check if the decrypted output matches the original input
        assert (final_output = data_in)
        report "Test Case 3 Failed" severity error;

        -- Test Case 4: ASCII '9' and encryption key 11110000
        data_in <= "00111001";  -- ASCII '9'
        key <= "11110000";      -- Encryption key
        WAIT FOR 10 ns;

        -- Check if the decrypted output matches the original input
        assert (final_output = data_in)
        report "Test Case 4 Failed" severity error;

        -- Test Case 5: Edge case: All zeros for input and key
        data_in <= "00000000";  -- All zeros
        key <= "00000000";      -- All zeros key
        WAIT FOR 10 ns;

        -- Check if the decrypted output matches the original input
        assert (final_output = data_in)
        report "Test Case 5 Failed" severity error;

        -- Test Case 6: Edge case: All ones for input and key
        data_in <= "11111111";  -- All ones
        key <= "11111111";      -- All ones key
        WAIT FOR 10 ns;

        -- Check if the decrypted output matches the original input
        assert (final_output = data_in)
        report "Test Case 6 Failed" severity error;

        -- Simulation end
        report "Simulation completed successfully" severity note;
        WAIT;
    end process;

END ARCHITECTURE behavior;
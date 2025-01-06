library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_encrypt_decrypt_tb is
end test_encrypt_decrypt_tb;

architecture Behavioral of test_encrypt_decrypt_tb is
    -- Component declaration for test_encrypt_decrypt
    component test_encrypt_decrypt is
        port (
            data_in, key : in STD_LOGIC_VECTOR (7 downto 0);
            final_output : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    -- Signals for input and output
    signal data_in : STD_LOGIC_VECTOR (7 downto 0);
    signal key : STD_LOGIC_VECTOR (7 downto 0);
    signal final_output : STD_LOGIC_VECTOR (7 downto 0);

begin
    -- Instantiate the test_encrypt_decrypt unit under test (UUT)
    uut: test_encrypt_decrypt
        port map (
            data_in => data_in,
            key => key,
            final_output => final_output
        );

    -- Test process
    stim_proc: process
    begin
        -- Test Case 1: Simple data and key
        data_in <= X"55";  -- Input data: 0101 0101
        key <= X"AA";      -- Key: 1010 1010
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 1 failed: data_in = X""55"", key = X""AA"""
        severity error;

        -- Test Case 2: Data with all 0's, key with all 1's
        data_in <= X"00";  -- Input data: 0000 0000
        key <= X"FF";      -- Key: 1111 1111
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 2 failed: data_in = X""00"", key = X""FF"""
        severity error;

        -- Test Case 3: Data with all 1's, key with alternating bits
        data_in <= X"FF";  -- Input data: 1111 1111
        key <= X"55";      -- Key: 0101 0101
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 3 failed: data_in = X""FF"", key = X""55"""
        severity error;

        -- Test Case 4: Alternating data and key bits
        data_in <= X"AA";  -- Input data: 1010 1010
        key <= X"55";      -- Key: 0101 0101
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 4 failed: data_in = X""AA"", key = X""55"""
        severity error;

        -- Test Case 5: Random data and key values
        data_in <= X"3C";  -- Input data: 0011 1100
        key <= X"F0";      -- Key: 1111 0000
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 5 failed: data_in = X""3C"", key = X""F0"""
        severity error;

        -- Test Case 6: Another random data and key
        data_in <= X"7E";  -- Input data: 0111 1110
        key <= X"1F";      -- Key: 0001 1111
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 6 failed: data_in = X""7E"", key = X""1F"""
        severity error;

        -- Test Case 7: All 1's in data and key
        data_in <= X"FF";  -- Input data: 1111 1111
        key <= X"FF";      -- Key: 1111 1111
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 7 failed: data_in = X""FF"", key = X""FF"""
        severity error;

        -- Test Case 8: Data all 1's, key all 0's
        data_in <= X"FF";  -- Input data: 1111 1111
        key <= X"00";      -- Key: 0000 0000
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 8 failed: data_in = X""FF"", key = X""00"""
        severity error;

        -- Test Case 9: Data all 0's, key all 0's
        data_in <= X"00";  -- Input data: 0000 0000
        key <= X"00";      -- Key: 0000 0000
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 9 failed: data_in = X""00"", key = X""00"""
        severity error;

        -- Test Case 10: Random data and key
        data_in <= X"A5";  -- Input data: 1010 0101
        key <= X"5A";      -- Key: 0101 1010
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 10 failed: data_in = X""A5"", key = X""5A"""
        severity error;

        -- Test Case 11: Data with even bits set
        data_in <= X"AA";  -- Input data: 1010 1010
        key <= X"CC";      -- Key: 1100 1100
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 11 failed: data_in = X""AA"", key = X""CC"""
        severity error;

        -- Test Case 12: Key with all 1's in upper nibble
        data_in <= X"12";  -- Input data: 0001 0010
        key <= X"F0";      -- Key: 1111 0000
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 12 failed: data_in = X""12"", key = X""F0"""
        severity error;

        -- Test Case 13: Data and key both with alternating 1's and 0's
        data_in <= X"55";  -- Input data: 0101 0101
        key <= X"AA";      -- Key: 1010 1010
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 13 failed: data_in = X""55"", key = X""AA"""
        severity error;

        -- Test Case 14: Random data and key values
        data_in <= X"37";  -- Input data: 0011 0111
        key <= X"89";      -- Key: 1000 1001
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 14 failed: data_in = X""37"", key = X""89"""
        severity error;

        -- Test Case 15: Data and key swapped between tests
        data_in <= X"89";  -- Input data: 1000 1001
        key <= X"37";      -- Key: 0011 0111
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 15 failed: data_in = X""89"", key = X""37"""
        severity error;

        -- Test Case 16: Random data and key
        data_in <= X"6D";  -- Input data: 0110 1101
        key <= X"B2";      -- Key: 1011 0010
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 16 failed: data_in = X""6D"", key = X""B2"""
        severity error;

        -- Test Case 17: Key with alternating bits, data random
        data_in <= X"97";  -- Input data: 1001 0111
        key <= X"55";      -- Key: 0101 0101
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 17 failed: data_in = X""97"", key = X""55"""
        severity error;

        -- Test Case 18: Data all 1's, key with alternating bits
        data_in <= X"FF";  -- Input data: 1111 1111
        key <= X"AA";      -- Key: 1010 1010
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 18 failed: data_in = X""FF"", key = X""AA"""
        severity error;

        -- Test Case 19: Data and key random values
        data_in <= X"4B";  -- Input data: 0100 1011
        key <= X"1C";      -- Key: 0001 1100
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 19 failed: data_in = X""4B"", key = X""1C"""
        severity error;

        -- Test Case 20: Random data and key
        data_in <= X"5D";  -- Input data: 0101 1101
        key <= X"E7";      -- Key: 1110 0111
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 20 failed: data_in = X""5D"", key = X""E7"""
        severity error;

        -- Test Case 21: Random data and key
        data_in <= X"2F";  -- Input data: 0010 1111
        key <= X"C1";      -- Key: 1100 0001
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 21 failed: data_in = X""2F"", key = X""C1"""
        severity error;

        -- Test Case 22: Data and key random values
        data_in <= X"7B";  -- Input data: 0111 1011
        key <= X"D4";      -- Key: 1101 0100
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 22 failed: data_in = X""7B"", key = X""D4"""
        severity error;

        -- Test Case 23: Data and key both random values
        data_in <= X"6E";  -- Input data: 0110 1110
        key <= X"8F";      -- Key: 1000 1111
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 23 failed: data_in = X""6E"", key = X""8F"""
        severity error;

        -- Test Case 24: Data and key swapped
        data_in <= X"8F";  -- Input data: 1000 1111
        key <= X"6E";      -- Key: 0110 1110
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 24 failed: data_in = X""8F"", key = X""6E"""
        severity error;

        -- Test Case 25: Data and key random
        data_in <= X"34";  -- Input data: 0011 0100
        key <= X"9A";      -- Key: 1001 1010
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 25 failed: data_in = X""34"", key = X""9A"""
        severity error;

        -- Test Case 26: Random data and key
        data_in <= X"1A";  -- Input data: 0001 1010
        key <= X"B5";      -- Key: 1011 0101
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 26 failed: data_in = X""1A"", key = X""B5"""
        severity error;

        -- Test Case 27: Data with all bits alternating
        data_in <= X"AA";  -- Input data: 1010 1010
        key <= X"FF";      -- Key: 1111 1111
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 27 failed: data_in = X""AA"", key = X""FF"""
        severity error;

        -- Test Case 28: Data and key with random values
        data_in <= X"7C";  -- Input data: 0111 1100
        key <= X"2A";      -- Key: 0010 1010
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 28 failed: data_in = X""7C"", key = X""2A"""
        severity error;

        -- Test Case 29: Random data and key
        data_in <= X"56";  -- Input data: 0101 0110
        key <= X"99";      -- Key: 1001 1001
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 29 failed: data_in = X""56"", key = X""99"""
        severity error;

        -- Test Case 30: Random data and key
        data_in <= X"67";  -- Input data: 0110 0111
        key <= X"24";      -- Key: 0010 0100
        wait for 10 ns;
        assert final_output = data_in
        report "Test Case 30 failed: data_in = X""67"", key = X""24"""
        severity error;

        -- Indicate successful completion of tests
        report "All test cases passed successfully." severity note;
        wait;
    end process;

end Behavioral;
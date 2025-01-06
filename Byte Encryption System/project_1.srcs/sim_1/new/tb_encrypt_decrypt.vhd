library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  -- For unsigned and integer conversions

entity encryption_system_tb is
end encryption_system_tb;

architecture  Structural  of encryption_system_tb is
    -- Component declaration for encryption_system
    component encryption_system is
        Port ( 
            ascii_in : in STD_LOGIC_VECTOR (7 downto 0);
            led_out : out STD_LOGIC_VECTOR (2 downto 0);
            final_output : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    -- Signals to connect to the encryption_system
    signal ascii_in : STD_LOGIC_VECTOR (7 downto 0);
    signal led_out : STD_LOGIC_VECTOR (2 downto 0);
    signal final_output : STD_LOGIC_VECTOR (7 downto 0);

begin
    -- Instantiate the encryption_system
    uut: encryption_system
        port map (
            ascii_in => ascii_in,
            led_out => led_out,
            final_output => final_output
        );

    -- Test process
    stim_proc: process
        -- Helper function to perform transformations manually
        function expected_final_output(
            ascii_input : STD_LOGIC_VECTOR(7 downto 0)
        ) return STD_LOGIC_VECTOR is
            variable temp : STD_LOGIC_VECTOR(7 downto 0);
            variable shift_amt : integer;
            variable shifted_pre_encrypt : STD_LOGIC_VECTOR(7 downto 0);
            variable encrypted : STD_LOGIC_VECTOR(7 downto 0);
            variable decrypted : STD_LOGIC_VECTOR(7 downto 0);
            variable shifted_post_decrypt : STD_LOGIC_VECTOR(7 downto 0);
            variable final : STD_LOGIC_VECTOR(7 downto 0);
            variable reverse_shift_dir : STD_LOGIC;
            constant key : STD_LOGIC_VECTOR(7 downto 0) := "10101100";
            constant shift_direction : STD_LOGIC := '0';
        begin
            -- ASCII Comparator: Assuming it passes the ASCII input through unchanged
            temp := ascii_input;

            -- Pre-encryption shift
            shift_amt := to_integer(unsigned(key(2 downto 0)));  -- 3 LSBs = 100 = 4
            shifted_pre_encrypt := std_logic_vector(rotate_left(unsigned(temp), shift_amt));

            -- XOR Encryption
            encrypted := shifted_pre_encrypt XOR key;

            -- XOR Decryption
            decrypted := encrypted XOR key;

            -- Post-decryption shift (reverse operation)
            shifted_post_decrypt := std_logic_vector(rotate_right(unsigned(decrypted), shift_amt));

            -- Case Converter
            if shifted_post_decrypt(6) = '1' and shifted_post_decrypt(5) = '0' then
                final := shifted_post_decrypt(7 downto 6) & '1' & shifted_post_decrypt(4 downto 0);  -- Convert to lowercase
            else
                final := shifted_post_decrypt;
            end if;

            return final;
        end function;

    begin
        -- Test Case 1: Character 'A' (ASCII 41h)
        ascii_in <= X"41";  -- ASCII code for 'A'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 1: Input 'A' failed" severity error;

        -- Test Case 2: Character 'z' (ASCII 7Ah)
        ascii_in <= X"7A";  -- ASCII code for 'z'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 2: Input 'z' failed" severity error;

        -- Test Case 3: Character 'M' (ASCII 4Dh)
        ascii_in <= X"4D";  -- ASCII code for 'M'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 3: Input 'M' failed" severity error;

        -- Test Case 4: Character 'n' (ASCII 6Eh)
        ascii_in <= X"6E";  -- ASCII code for 'n'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 4: Input 'n' failed" severity error;

        -- Test Case 5: Character 'B' (ASCII 42h)
        ascii_in <= X"42";  -- ASCII code for 'B'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 5: Input 'B' failed" severity error;

        -- Test Case 6: Character 'y' (ASCII 79h)
        ascii_in <= X"79";  -- ASCII code for 'y'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 6: Input 'y' failed" severity error;

        -- Test Case 7: Character 'C' (ASCII 43h)
        ascii_in <= X"43";  -- ASCII code for 'C'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 7: Input 'C' failed" severity error;

        -- Test Case 8: Character 'x' (ASCII 78h)
        ascii_in <= X"78";  -- ASCII code for 'x'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 8: Input 'x' failed" severity error;

        -- Test Case 9: Character 'D' (ASCII 44h)
        ascii_in <= X"44";  -- ASCII code for 'D'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 9: Input 'D' failed" severity error;

        -- Test Case 10: Character 'w' (ASCII 77h)
        ascii_in <= X"77";  -- ASCII code for 'w'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 10: Input 'w' failed" severity error;

        -- Test Case 11: Character 'E' (ASCII 45h)
        ascii_in <= X"45";  -- ASCII code for 'E'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 11: Input 'E' failed" severity error;

        -- Test Case 12: Character 'v' (ASCII 76h)
        ascii_in <= X"76";  -- ASCII code for 'v'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 12: Input 'v' failed" severity error;

        -- Test Case 13: Character 'F' (ASCII 46h)
        ascii_in <= X"46";  -- ASCII code for 'F'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 13: Input 'F' failed" severity error;

        -- Test Case 14: Character 'u' (ASCII 75h)
        ascii_in <= X"75";  -- ASCII code for 'u'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 14: Input 'u' failed" severity error;

        -- Test Case 15: Character 'G' (ASCII 47h)
        ascii_in <= X"47";  -- ASCII code for 'G'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 15: Input 'G' failed" severity error;

        -- Test Case 16: Character 't' (ASCII 74h)
        ascii_in <= X"74";  -- ASCII code for 't'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 16: Input 't' failed" severity error;

        -- Test Case 17: Character 'H' (ASCII 48h)
        ascii_in <= X"48";  -- ASCII code for 'H'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 17: Input 'H' failed" severity error;

        -- Test Case 18: Character 's' (ASCII 73h)
        ascii_in <= X"73";  -- ASCII code for 's'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 18: Input 's' failed" severity error;

        -- Test Case 19: Character 'I' (ASCII 49h)
        ascii_in <= X"49";  -- ASCII code for 'I'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 19: Input 'I' failed" severity error;

        -- Test Case 20: Character 'r' (ASCII 72h)
        ascii_in <= X"72";  -- ASCII code for 'r'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 20: Input 'r' failed" severity error;

        -- Test Case 21: Character 'J' (ASCII 4Ah)
        ascii_in <= X"4A";  -- ASCII code for 'J'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 21: Input 'J' failed" severity error;

        -- Test Case 22: Character 'q' (ASCII 71h)
        ascii_in <= X"71";  -- ASCII code for 'q'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 22: Input 'q' failed" severity error;

        -- Test Case 23: Character 'K' (ASCII 4Bh)
        ascii_in <= X"4B";  -- ASCII code for 'K'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 23: Input 'K' failed" severity error;

        -- Test Case 24: Character 'p' (ASCII 70h)
        ascii_in <= X"70";  -- ASCII code for 'p'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 24: Input 'p' failed" severity error;

        -- Test Case 25: Character 'L' (ASCII 4Ch)
        ascii_in <= X"4C";  -- ASCII code for 'L'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 25: Input 'L' failed" severity error;

        -- Test Case 26: Character 'o' (ASCII 6Fh)
        ascii_in <= X"6F";  -- ASCII code for 'o'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 26: Input 'o' failed" severity error;

        -- Test Case 27: Character 'm' (ASCII 6Dh)
        ascii_in <= X"6D";  -- ASCII code for 'm'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 27: Input 'm' failed" severity error;

        -- Test Case 28: Character 'N' (ASCII 4Eh)
        ascii_in <= X"4E";  -- ASCII code for 'N'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 28: Input 'N' failed" severity error;

        -- Test Case 29: Character 'l' (ASCII 6Ch)
        ascii_in <= X"6C";  -- ASCII code for 'l'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 29: Input 'l' failed" severity error;

        -- Test Case 30: Character 'O' (ASCII 4Fh)
        ascii_in <= X"4F";  -- ASCII code for 'O'
        wait for 10 ns;
        assert final_output = expected_final_output(ascii_in)
        report "Test Case 30: Input 'O' failed" severity error;

        -- Indicate successful completion
        report "All tests passed successfully." severity note;
        wait;
    end process;

end  Structural ;
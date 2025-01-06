library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ascii_comparator_tb is
end ascii_comparator_tb;

architecture Behavioral of ascii_comparator_tb is
    component ascii_comparator is
        Port (
            ascii_in : in STD_LOGIC_VECTOR (7 downto 0);
            ascii_out : out STD_LOGIC_VECTOR (7 downto 0);
            led_out : out STD_LOGIC_VECTOR (2 downto 0)
        );
    end component;

    signal ascii_in : STD_LOGIC_VECTOR (7 downto 0);
    signal ascii_out : STD_LOGIC_VECTOR (7 downto 0);
    signal led_out : STD_LOGIC_VECTOR (2 downto 0);

begin
    uut: ascii_comparator port map (
        ascii_in => ascii_in,
        ascii_out => ascii_out,
        led_out => led_out
    );

    stim_proc: process
    begin
        -- Test Case 1: Valid uppercase 'A'
        ascii_in <= "01000001"; -- 'A'
        wait for 10 ns;
        assert ascii_out = "01000001" report "Test Case 1 failed for input 'A'" severity error;

        -- Test Case 2: Valid uppercase 'B'
        ascii_in <= "01000010"; -- 'B'
        wait for 10 ns;
        assert ascii_out = "01000010" report "Test Case 2 failed for input 'B'" severity error;

        -- Test Case 3: Valid uppercase 'M'
        ascii_in <= "01001101"; -- 'M'
        wait for 10 ns;
        assert ascii_out = "01001101" report "Test Case 3 failed for input 'M'" severity error;

        -- Test Case 4: Valid uppercase 'Z'
        ascii_in <= "01011010"; -- 'Z'
        wait for 10 ns;
        assert ascii_out = "01011010" report "Test Case 4 failed for input 'Z'" severity error;

        -- Test Case 5: Lowercase 'a' (invalid)
        ascii_in <= "01100001"; -- 'a'
        wait for 10 ns;
        assert ascii_out = "00000000" report "Test Case 5 failed for input 'a'" severity error;

        -- Test Case 6: Lowercase 'm' (invalid)
        ascii_in <= "01101101"; -- 'm'
        wait for 10 ns;
        assert ascii_out = "00000000" report "Test Case 6 failed for input 'm'" severity error;

        -- Test Case 7: Digit '0' (invalid)
        ascii_in <= "00110000"; -- '0'
        wait for 10 ns;
        assert ascii_out = "00000000" report "Test Case 7 failed for input '0'" severity error;

        -- Test Case 8: Digit '9' (invalid)
        ascii_in <= "00111001"; -- '9'
        wait for 10 ns;
        assert ascii_out = "00000000" report "Test Case 8 failed for input '9'" severity error;

        -- Test Case 9: Exclamation mark '!'
        ascii_in <= "00100001"; -- '!'
        wait for 10 ns;
        assert ascii_out = "00000000" report "Test Case 9 failed for input '!'" severity error;

        -- Test Case 10: At symbol '@'
        ascii_in <= "01000000"; -- '@'
        wait for 10 ns;
        assert ascii_out = "00000000" report "Test Case 10 failed for input '@'" severity error;

        -- Test Case 11: Space character
        ascii_in <= "00100000"; -- ' '
        wait for 10 ns;
        assert ascii_out = "00000000" report "Test Case 11 failed for input ' '" severity error;

        -- Test Case 12: Hash '#'
        ascii_in <= "00100011"; -- '#'
        wait for 10 ns;
        assert ascii_out = "00000000" report "Test Case 12 failed for input '#'" severity error;

        -- Test Case 13: Dollar '$'
        ascii_in <= "00100100"; -- '$'
        wait for 10 ns;
        assert ascii_out = "00000000" report "Test Case 13 failed for input '$'" severity error;

        -- Test Case 14: Percent '%'
        ascii_in <= "00100101"; -- '%'
        wait for 10 ns;
        assert ascii_out = "00000000" report "Test Case 14 failed for input '%'" severity error;

        -- Test Case 15: Ampersand '&'
        ascii_in <= "00100110"; -- '&'
        wait for 10 ns;
        assert ascii_out = "00000000" report "Test Case 15 failed for input '&'" severity error;

        -- Test Case 16: Asterisk '*'
        ascii_in <= "00101010"; -- '*'
        wait for 10 ns;
        assert ascii_out = "00000000" report "Test Case 16 failed for input '*'" severity error;

        -- Test Case 17: Plus '+'
        ascii_in <= "00101011"; -- '+'
        wait for 10 ns;
        assert ascii_out = "00000000" report "Test Case 17 failed for input '+'" severity error;

        -- Test Case 18: Comma ','
        ascii_in <= "00101100"; -- ','
        wait for 10 ns;
        assert ascii_out = "00000000" report "Test Case 18 failed for input ','" severity error;

        -- Test Case 19: Hyphen '-'
        ascii_in <= "00101101"; -- '-'
        wait for 10 ns;
        assert ascii_out = "00000000" report "Test Case 19 failed for input '-'" severity error;

        -- Test Case 20: Period '.'
        ascii_in <= "00101110"; -- '.'
        wait for 10 ns;
        assert ascii_out = "00000000" report "Test Case 20 failed for input '.'" severity error;

        -- Test Case 21: Slash '/'
        ascii_in <= "00101111"; -- '/'
        wait for 10 ns;
        assert ascii_out = "00000000" report "Test Case 21 failed for input '/'" severity error;

        -- Test Case 22: Colon ':'
        ascii_in <= "00111010"; -- ':'
        wait for 10 ns;
        assert ascii_out = "00000000" report "Test Case 22 failed for input ':'" severity error;

        -- Test Case 23: Semicolon ';'
        ascii_in <= "00111011"; -- ';'
        wait for 10 ns;
        assert ascii_out = "00000000" report "Test Case 23 failed for input ';'" severity error;

        -- Test Case 24: Less than '<'
        ascii_in <= "00111100"; -- '<'
        wait for 10 ns;
        assert ascii_out = "00000000" report "Test Case 24 failed for input '<'" severity error;

        -- Test Case 25: Equals '='
        ascii_in <= "00111101"; -- '='
        wait for 10 ns;
        assert ascii_out = "00000000" report "Test Case 25 failed for input '='" severity error;

        -- Test Case 26: Greater than '>'
        ascii_in <= "00111110"; -- '>'
        wait for 10 ns;
        assert ascii_out = "00000000" report "Test Case 26 failed for input '>'" severity error;

        -- Test Case 27: Question mark '?'
        ascii_in <= "00111111"; -- '?'
        wait for 10 ns;
        assert ascii_out = "00000000" report "Test Case 27 failed for input '?'" severity error;

        -- Test Case 28: Backslash '\'
        ascii_in <= "01011100"; -- '\'
        wait for 10 ns;
        assert ascii_out = "00000000" report "Test Case 28 failed for input '\'" severity error;

        -- Test Case 29: Underscore '_'
        ascii_in <= "01011111"; -- '_'
        wait for 10 ns;
        assert ascii_out = "00000000" report "Test Case 29 failed for input '_'" severity error;

        -- Test Case 30: Tilde '~'
        ascii_in <= "01111110"; -- '~'
        wait for 10 ns;
        assert ascii_out = "00000000" report "Test Case 30 failed for input '~'" severity error;

        -- End of Test Cases
        wait;
    end process;

end Behavioral;
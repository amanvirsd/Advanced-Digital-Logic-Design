library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity case_converter_tb is
end case_converter_tb;

architecture Behavioral of case_converter_tb is
    component case_converter is
        Port (
            data_in : in STD_LOGIC_VECTOR (7 downto 0);
            data_out : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    signal data_in : STD_LOGIC_VECTOR (7 downto 0);
    signal data_out : STD_LOGIC_VECTOR (7 downto 0);

begin
    uut: case_converter port map (
        data_in => data_in,
        data_out => data_out
    );

    stim_proc: process
    begin
        -- Test Case 1: Uppercase 'A' to lowercase 'a'
        data_in <= "01000001"; -- 'A'
        wait for 10 ns;
        assert data_out = "01100001" report "Test Case 1 failed for 'A' to 'a' conversion" severity error;

        -- Test Case 2: Uppercase 'B' to lowercase 'b'
        data_in <= "01000010"; -- 'B'
        wait for 10 ns;
        assert data_out = "01100010" report "Test Case 2 failed for 'B' to 'b' conversion" severity error;

        -- Test Case 3: Uppercase 'C' to lowercase 'c'
        data_in <= "01000011"; -- 'C'
        wait for 10 ns;
        assert data_out = "01100011" report "Test Case 3 failed for 'C' to 'c' conversion" severity error;

        -- Test Case 4: Uppercase 'M' to lowercase 'm'
        data_in <= "01001101"; -- 'M'
        wait for 10 ns;
        assert data_out = "01101101" report "Test Case 4 failed for 'M' to 'm' conversion" severity error;

        -- Test Case 5: Uppercase 'Z' to lowercase 'z'
        data_in <= "01011010"; -- 'Z'
        wait for 10 ns;
        assert data_out = "01111010" report "Test Case 5 failed for 'Z' to 'z' conversion" severity error;

        -- Test Case 6: Non-letter character ','
        data_in <= "00101100"; -- ','
        wait for 10 ns;
        assert data_out = "00101100" report "Test Case 6 failed for ',' (no conversion)" severity error;

        -- Test Case 7: Non-letter character '!'
        data_in <= "00100001"; -- '!'
        wait for 10 ns;
        assert data_out = "00100001" report "Test Case 7 failed for '!' (no conversion)" severity error;

        -- Test Case 8: Space character (non-letter)
        data_in <= "00100000"; -- ' '
        wait for 10 ns;
        assert data_out = "00100000" report "Test Case 8 failed for ' ' (no conversion)" severity error;

        -- Test Case 9: Uppercase 'F' to lowercase 'f'
        data_in <= "01000110"; -- 'F'
        wait for 10 ns;
        assert data_out = "01100110" report "Test Case 9 failed for 'F' to 'f' conversion" severity error;

        -- Test Case 10: Uppercase 'Q' to lowercase 'q'
        data_in <= "01010001"; -- 'Q'
        wait for 10 ns;
        assert data_out = "01110001" report "Test Case 10 failed for 'Q' to 'q' conversion" severity error;

        -- Test Case 11: Digit '0' (no conversion)
        data_in <= "00110000"; -- '0'
        wait for 10 ns;
        assert data_out = "00110000" report "Test Case 11 failed for '0' (no conversion)" severity error;

        -- Test Case 12: Digit '9' (no conversion)
        data_in <= "00111001"; -- '9'
        wait for 10 ns;
        assert data_out = "00111001" report "Test Case 12 failed for '9' (no conversion)" severity error;

        -- Test Case 13: Lowercase 'a' (no conversion)
        data_in <= "01100001"; -- 'a'
        wait for 10 ns;
        assert data_out = "01100001" report "Test Case 13 failed for 'a' (no conversion expected)" severity error;

        -- Test Case 14: Lowercase 'z' (no conversion)
        data_in <= "01111010"; -- 'z'
        wait for 10 ns;
        assert data_out = "01111010" report "Test Case 14 failed for 'z' (no conversion expected)" severity error;

        -- Test Case 15: Non-letter '$' (no conversion)
        data_in <= "00100100"; -- '$'
        wait for 10 ns;
        assert data_out = "00100100" report "Test Case 15 failed for '$' (no conversion)" severity error;

        -- Test Case 16: Non-letter '+' (no conversion)
        data_in <= "00101011"; -- '+'
        wait for 10 ns;
        assert data_out = "00101011" report "Test Case 16 failed for '+' (no conversion)" severity error;

        -- Test Case 17: Non-letter '-' (no conversion)
        data_in <= "00101101"; -- '-'
        wait for 10 ns;
        assert data_out = "00101101" report "Test Case 17 failed for '-' (no conversion)" severity error;

        -- Test Case 18: Uppercase 'X' to lowercase 'x'
        data_in <= "01011000"; -- 'X'
        wait for 10 ns;
        assert data_out = "01111000" report "Test Case 18 failed for 'X' to 'x' conversion" severity error;

        -- Test Case 19: Uppercase 'H' to lowercase 'h'
        data_in <= "01001000"; -- 'H'
        wait for 10 ns;
        assert data_out = "01101000" report "Test Case 19 failed for 'H' to 'h' conversion" severity error;

        -- Test Case 20: Uppercase 'J' to lowercase 'j'
        data_in <= "01001010"; -- 'J'
        wait for 10 ns;
        assert data_out = "01101010" report "Test Case 20 failed for 'J' to 'j' conversion" severity error;

        -- Test Case 21: Uppercase 'K' to lowercase 'k'
        data_in <= "01001011"; -- 'K'
        wait for 10 ns;
        assert data_out = "01101011" report "Test Case 21 failed for 'K' to 'k' conversion" severity error;

        -- Test Case 22: Uppercase 'L' to lowercase 'l'
        data_in <= "01001100"; -- 'L'
        wait for 10 ns;
        assert data_out = "01101100" report "Test Case 22 failed for 'L' to 'l' conversion" severity error;

        -- Test Case 23: Non-letter '%'
        data_in <= "00100101"; -- '%'
        wait for 10 ns;
        assert data_out = "00100101" report "Test Case 23 failed for '%' (no conversion)" severity error;

        -- Test Case 24: Uppercase 'P' to lowercase 'p'
        data_in <= "01010000"; -- 'P'
        wait for 10 ns;
        assert data_out = "01110000" report "Test Case 24 failed for 'P' to 'p' conversion" severity error;

        -- Test Case 25: Non-letter '&'
        data_in <= "00100110"; -- '&'
        wait for 10 ns;
        assert data_out = "00100110" report "Test Case 25 failed for '&' (no conversion)" severity error;

        -- Test Case 26: Non-letter '/'
        data_in <= "00101111"; -- '/'
        wait for 10 ns;
        assert data_out = "00101111" report "Test Case 26 failed for '/' (no conversion)" severity error;

        -- Test Case 27: Uppercase 'S' to lowercase 's'
        data_in <= "01010011"; -- 'S'
        wait for 10 ns;
        assert data_out = "01110011" report "Test Case 27 failed for 'S' to 's' conversion" severity error;

        -- Test Case 28: Uppercase 'W' to lowercase 'w'
        data_in <= "01010111"; -- 'W'
        wait for 10 ns;
        assert data_out = "01110111" report "Test Case 28 failed for 'W' to 'w' conversion" severity error;
        
        wait;

    end process;

end Behavioral;
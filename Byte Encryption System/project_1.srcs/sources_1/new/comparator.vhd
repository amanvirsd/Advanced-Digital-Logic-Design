library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ascii_comparator is
    Port (
        ascii_in : in STD_LOGIC_VECTOR (7 downto 0);
        ascii_out : out STD_LOGIC_VECTOR (7 downto 0);
        led_out : out STD_LOGIC_VECTOR (2 downto 0)
    );
end ascii_comparator;

architecture Behavioral of ascii_comparator is
    signal valid_char : STD_LOGIC;
    
begin
    process (ascii_in)
    begin
        -- Check the 3 MSBs to restrict input range to 010xxxxx (uppercase letters)
        if ascii_in(7 downto 5) = "010" then
            -- Check the remaining 5 bits to ensure it's a valid uppercase letter (A-Z)
            case ascii_in(4 downto 0) is
                when "00001" | "00010" | "00011" | "00100" | "00101" |  -- A, B, C, D, E
                     "00110" | "00111" | "01000" | "01001" | "01010" |  -- F, G, H, I, J
                     "01011" | "01100" | "01101" | "01110" | "01111" |  -- K, L, M, N, O
                     "10000" | "10001" | "10010" | "10011" | "10100" |  -- P, Q, R, S, T
                     "10101" | "10110" | "10111" | "11000" | "11001" |  -- U, V, W, X, Y
                     "11010" =>                                         -- Z
                    -- Valid uppercase letter
                    valid_char <= '1';
                    ascii_out <= ascii_in;
                    led_out <= "010";  -- Green
                when others =>
                    -- Invalid character
                    valid_char <= '0';
                    ascii_out <= (others => '0');
                    led_out <= "100";  -- Red
            end case;
        else
            -- Input outside valid range
            valid_char <= '0';
            ascii_out <= (others => '0');
            led_out <= "100";  -- Red
        end if;
    end process;
end Behavioral;
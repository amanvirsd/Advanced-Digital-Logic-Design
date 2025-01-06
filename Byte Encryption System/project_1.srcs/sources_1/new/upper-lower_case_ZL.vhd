library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity case_converter is
    Port ( 
        data_in : in STD_LOGIC_VECTOR (7 downto 0);
        data_out : out STD_LOGIC_VECTOR (7 downto 0)
    );
end case_converter;

architecture Behavioral of case_converter is
begin
    process (data_in)
    begin
        if data_in(7 downto 5) = "010" then
            -- Input is an uppercase letter (ASCII range 65 to 90)
            -- Convert to lowercase by setting bit 5 to '1'
            data_out <= data_in(7 downto 6) & '1' & data_in(4 downto 0);
        else
            -- Input is not an uppercase letter, pass it through unchanged  
            data_out <= data_in;
        end if;
    end process;
end Behavioral;
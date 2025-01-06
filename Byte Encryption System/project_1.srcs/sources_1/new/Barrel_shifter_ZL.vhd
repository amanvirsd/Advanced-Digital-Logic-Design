library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity barrel_shifter is
    Port ( 
        data_in        : in  STD_LOGIC_VECTOR (7 downto 0);
        shift_amount   : in  STD_LOGIC_VECTOR (2 downto 0);
        shift_direction: in  STD_LOGIC;
        data_out       : out STD_LOGIC_VECTOR (7 downto 0)
    );
end barrel_shifter;

architecture Behavioral of barrel_shifter is
begin
    process (data_in, shift_amount, shift_direction)
        variable temp       : STD_LOGIC_VECTOR (7 downto 0);
        variable shift_amt  : integer;
    begin
        -- Convert shift_amount from STD_LOGIC_VECTOR to integer and ensure it's within 0-7
        shift_amt := to_integer(unsigned(shift_amount)) mod 8;

        if shift_direction = '0' then
            -- Rotate Left
            temp := std_logic_vector(rotate_left(unsigned(data_in), shift_amt));
        else
            -- Rotate Right
            temp := std_logic_vector(rotate_right(unsigned(data_in), shift_amt));
        end if;

        data_out <= temp;
    end process;
end Behavioral;
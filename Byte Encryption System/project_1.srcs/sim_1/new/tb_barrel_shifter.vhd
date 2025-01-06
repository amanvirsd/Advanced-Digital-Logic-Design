library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity barrel_shifter_tb is
end barrel_shifter_tb;

architecture Behavioral of barrel_shifter_tb is
    component barrel_shifter is
        Port (
            data_in : in STD_LOGIC_VECTOR (7 downto 0);
            shift_amount : in STD_LOGIC_VECTOR (2 downto 0);
            shift_direction : in STD_LOGIC;
            data_out : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    signal data_in : STD_LOGIC_VECTOR (7 downto 0);
    signal shift_amount : STD_LOGIC_VECTOR (2 downto 0);
    signal shift_direction : STD_LOGIC;
    signal data_out : STD_LOGIC_VECTOR (7 downto 0);
    signal expected_out : STD_LOGIC_VECTOR (7 downto 0);
begin
    uut: barrel_shifter port map (
        data_in => data_in,
        shift_amount => shift_amount,
        shift_direction => shift_direction,
        data_out => data_out
    );

    stim_proc: process
    begin
        -- Test Case 1: No shift (shift_amount = 0), Left shift
        data_in        <= "10110011";
        shift_amount   <= "000"; -- 0
        shift_direction<= '0';    -- Left shift
        expected_out   <= "10110011"; -- No shift
        WAIT FOR 10 ns;
        assert data_out = expected_out
            report "Test Case 1 Failed: No Shift (Left)"
            severity error;

        -- Test Case 2: Shift left by 1
        data_in        <= "11001100";
        shift_amount   <= "001"; -- 1
        shift_direction<= '0';    -- Left shift
        expected_out   <= "10011001"; -- Circular left shift by 1
        WAIT FOR 10 ns;
        assert data_out = expected_out
            report "Test Case 2 Failed: Shift Left by 1"
            severity error;

        -- Test Case 3: Shift left by 2
        data_in        <= "11110000";
        shift_amount   <= "010"; -- 2
        shift_direction<= '1';    -- rt shift
        expected_out   <= "00110011"; -- Circular left shift by 2
        WAIT FOR 10 ns;
        assert data_out = expected_out
            report "Test Case 3 Failed: Shift Left by 2"
            severity error;

        -- Test Case 4: Shift left by 3
        data_in        <= "10101010";
        shift_amount   <= "011"; -- 3
        shift_direction<= '0';    -- Left shift
        expected_out   <= "01010101"; -- Circular left shift by 3
        WAIT FOR 10 ns;
        assert data_out = expected_out
            report "Test Case 4 Failed: Shift Left by 3"
            severity error;

        -- Test Case 5: Shift left by 4
        data_in        <= "10000001";
        shift_amount   <= "100"; -- 4
        shift_direction<= '0';    -- Left shift
        expected_out   <= "00011000"; -- Circular left shift by 4
        WAIT FOR 10 ns;
        assert data_out = expected_out
            report "Test Case 5 Failed: Shift Left by 4"
            severity error;

        -- Test Case 6: Shift left by 5
        data_in        <= "01100110";
        shift_amount   <= "101"; -- 5
        shift_direction<= '0';    -- Left shift
        expected_out   <= "01100110"; -- Circular left shift by 5
        WAIT FOR 10 ns;
        assert data_out = expected_out
            report "Test Case 6 Failed: Shift Left by 5"
            severity error;

        -- Test Case 7: Shift left by 6
        data_in        <= "00111100";
        shift_amount   <= "110"; -- 6
        shift_direction<= '0';    -- Left shift
        expected_out   <= "11110000"; -- Circular left shift by 6
        WAIT FOR 10 ns;
        assert data_out = expected_out
            report "Test Case 7 Failed: Shift Left by 6"
            severity error;

        -- Test Case 8: Shift left by 7
        data_in        <= "00001111";
        shift_amount   <= "111"; -- 7
        shift_direction<= '0';    -- Left shift
        expected_out   <= "10000111"; -- Circular left shift by 7
        WAIT FOR 10 ns;
        assert data_out = expected_out
            report "Test Case 8 Failed: Shift Left by 7"
            severity error;

        -- Test Case 9: No shift (shift_amount = 0), Right shift
        data_in        <= "11110000";
        shift_amount   <= "000"; -- 0
        shift_direction<= '1';    -- Right shift
        expected_out   <= "11110000"; -- No shift
        WAIT FOR 10 ns;
        assert data_out = expected_out
            report "Test Case 9 Failed: No Shift (Right)"
            severity error;

        -- Test Case 10: Shift right by 1
        data_in        <= "11001100";
        shift_amount   <= "001"; -- 1
        shift_direction<= '1';    -- Right shift
        expected_out   <= "01100110"; -- Circular right shift by 1
        WAIT FOR 10 ns;
        assert data_out = expected_out
            report "Test Case 10 Failed: Shift Right by 1"
            severity error;

        -- Test Case 11: Shift right by 2
        data_in        <= "10101010";
        shift_amount   <= "010"; -- 2
        shift_direction<= '1';    -- Right shift
        expected_out   <= "10101010"; -- Circular right shift by 2
        WAIT FOR 10 ns;
        assert data_out = expected_out
            report "Test Case 11 Failed: Shift Right by 2"
            severity error;

        -- Test Case 12: Shift right by 3
        data_in        <= "10011001";
        shift_amount   <= "011"; -- 3
        shift_direction<= '1';    -- Right shift
        expected_out   <= "00110011"; -- Circular right shift by 3
        WAIT FOR 10 ns;
        assert data_out = expected_out
            report "Test Case 12 Failed: Shift Right by 3"
            severity error;

        -- Test Case 13: Shift right by 4
        data_in        <= "11111111";
        shift_amount   <= "100"; -- 4
        shift_direction<= '1';    -- Right shift
        expected_out   <= "11111111"; -- Circular right shift by 4
        WAIT FOR 10 ns;
        assert data_out = expected_out
            report "Test Case 13 Failed: Shift Right by 4"
            severity error;

        -- Test Case 14: Shift right by 5
        data_in        <= "00000000";
        shift_amount   <= "101"; -- 5
        shift_direction<= '1';    -- Right shift
        expected_out   <= "00000000"; -- Circular right shift by 5
        WAIT FOR 10 ns;
        assert data_out = expected_out
            report "Test Case 14 Failed: Shift Right by 5"
            severity error;

        -- Test Case 15: Shift right by 6
        data_in        <= "10111101";
        shift_amount   <= "110"; -- 6
        shift_direction<= '1';    -- Right shift
        expected_out   <= "11110110"; -- Circular right shift by 6
        WAIT FOR 10 ns;
        assert data_out = expected_out
            report "Test Case 15 Failed: Shift Right by 6"
            severity error;

        -- Test Case 16: Shift right by 7
        data_in        <= "01010101";
        shift_amount   <= "111"; -- 7
        shift_direction<= '1';    -- Right shift
        expected_out   <= "10101010"; -- Circular right shift by 7
        WAIT FOR 10 ns;
        assert data_out = expected_out
            report "Test Case 16 Failed: Shift Right by 7"
            severity error;

        -- Test Case 17: All bits set, Shift left by 3
        data_in        <= "11111111";
        shift_amount   <= "011"; -- 3
        shift_direction<= '0';    -- Left shift
        expected_out   <= "11111111"; -- All bits set remain the same after shift
        WAIT FOR 10 ns;
        assert data_out = expected_out
            report "Test Case 17 Failed: All Bits Set, Shift Left by 3"
            severity error;

        -- Test Case 18: All bits cleared, Shift right by 2
        data_in        <= "00000000";
        shift_amount   <= "010"; -- 2
        shift_direction<= '1';    -- Right shift
        expected_out   <= "00000000"; -- All bits cleared remain the same after shift
        WAIT FOR 10 ns;
        assert data_out = expected_out
            report "Test Case 18 Failed: All Bits Cleared, Shift Right by 2"
            severity error;

        -- Test Case 19: Alternate bits set, Shift left by 1
        data_in        <= "10101010";
        shift_amount   <= "001"; -- 1
        shift_direction<= '0';    -- Left shift
        expected_out   <= "01010101"; -- Circular left shift by 1
        WAIT FOR 10 ns;
        assert data_out = expected_out
            report "Test Case 19 Failed: Alternate Bits Set, Shift Left by 1"
            severity error;

        -- Test Case 20: Alternate bits set, Shift right by 1
        data_in        <= "01010101";
        shift_amount   <= "001"; -- 1
        shift_direction<= '1';    -- Right shift
        expected_out   <= "10101010"; -- Circular right shift by 1
        WAIT FOR 10 ns;
        assert data_out = expected_out
            report "Test Case 20 Failed: Alternate Bits Set, Shift Right by 1"
            severity error;

        -- Test Case 21: Maximum shift left (7) with different data
        data_in        <= "10000001";
        shift_amount   <= "111"; -- 7
        shift_direction<= '0';    -- Left shift
        expected_out   <= "00000011"; -- Circular left shift by 7
        WAIT FOR 10 ns;
        assert data_out = expected_out
            report "Test Case 21 Failed: Maximum Shift Left by 7"
            severity error;

        -- Test Case 22: Maximum shift right (7) with different data
        data_in        <= "10000001";
        shift_amount   <= "111"; -- 7
        shift_direction<= '1';    -- Right shift
        expected_out   <= "11000000"; -- Circular right shift by 7
        WAIT FOR 10 ns;
        assert data_out = expected_out
            report "Test Case 22 Failed: Maximum Shift Right by 7"
            severity error;

        -- Test Case 23: Shift left by 0 with different data
        data_in        <= "01100110";
        shift_amount   <= "000"; -- 0
        shift_direction<= '0';    -- Left shift
        expected_out   <= "01100110"; -- No shift
        WAIT FOR 10 ns;
        assert data_out = expected_out
            report "Test Case 23 Failed: Shift Left by 0 with Different Data"
            severity error;

        -- Test Case 24: Shift right by 0 with different data
        data_in        <= "11011011";
        shift_amount   <= "000"; -- 0
        shift_direction<= '1';    -- Right shift
        expected_out   <= "11011011"; -- No shift
        WAIT FOR 10 ns;
        assert data_out = expected_out
            report "Test Case 24 Failed: Shift Right by 0 with Different Data"
            severity error;

        -- Test Case 25: Random data, Shift left by 3
        data_in        <= "00101101";
        shift_amount   <= "011"; -- 3
        shift_direction<= '0';    -- Left shift
        expected_out   <= "01101001"; -- Circular left shift by 3
        WAIT FOR 10 ns;
        assert data_out = expected_out
            report "Test Case 25 Failed: Random Data, Shift Left by 3"
            severity error;

        -- Test Case 26: Random data, Shift right by 4
        data_in        <= "11010110";
        shift_amount   <= "100"; -- 4
        shift_direction<= '1';    -- Right shift
        expected_out   <= "01101101"; -- Circular right shift by 4
        WAIT FOR 10 ns;
        assert data_out = expected_out
            report "Test Case 26 Failed: Random Data, Shift Right by 4"
            severity error;


        -- End of tests
        report "All test cases completed successfully." severity note;
        wait;
    end process;

end Behavioral;
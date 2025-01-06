----------------------------------------------------------------------------------
-- Filename : accumulator.vhdl
-- Author : Antonio Alejandro Andara Lara
-- Date : 31-Oct-2023
-- Design Name: accumulator_tb
-- Project Name: ECE 410 lab 3 2023
-- Description : extended 16-bit testbench for the accumulator register of the simple CPU
-- Revision 1.02 - File Modified by Assistant (November 10, 2024)
-- Additional Comments:
-- Copyright : University of Alberta, 2023
-- License : CC0 1.0 Universal
-- Lab memebers: Amanvir Dhanoa and Zhiyuan Li
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY accumulator_tb IS
END accumulator_tb;

ARCHITECTURE sim OF accumulator_tb IS
    SIGNAL clock     : STD_LOGIC                      := '0';
    SIGNAL reset     : STD_LOGIC                      := '0';
    SIGNAL acc_write : STD_LOGIC                      := '0';
    SIGNAL acc_in    : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL acc_out   : STD_LOGIC_VECTOR (15 DOWNTO 0);

BEGIN

     uut: ENTITY WORK.accumulator(Behavioral)
        PORT MAP( clock     => clock
                , reset     => reset
                , acc_write => acc_write
                , acc_in    => acc_in
                , acc_out   => acc_out
                );
    clk_process : PROCESS
    BEGIN
        WAIT FOR 10 ns;
        clock <= NOT clock;
    END PROCESS clk_process;

    stim_proc : PROCESS
    BEGIN
        -- Reset the accumulator
        reset <= '1';
        WAIT FOR 20 ns;
        reset <= '0';

        -- Test Case 1: Simple Write
        acc_in    <= "1010101010101010";
        acc_write <= '1';
        WAIT FOR 20 ns;
        ASSERT (acc_out = "1010101010101010")
        REPORT "Mismatch in acc_out value after first write!" SEVERITY ERROR;

        -- Test Case 2: Write Disabled Check
        acc_write <= '0';
        acc_in    <= "1010010110100101";
        WAIT FOR 20 ns;
        ASSERT (acc_out = "1010101010101010")
        REPORT "Mismatch in acc_out value after disabling write!" SEVERITY ERROR;

        -- Test Case 3: Another Write
        acc_in    <= "1100110011001100";
        acc_write <= '1';
        WAIT FOR 20 ns;
        ASSERT (acc_out = "1100110011001100")
        REPORT "Mismatch in acc_out value after second write!" SEVERITY ERROR;

        -- Test Case 4: Edge Case - All 1s
        acc_in    <= "1111111111111111";
        WAIT FOR 20 ns;
        ASSERT (acc_out = "1111111111111111")
        REPORT "Mismatch in acc_out value after writing all 1s!" SEVERITY ERROR;

        -- Test Case 5: Edge Case - All 0s
        acc_in    <= "0000000000000000";
        WAIT FOR 20 ns;
        ASSERT (acc_out = "0000000000000000")
        REPORT "Mismatch in acc_out value after writing all 0s!" SEVERITY ERROR;

        -- Test Case 6: Toggle Write (should maintain last value)
        acc_write <= '0';
        acc_in    <= "0001001000110100";
        WAIT FOR 20 ns;
        ASSERT (acc_out = "0000000000000000")
        REPORT "Mismatch in acc_out value after disabling write with input change!" SEVERITY ERROR;

        -- Test Case 7: Write Enable again with different input
        acc_write <= '1';
        acc_in    <= "0101011001111000";
        WAIT FOR 20 ns;
        ASSERT (acc_out = "0101011001111000")
        REPORT "Mismatch in acc_out value after third write!" SEVERITY ERROR;

        -- Test Case 8: Reset while write enabled
        reset <= '1';
        WAIT FOR 20 ns;
        ASSERT (acc_out = "0000000000000000")
        REPORT "Mismatch in acc_out value after reset while writing!" SEVERITY ERROR;
        reset <= '0';

        -- Test Case 9: Write after reset
        acc_in    <= "0001101000011010";
        acc_write <= '1';
        WAIT FOR 20 ns;
        ASSERT (acc_out = "0001101000011010")
        REPORT "Mismatch in acc_out value after write post-reset!" SEVERITY ERROR;

        -- Test Case 10: Write disable after reset
        acc_write <= '0';
        acc_in    <= "1011001010110010";
        WAIT FOR 20 ns;
        ASSERT (acc_out = "0001101000011010")
        REPORT "Mismatch in acc_out value after disabling write post-reset!" SEVERITY ERROR;

        -- Additional Edge Cases
        -- Test Case 11: Boundary Test - alternating 1s and 0s
        acc_write <= '1';
        acc_in    <= "1010101010101010";
        WAIT FOR 20 ns;
        ASSERT (acc_out = "1010101010101010")
        REPORT "Mismatch in acc_out with alternating pattern 1010!" SEVERITY ERROR;

        -- Test Case 12: Boundary Test - alternating 0s and 1s
        acc_in    <= "0101010101010101";
        WAIT FOR 20 ns;
        ASSERT (acc_out = "0101010101010101")
        REPORT "Mismatch in acc_out with alternating pattern 0101!" SEVERITY ERROR;

        -- Test Case 13: Low nibble edge case
        acc_in    <= "0000000000001111";
        WAIT FOR 20 ns;
        ASSERT (acc_out = "0000000000001111")
        REPORT "Mismatch in acc_out with low nibble edge case!" SEVERITY ERROR;

        -- Test Case 14: High nibble edge case
        acc_in    <= "1111000000000000";
        WAIT FOR 20 ns;
        ASSERT (acc_out = "1111000000000000")
        REPORT "Mismatch in acc_out with high nibble edge case!" SEVERITY ERROR;

        -- Test Case 15: Mid value test
        acc_in    <= "1000000000000000";
        WAIT FOR 20 ns;
        ASSERT (acc_out = "1000000000000000")
        REPORT "Mismatch in acc_out with mid value test!" SEVERITY ERROR;

        -- Test Case 16: Overlapping bits test
        acc_in    <= "0011110000111100";
        WAIT FOR 20 ns;
        ASSERT (acc_out = "0011110000111100")
        REPORT "Mismatch in acc_out with overlapping bits test!" SEVERITY ERROR;

        -- Test Case 17: Single bit high (MSB)
        acc_in    <= "1000000000000000";
        WAIT FOR 20 ns;
        ASSERT (acc_out = "1000000000000000")
        REPORT "Mismatch in acc_out with single MSB high!" SEVERITY ERROR;

        -- Test Case 18: Single bit high (LSB)
        acc_in    <= "0000000000000001";
        WAIT FOR 20 ns;
        ASSERT (acc_out = "0000000000000001")
        REPORT "Mismatch in acc_out with single LSB high!" SEVERITY ERROR;

        -- Test Case 19: Random pattern test
        acc_in    <= "0101101001011010";
        WAIT FOR 20 ns;
        ASSERT (acc_out = "0101101001011010")
        REPORT "Mismatch in acc_out with random pattern!" SEVERITY ERROR;

        -- Test Case 20: Full word change check
        acc_in    <= "1011111011101111";
        WAIT FOR 20 ns;
        ASSERT (acc_out = "1011111011101111")
        REPORT "Mismatch in acc_out with full word change check!" SEVERITY ERROR;

        -- End of test cases
        WAIT;
    END PROCESS stim_proc;

END sim;

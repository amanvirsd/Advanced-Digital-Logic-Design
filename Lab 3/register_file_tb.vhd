----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Antonio Andara Lara, Shyama Gandhi and Bruce Cockburn
-- Create Date: 10/28/2024 01:01:24 PM
-- Module Name: register_file_tb
-- Description: CPU LAB 3 - ECE 410 (2021)
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- Lab memebers: Amanvir Dhanoa and Zhiyuan Li
-----------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file_tb is
end register_file_tb;

architecture behavior of register_file_tb is

    -- Signals for the UUT
    signal clock        : std_logic := '0';
    signal rf_write     : std_logic;
    signal rf_mode      : std_logic;
    signal rf_address   : std_logic_vector(2 downto 0);
    signal rf0_in       : std_logic_vector(15 downto 0);
    signal rf1_in       : std_logic_vector(15 downto 0);
    signal rf0_out      : std_logic_vector(15 downto 0);
    signal rf1_out      : std_logic_vector(15 downto 0);

    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: entity work.register_file
        port map(
            clock      => clock,
            rf_write   => rf_write,
            rf_mode    => rf_mode,
            rf_address => rf_address,
            rf0_in     => rf0_in,
            rf1_in     => rf1_in,
            rf0_out    => rf0_out,
            rf1_out    => rf1_out
        );

    -- Clock process
    clk_process : process
    begin
        clock <= '0';
        wait for clk_period / 2;
        clock <= '1';
        wait for clk_period / 2;
    end process;

    -- Stimulus process
    stim_process : process
    begin
        -- Wait for global reset
        wait for clk_period;

        -------------------------------------------------------------------------
        -- Test Case 1: Single Access Mode - Write and Read Register 0
        -------------------------------------------------------------------------
        report "Test Case 1: Single Access Mode - Write and Read Register 0";
        rf_write   <= '1';                -- Enable write
        rf_mode    <= '0';                -- Single access mode
        rf_address <= "000";              -- Address 0
        rf0_in     <= x"1234";            -- Data to write
        rf1_in     <= (others => '0');    -- Not used in single mode

        wait for clk_period;              -- Wait for write to occur

        rf_write   <= '0';                -- Disable write (read mode)
        wait for clk_period;              -- Wait for read

        assert (rf0_out = x"1234") report "Error in Test Case 1: rf0_out should be x1234" severity error;
        assert (rf1_out = x"0000") report "Error in Test Case 1: rf1_out should be x0000" severity error;

        -------------------------------------------------------------------------
        -- Test Case 2: Single Access Mode - Write and Read Register 7
        -------------------------------------------------------------------------
        report "Test Case 2: Single Access Mode - Write and Read Register 7";
        rf_write   <= '1';
        rf_mode    <= '0';
        rf_address <= "111";              -- Address 7
        rf0_in     <= x"ABCD";

        wait for clk_period;

        rf_write   <= '0';
        wait for clk_period;

        assert (rf0_out = x"ABCD") report "Error in Test Case 2: rf0_out should be xABCD" severity error;
        assert (rf1_out = x"0000") report "Error in Test Case 2: rf1_out should be x0000" severity error;

        -------------------------------------------------------------------------
        -- Test Case 3: Dual Access Mode - Write and Read Registers 0 and 4
        -------------------------------------------------------------------------
        report "Test Case 3: Dual Access Mode - Write and Read Registers 0 and 4";
        rf_write   <= '1';
        rf_mode    <= '1';                -- Dual access mode
        rf_address <= "000";              -- Address 0
        rf0_in     <= x"1111";
        rf1_in     <= x"2222";

        wait for clk_period;

        rf_write   <= '0';
        wait for clk_period;

        assert (rf0_out = x"1111") report "Error in Test Case 3: rf0_out should be x1111" severity error;
        assert (rf1_out = x"2222") report "Error in Test Case 3: rf1_out should be x2222" severity error;

        -------------------------------------------------------------------------
        -- Test Case 4: Dual Access Mode - Write and Read Registers 3 and 7
        -------------------------------------------------------------------------
        report "Test Case 4: Dual Access Mode - Write and Read Registers 3 and 7";
        rf_write   <= '1';
        rf_mode    <= '1';
        rf_address <= "011";              -- Address 3
        rf0_in     <= x"3333";
        rf1_in     <= x"4444";

        wait for clk_period;

        rf_write   <= '0';
        wait for clk_period;

        assert (rf0_out = x"3333") report "Error in Test Case 4: rf0_out should be x3333" severity error;
        assert (rf1_out = x"4444") report "Error in Test Case 4: rf1_out should be x4444" severity error;

        -------------------------------------------------------------------------
        -- Test Case 5: Dual Access Mode - Write and Read Registers 4 and 0
        -------------------------------------------------------------------------
        report "Test Case 5: Dual Access Mode - Write and Read Registers 4 and 0";
        rf_write   <= '1';
        rf_mode    <= '1';
        rf_address <= "100";              -- Address 4
        rf0_in     <= x"5555";
        rf1_in     <= x"6666";

        wait for clk_period;

        rf_write   <= '0';
        wait for clk_period;

        assert (rf0_out = x"5555") report "Error in Test Case 5: rf0_out should be x5555" severity error;
        assert (rf1_out = x"6666") report "Error in Test Case 5: rf1_out should be x6666" severity error;

        -------------------------------------------------------------------------
        -- Test Case 6: Dual Access Mode - Write and Read Registers 5 and 1
        -------------------------------------------------------------------------
        report "Test Case 6: Dual Access Mode - Write and Read Registers 5 and 1";
        rf_write   <= '1';
        rf_mode    <= '1';
        rf_address <= "101";              -- Address 5
        rf0_in     <= x"7777";
        rf1_in     <= x"8888";

        wait for clk_period;

        rf_write   <= '0';
        wait for clk_period;

        assert (rf0_out = x"7777") report "Error in Test Case 6: rf0_out should be x7777" severity error;
        assert (rf1_out = x"8888") report "Error in Test Case 6: rf1_out should be x8888" severity error;

        -------------------------------------------------------------------------
        -- Test Case 7: Switching from Dual to Single Access Mode
        -------------------------------------------------------------------------
        report "Test Case 7: Switching from Dual to Single Access Mode";
        -- First, write in dual access mode
        rf_write   <= '1';
        rf_mode    <= '1';
        rf_address <= "010";              -- Address 2
        rf0_in     <= x"9999";
        rf1_in     <= x"AAAA";

        wait for clk_period;

        -- Now, read in single access mode
        rf_write   <= '0';
        rf_mode    <= '0';
        rf_address <= "010";              -- Address 2

        wait for clk_period;

        assert (rf0_out = x"9999") report "Error in Test Case 7: rf0_out should be x9999 after switching modes" severity error;

        rf_address <= "110";              -- Address 6 (2 + 4)
        wait for clk_period;

        assert (rf0_out = x"AAAA") report "Error in Test Case 7: rf0_out should be xAAAA when reading Address 6" severity error;

        -------------------------------------------------------------------------
        -- Test Case 8: Overwrite Register in Dual Access Mode
        -------------------------------------------------------------------------
        report "Test Case 8: Overwrite Register in Dual Access Mode";
        -- Write initial values
        rf_write   <= '1';
        rf_mode    <= '1';
        rf_address <= "001";              -- Address 1
        rf0_in     <= x"BBBB";
        rf1_in     <= x"CCCC";

        wait for clk_period;

        -- Overwrite in dual mode
        rf_write   <= '1';
        rf_mode    <= '1';
        rf_address <= "001";              -- Address 1
        rf0_in     <= x"DDDD";
        rf1_in     <= x"EEEE";

        wait for clk_period;

        rf_write   <= '0';
        wait for clk_period;

        assert (rf0_out = x"DDDD") report "Error in Test Case 8: rf0_out should be xDDDD after overwrite" severity error;
        assert (rf1_out = x"EEEE") report "Error in Test Case 8: rf1_out should be xEEEE after overwrite" severity error;

        -------------------------------------------------------------------------
        -- Test Case 9: Write and Read in Sequential Clock Cycles
        -------------------------------------------------------------------------
        report "Test Case 9: Write and Read in Sequential Clock Cycles";

        -- Write operation
        rf_write   <= '1';
        rf_mode    <= '0';
        rf_address <= "011";              -- Address 3
        rf0_in     <= x"FFFF";

        wait until rising_edge(clock);    -- Wait for write to occur
        rf_write   <= '0';                -- Disable write after clock edge

        -- Read operation in the next clock cycle
        wait until rising_edge(clock);
        rf_mode    <= '0';
        rf_address <= "011";              -- Address 3

        wait for clk_period / 2;          -- Wait for data to be available

        -- Check that the written value is now available
        assert (rf0_out = x"FFFF") report "Error in Test Case 9: rf0_out should be xFFFF after write" severity error;

        -------------------------------------------------------------------------
        -- Test Case 10: Clearing Registers and Reading
        -------------------------------------------------------------------------
        report "Test Case 10: Clearing Registers and Reading";
        -- Clear all registers by writing zeros
        for addr in 0 to 7 loop
            rf_write   <= '1';
            rf_mode    <= '1';
            rf_address <= std_logic_vector(to_unsigned(addr, 3));
            rf0_in     <= x"0000";
            wait until rising_edge(clock);
        end loop;

        rf_write   <= '0';
        rf_mode    <= '0';

        -- Read back from address 0
        rf_address <= "000";
        wait until rising_edge(clock);
        wait for clk_period;

        assert (rf0_out = x"0000") report "Error in Test Case 10: rf0_out should be x0000 after clearing registers" severity error;

        -- Finish simulation
        wait;
    end process;

end behavior;

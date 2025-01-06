----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Lab Members: Amanvir Dhanoa and Zhiyuan Li
-- 
-- Create Date   : 11/11/2024 05:30:00 PM
-- Module Name   : datapath_tb - Behavioral
-- Project Name  : CPU_LAB 3 - ECE 410
-- Target Device : FPGA
-- Tool Versions : Xilinx Vivado 2019
-- Description   : Testbench for verifying the datapath of the CPU.
-- 
--
-- Additional Comments:
-- - The testbench validates operations of the CPU datapath including ALU operations, register file access, 
--   and accumulator behavior.
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath_tb is
end datapath_tb;

architecture Behavioral of datapath_tb is

    -- Component declaration for the Unit Under Test (UUT)
    component datapath
        port (
            clock        : in std_logic;
            reset        : in std_logic;
            -- Control signals from the controller
            acc0_write   : in std_logic;
            acc1_write   : in std_logic;
            alu0_sel     : in std_logic_vector(3 downto 0);
            alu1_sel     : in std_logic_vector(3 downto 0);
          
            shift_amt  : in std_logic_vector(3 downto 0);
            rf_write     : in std_logic;
            rf_mode      : in std_logic;
            rf_address   : in std_logic_vector(2 downto 0);
            mux_sel      : in std_logic_vector(1 downto 0);
            acc_mux_sel  : in std_logic;
            alu_mux_sel  : in std_logic;
            output_en    : in std_logic;
            -- Data inputs
            immediate_data    : in std_logic_vector(15 downto 0);
            user_input   : in std_logic_vector(15 downto 0);
            -- Outputs
            acc0_out     : out std_logic_vector(15 downto 0);
            acc1_out     : out std_logic_vector(15 downto 0);
            rf0_out      : out std_logic_vector(15 downto 0);
            rf1_out      : out std_logic_vector(15 downto 0);
            alu0_out     : out std_logic_vector(15 downto 0);
            alu1_out     : out std_logic_vector(15 downto 0);
            buffer_output: out std_logic_vector(15 downto 0);
            zero_flag    : out std_logic;
            sign_flag : out std_logic
        );
    end component;

    -- Signals
    signal clock        : std_logic := '0';
    signal reset        : std_logic := '0';
    signal acc0_write   : std_logic := '0';
    signal acc1_write   : std_logic := '0';
    signal alu0_sel     : std_logic_vector(3 downto 0) := (others => '0');
    signal alu1_sel     : std_logic_vector(3 downto 0) := (others => '0');
    signal shift_amt : std_logic_vector(3 downto 0) := (others => '0');
    signal rf_write     : std_logic := '0';
    signal rf_mode      : std_logic := '0';
    signal rf_address   : std_logic_vector(2 downto 0) := (others => '0');
    signal mux_sel      : std_logic_vector(1 downto 0) := (others => '0');
    signal acc_mux_sel  : std_logic := '0';
    signal alu_mux_sel  : std_logic := '0';
    signal output_en    : std_logic := '0';
    signal immediate_data    : std_logic_vector(15 downto 0) := (others => '0');
    signal user_input   : std_logic_vector(15 downto 0) := (others => '0');
    signal acc0_out     : std_logic_vector(15 downto 0);
    signal acc1_out     : std_logic_vector(15 downto 0);
    signal rf0_out      : std_logic_vector(15 downto 0);
    signal rf1_out      : std_logic_vector(15 downto 0);
    signal alu0_out     : std_logic_vector(15 downto 0);
    signal alu1_out     : std_logic_vector(15 downto 0);
    signal buffer_output: std_logic_vector(15 downto 0);
    signal zero_flag    : std_logic;
    signal sign_flag: std_logic;
    signal alu0_out_captured : std_logic_vector(15 downto 0);


    constant clk_period : time := 10 ns;
    constant ZERO_VECTOR : std_logic_vector(15 downto 0) := (others => '0');

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: datapath
        port map (
            clock        => clock,
            reset        => reset,
            acc0_write   => acc0_write,
            acc1_write   => acc1_write,
            alu0_sel     => alu0_sel,
            alu1_sel     => alu1_sel,
            shift_amt  => shift_amt,
            rf_write     => rf_write,
            rf_mode      => rf_mode,
            rf_address   => rf_address,
            mux_sel      => mux_sel,
            acc_mux_sel  => acc_mux_sel,
            alu_mux_sel  => alu_mux_sel,
            output_en    => output_en,
            immediate_data    => immediate_data,
            user_input   => user_input,
            acc0_out     => acc0_out,
            acc1_out     => acc1_out,
            rf0_out      => rf0_out,
            rf1_out      => rf1_out,
            alu0_out     => alu0_out,
            alu1_out     => alu1_out,
            buffer_output=> buffer_output,
            zero_flag    => zero_flag,
            sign_flag=> sign_flag
        );

    -- Clock generation
    clk_process : process
    begin
        clock <= '0';
        wait for clk_period / 2;
        clock <= '1';
        wait for clk_period / 2;
    end process;

    -- Stimulus process
    stim_process : process
        variable expected_value : std_logic_vector(15 downto 0);
        variable sign_bit       : std_logic;
        variable temp_unsigned  : unsigned(15 downto 0);
    begin
        -- Apply reset
        reset <= '1';
        wait for clk_period;
        reset <= '0';

        -- Wait for reset to propagate
        wait for clk_period;

        -------------------------------------------------------------------------
        -- Test Case 1: Load immediate data into Accumulator 0
        -------------------------------------------------------------------------
        report "Test Case 1: Load immediate_data data into Accumulator 0";
        immediate_data <= x"1234";
        mux_sel <= "10"; -- Select immediate_data data
        acc0_write <= '1'; -- Enable writing to Accumulator 0

        -- Wait for next rising edge
        wait until rising_edge(clock);
        acc0_write <= '0'; -- Disable write after clock edge

        -- Wait for data to propagate
        wait for clk_period / 2;

        -- Compute expected sign_flag and zero_flag
        sign_bit := immediate_data(15);
        assert acc0_out = x"1234" report "Test Case 1 Failed: Accumulator 0 incorrect" severity error;
        assert zero_flag = '0' report "Test Case 1 Failed: Zero flag should be 0" severity error;
        assert sign_flag = not sign_bit report "Test Case 1 Failed: Positive flag incorrect" severity error;

        -------------------------------------------------------------------------
        -- Test Case 2: Load user input into Accumulator 0
        -------------------------------------------------------------------------
        report "Test Case 2: Load user input into Accumulator 0";
        user_input <= x"ABCD";
        mux_sel <= "11"; -- Select user input
        acc0_write <= '1';

        wait until rising_edge(clock);
        acc0_write <= '0';

        wait for clk_period / 2;

        sign_bit := user_input(15);
        assert acc0_out = x"ABCD" report "Test Case 2 Failed: Accumulator 0 incorrect" severity error;
        assert zero_flag = '0' report "Test Case 2 Failed: Zero flag should be 0" severity error;
        assert sign_flag = not sign_bit report "Test Case 2 Failed: Positive flag incorrect" severity error;

        -------------------------------------------------------------------------
        -- Test Case 3: Load zero into Accumulator 0
        -------------------------------------------------------------------------
        report "Test Case 3: Load zero into Accumulator 0";
        immediate_data <= ZERO_VECTOR; -- Zero value
        mux_sel <= "10"; -- Select immediate_data data
        acc0_write <= '1';

        wait until rising_edge(clock);
        acc0_write <= '0';

        wait for clk_period / 2;

        sign_bit := immediate_data(15);
        assert acc0_out = ZERO_VECTOR report "Test Case 3 Failed: Accumulator 0 incorrect" severity error;
        assert zero_flag = '1' report "Test Case 3 Failed: Zero flag should be 1" severity error;
        assert sign_flag = '1' report "Test Case 3 Failed: Positive flag should be 1" severity error;

        -------------------------------------------------------------------------
        -- Test Case 4: Load negative value into Accumulator 0
        -------------------------------------------------------------------------
        report "Test Case 4: Load negative value into Accumulator 0";
        immediate_data <= x"8000"; -- Negative value (most significant bit set)
        mux_sel <= "10"; -- Select immediate_data data
        acc0_write <= '1';

        wait until rising_edge(clock);
        acc0_write <= '0';

        wait for clk_period / 2;

        sign_bit := immediate_data(15);
        assert acc0_out = x"8000" report "Test Case 4 Failed: Accumulator 0 incorrect" severity error;
        assert zero_flag = '0' report "Test Case 4 Failed: Zero flag should be 0" severity error;
        assert sign_flag = not sign_bit report "Test Case 4 Failed: Positive flag incorrect" severity error;

        -------------------------------------------------------------------------
        -- Test Case 5: Write Accumulator 0 to Register 0
        -------------------------------------------------------------------------
        report "Test Case 5: Write Accumulator 0 to Register 0";
        rf_address <= "000"; -- Address 0
        rf_write <= '1';
        rf_mode <= '0'; -- Single access mode

        wait until rising_edge(clock);
        rf_write <= '0';

        wait for clk_period / 2;

        -- Read back from Register 0
        rf_address <= "000";
        rf_mode <= '0';
        wait for clk_period;

        assert rf0_out = acc0_out report "Test Case 5 Failed: rf0_out incorrect" severity error;

 -------------------------------------------------------------------
-- Test Case 6: ALU0 Addition
-------------------------------------------------------------------
report "Test Case 6: ALU0 Addition";

-- Step 1: Write value into Register 0
immediate_data <= x"0005";  -- First operand
mux_sel <= "10";       -- Select immediate_data
acc0_write <= '1';     -- Write to Accumulator 0

wait until rising_edge(clock);
acc0_write <= '0';     -- Disable write

wait for clk_period / 2;

rf_address <= "000";   -- Select Register 0
rf_write <= '1';       -- Write to Register File

wait until rising_edge(clock);
rf_write <= '0';       -- Disable write

wait for clk_period / 2;

-- Step 2: Write another value into Accumulator 0
immediate_data <= x"0003";  -- Second operand
mux_sel <= "10";       -- Select immediate_data
acc0_write <= '1';     -- Write to Accumulator 0

wait until rising_edge(clock);
acc0_write <= '0';     -- Disable write

wait for clk_period / 2;

-- Step 3: Configure ALU for Addition
alu0_sel <= "0101";    -- Addition operation
alu_mux_sel <= '1';    -- Select acc0_internal as B input
rf_address <= "000";   -- Select Register 0 for A input

-- Step 4: Store Result in Accumulator 0
mux_sel <= "00";       -- Select alu0_out
acc0_write <= '1';     -- Enable write to Accumulator 0

wait until rising_edge(clock);
acc0_write <= '0';     -- Disable write

wait for clk_period / 2;

-- Step 5: Verify Result
expected_value := std_logic_vector(unsigned(to_unsigned(5, 16)) + unsigned(to_unsigned(3, 16)));
assert acc0_out = expected_value report "Test Case 6 Failed: Accumulator 0 incorrect" severity error;

 -------------------------------------------------------------------------
-- Test Case 7: ALU0 Subtraction
-------------------------------------------------------------------------
report "Test Case 7: ALU0 Subtraction";

-- Step 1: Load value into Accumulator 0
immediate_data <= x"0008";  -- First operand
mux_sel <= "10";       -- Select immediate_data
acc0_write <= '1';     -- Enable write to Accumulator 0

wait until rising_edge(clock);
acc0_write <= '0';     -- Disable write

wait for clk_period / 2;

-- Step 2: Write Accumulator 0 to Register 2
rf_address <= "010";   -- Select Register 2
rf_write <= '1';       -- Enable write to Register File
rf_mode <= '0';        -- Single access mode

wait until rising_edge(clock);
rf_write <= '0';       -- Disable write

wait for clk_period / 2;

-- Step 3: Load another value into Accumulator 0
immediate_data <= x"0002";  -- Second operand
mux_sel <= "10";       -- Select immediate_data
acc0_write <= '1';     -- Enable write to Accumulator 0

wait until rising_edge(clock);
acc0_write <= '0';     -- Disable write

wait for clk_period / 2;

-- Step 4: Perform Subtraction: rf0_out - acc0_internal
alu0_sel <= "0110";    -- Subtraction operation
alu_mux_sel <= '1';    -- Select acc0_internal as B input
rf_address <= "010";   -- Select Register 2 for A input
mux_sel <= "00";       -- Select alu0_out
acc0_write <= '1';     -- Enable write to Accumulator 0

wait until rising_edge(clock);
acc0_write <= '0';     -- Disable write

wait for clk_period / 2;

-- Step 5: Verify Result
expected_value := std_logic_vector(unsigned(to_unsigned(8, 16)) - unsigned(to_unsigned(2, 16)));
assert acc0_out = expected_value report "Test Case 7 Failed: Accumulator 0 incorrect" severity error;

  -------------------------------------------------------------------------
-- Test Case 8: ALU0 AND Operation
-------------------------------------------------------------------------
report "Test Case 8: ALU0 AND Operation";

-- Step 1: Load first value into Accumulator 0 (First Operand)
immediate_data <= std_logic_vector(to_unsigned(3855, 16)); -- Binary: 0000111100001111
mux_sel <= "10";       -- Select immediate_data
acc0_write <= '1';     -- Enable write to Accumulator 0

wait until rising_edge(clock);
acc0_write <= '0';     -- Disable write

wait for clk_period / 2;

-- Step 2: Write Accumulator 0 to Register 3
rf_address <= "011";   -- Select Register 3
rf_write <= '1';       -- Enable write to Register File
rf_mode <= '0';        -- Single access mode

wait until rising_edge(clock);
rf_write <= '0';       -- Disable write

wait for clk_period / 2;

-- Step 3: Load another value into Accumulator 0 (Second Operand)
immediate_data <= std_logic_vector(to_unsigned(255, 16)); -- Binary: 0000000011111111
mux_sel <= "10";       -- Select immediate_data
acc0_write <= '1';     -- Enable write to Accumulator 0

wait until rising_edge(clock);
acc0_write <= '0';     -- Disable write

wait for clk_period / 2;

-- Step 4: Perform AND operation
alu0_sel <= "1001";    -- AND operation
alu_mux_sel <= '1';    -- Select acc0_internal as B input
rf_address <= "011";   -- Select Register 3 for A input
mux_sel <= "00";       -- Select alu0_out
acc0_write <= '1';     -- Enable write to Accumulator 0

wait until rising_edge(clock);
acc0_write <= '0';     -- Disable write

wait for clk_period / 2;

-- Step 5: Verify Result
expected_value := std_logic_vector(unsigned(to_unsigned(3855, 16)) AND unsigned(to_unsigned(255, 16)));
assert acc0_out = expected_value report "Test Case 8 Failed: Accumulator 0 incorrect" severity error;

    -------------------------------------------------------------------------
    -- Test Case 9: ALU0 OR Operation
    -------------------------------------------------------------------------
    report "Test Case 9: ALU0 OR Operation";
    
    -- Step 1: Load value into Accumulator 0 (First Operand)
    immediate_data <= std_logic_vector(to_unsigned(3855, 16)); -- Binary: 0000111100001111
    mux_sel <= "10";       -- Select immediate_data
    acc0_write <= '1';

    wait until rising_edge(clock);
    acc0_write <= '0';

    wait for clk_period / 2;

    -- Step 2: Write Accumulator 0 to Register 4
    rf_address <= "100";
    rf_write <= '1';
    rf_mode <= '0';

    wait until rising_edge(clock);
    rf_write <= '0';

    wait for clk_period / 2;

    -- Step 3: Load another value into Accumulator 0 (Second Operand)
    immediate_data <= std_logic_vector(to_unsigned(65280, 16)); -- Binary: 1111111100000000
    mux_sel <= "10";
    acc0_write <= '1';

    wait until rising_edge(clock);
    acc0_write <= '0';

    wait for clk_period / 2;

    -- Step 4: Perform OR operation
    alu0_sel <= "1010";    -- OR operation
    alu_mux_sel <= '1';
    rf_address <= "100";
    mux_sel <= "00";
    acc0_write <= '1';

    wait until rising_edge(clock);
    acc0_write <= '0';

    wait for clk_period / 2;

    -- Step 5: Verify Result
    expected_value := std_logic_vector(unsigned(to_unsigned(3855, 16)) OR unsigned(to_unsigned(65280, 16)));
    assert acc0_out = expected_value report "Test Case 9 Failed: Accumulator 0 incorrect" severity error;

    -------------------------------------------------------------------------
    -- Test Case 10: ALU0 NOT Operation
    -------------------------------------------------------------------------
    report "Test Case 10: ALU0 NOT Operation";
    
    -- <= std_logic_vector(to_unsigned(0x0F0F, 16)); -- 0000111100001111
    mux_sel <= "10";
    acc0_write <= '1';

    wait until rising_edge(clock);
    acc0_write <= '0';

    wait for clk_period / 2;

    alu0_sel <= "1011";    -- NOT operation
    mux_sel <= "00";
    acc0_write <= '1';

    wait until rising_edge(clock);
    acc0_write <= '0';

    wait for clk_period / 2;

    expected_value := std_logic_vector(NOT unsigned(to_unsigned(3855, 16)));
    assert acc0_out = expected_value report "Test Case 10 Failed: Accumulator 0 incorrect" severity error;

-- Test Case 11: Shift Left Accumulator 0
report "Test Case 11: Shift Left Accumulator 0";

-- Step 1: Load immediate_data value x"0001" into Accumulator 0
immediate_data <= x"0001";
mux_sel <= "10"; -- Select immediate_data data to load into acc0
acc0_write <= '1'; -- Enable writing to acc0
wait until rising_edge(clock);
acc0_write <= '0'; -- Disable write

-- Wait for data to propagate and verify initial load
wait for clk_period / 2;
report "Debug: Accumulator 0 Value (After Load): " & integer'image(to_integer(unsigned(acc0_out)));

-- Step 2: Configure ALU to perform Shift Left operation
alu0_sel <= "0011"; -- Shift Left operation
shift_amt <= "0001"; -- Shift by 1
mux_sel <= "00"; -- Select alu0_out for writing back to acc0
wait for clk_period; -- Allow ALU to perform shift

-- Debugging ALU operation
report "Debug: ALU0 Input A (Accumulator 0): " & integer'image(to_integer(unsigned(acc0_out)));
report "Debug: Shift Amount: " & integer'image(to_integer(unsigned(shift_amt)));
report "Debug: ALU0 Output (Shift Left): " & integer'image(to_integer(unsigned(alu0_out)));

-- Step 3: Write ALU output (shift result) back to Accumulator 0
acc0_write <= '1'; -- Enable write back to acc0
wait until rising_edge(clock);
acc0_write <= '0'; -- Disable write

-- Wait for data to propagate and verify final write-back
wait for clk_period / 2;
report "Debug: Accumulator 0 Value (After Write Back): " & integer'image(to_integer(unsigned(acc0_out)));

-- Expected result after shifting "0001" by 1 bit left should be "0002"
expected_value := std_logic_vector(to_unsigned(2, 16));
report "Debug: Expected Value After Shift Left: " & integer'image(to_integer(unsigned(expected_value)));

-- Step 4: Verify the result
if acc0_out = expected_value then
    report "Test Case 11 Passed: Accumulator 0 is correct." severity note;
else
    report "Test Case 11 Failed: Accumulator 0 incorrect. Expected: " & 
           integer'image(to_integer(unsigned(expected_value))) & 
           " Actual: " & integer'image(to_integer(unsigned(acc0_out))) severity error;
end if;


    -------------------------------------------------------------------------
    -- Test Case 12: Shift Right Accumulator 0
    -------------------------------------------------------------------------
    report "Test Case 12: Shift Right Accumulator 0";

-- Step 1: Load immediate_data value x"000F" (15) into Accumulator 0
immediate_data <= x"000F";
mux_sel <= "10"; -- Select immediate_data data
acc0_write <= '1'; -- Write to acc0
wait until rising_edge(clock);
acc0_write <= '0'; -- Disable write

-- Wait for data to propagate
wait for clk_period / 2;
report "Debug: Accumulator 0 Value (After Load): " & integer'image(to_integer(unsigned(acc0_out)));

-- Step 2: Configure ALU for Shift Right operation
alu0_sel <= "0100"; -- Shift Right operation
shift_amt <= "0001"; -- Shift by 1
mux_sel <= "00"; -- ALU output
acc0_write <= '1'; -- Write back to acc0
wait until rising_edge(clock);
acc0_write <= '0'; -- Disable write

-- Wait for data to propagate
wait for clk_period / 2;

-- Step 3: Verify the result
report "Debug: ALU0 Output (Shift Right): " & integer'image(to_integer(unsigned(alu0_out)));
expected_value := std_logic_vector(shift_right(unsigned(to_unsigned(15, 16)), 1)); -- Expected value: 7
report "Debug: Expected Value After Shift Right: " & integer'image(to_integer(unsigned(expected_value)));
if acc0_out = expected_value then
    report "Test Case 12 Passed: Accumulator 0 is correct." severity note;
else
    report "Test Case 12 Failed: Accumulator 0 incorrect. Expected: " & 
           integer'image(to_integer(unsigned(expected_value))) & 
           " Actual: " & integer'image(to_integer(unsigned(acc0_out))) severity error;
end if;

    -------------------------------------------------------------------------
    -- Test Case 13: ALU0 Increment Operation
    -------------------------------------------------------------------------
    report "Test Case 13: ALU0 Increment Operation";

-- Step 1: Load immediate_data value x"000F" (15) into Accumulator 0
immediate_data <= x"000F";
mux_sel <= "10"; -- Select immediate_data data
acc0_write <= '1'; -- Write to acc0
wait until rising_edge(clock);
acc0_write <= '0'; -- Disable write

-- Wait for data to propagate
wait for clk_period / 2;
report "Debug: Accumulator 0 Value (After Load): " & integer'image(to_integer(unsigned(acc0_out)));

-- Step 2: Configure ALU for Increment operation
alu0_sel <= "0111"; -- Increment operation
mux_sel <= "00"; -- ALU output
acc0_write <= '1'; -- Write back to acc0
wait until rising_edge(clock);
acc0_write <= '0'; -- Disable write

-- Wait for data to propagate
wait for clk_period / 2;

-- Step 3: Verify the result
report "Debug: ALU0 Output (Increment): " & integer'image(to_integer(unsigned(alu0_out)));
expected_value := std_logic_vector(unsigned(to_unsigned(15, 16)) + 1); -- Expected value: 16
report "Debug: Expected Value After Increment: " & integer'image(to_integer(unsigned(expected_value)));
if acc0_out = expected_value then
    report "Test Case 13 Passed: Accumulator 0 is correct." severity note;
else
    report "Test Case 13 Failed: Accumulator 0 incorrect. Expected: " & 
           integer'image(to_integer(unsigned(expected_value))) & 
           " Actual: " & integer'image(to_integer(unsigned(acc0_out))) severity error;
end if;

    -------------------------------------------------------------------------
    -- Test Case 14: ALU0 Decrement Operation
    -------------------------------------------------------------------------
   report "Test Case 14: ALU0 Decrement Operation";

-- Step 1: Load immediate_data value x"0010" (16) into Accumulator 0
immediate_data <= x"0010";
mux_sel <= "10"; -- Select immediate_data data
acc0_write <= '1'; -- Write to acc0
wait until rising_edge(clock);
acc0_write <= '0'; -- Disable write

-- Wait for data to propagate
wait for clk_period / 2;
report "Debug: Accumulator 0 Value (After Load): " & integer'image(to_integer(unsigned(acc0_out)));

-- Step 2: Configure ALU for Decrement operation
alu0_sel <= "1000"; -- Decrement operation
mux_sel <= "00"; -- ALU output
acc0_write <= '1'; -- Write back to acc0
wait until rising_edge(clock);
acc0_write <= '0'; -- Disable write

-- Wait for data to propagate
wait for clk_period / 2;

-- Step 3: Verify the result
report "Debug: ALU0 Output (Decrement): " & integer'image(to_integer(unsigned(alu0_out)));
expected_value := std_logic_vector(unsigned(to_unsigned(16, 16)) - 1); -- Expected value: 15
report "Debug: Expected Value After Decrement: " & integer'image(to_integer(unsigned(expected_value)));
if acc0_out = expected_value then
    report "Test Case 14 Passed: Accumulator 0 is correct." severity note;
else
    report "Test Case 14 Failed: Accumulator 0 incorrect. Expected: " & 
           integer'image(to_integer(unsigned(expected_value))) & 
           " Actual: " & integer'image(to_integer(unsigned(acc0_out))) severity error;
end if;


    -------------------------------------------------------------------------
    -- Test Case 15: Tri-State Buffer Enabled
    -------------------------------------------------------------------------
    report "Test Case 15: Tri-State Buffer Enabled";
    
    output_en <= '1';

    wait for clk_period;

    assert buffer_output = acc0_out report "Test Case 15 Failed: Buffer output incorrect" severity error;

    -------------------------------------------------------------------------
    -- Test Case 16: Tri-State Buffer Disabled
    -------------------------------------------------------------------------

    report "Test Case 16: Tri-State Buffer Disabled";

    output_en <= '0';

    wait for clk_period;

    -- Check if each bit in buffer_output is 'Z'
    for i in buffer_output'range loop
        assert buffer_output(i) = 'Z' report "Test Case 16 Failed: Buffer output should be high-impedance" severity error;
    end loop;


-----------------------------------------------------------------------
-- Test Case 17: Accumulator 1 Operations
-----------------------------------------------------------------------
report "Test Case 17: Accumulator 1 Operations";

-- Step 1: Load value into Accumulator 0 (Input for ALU1 - B)
immediate_data <= x"0003"; -- Load value 3
mux_sel <= "10";      -- Select immediate_data data
acc0_write <= '1';    -- Enable writing to acc0
wait until rising_edge(clock);
acc0_write <= '0';    -- Disable write

-- Wait for propagation
wait for clk_period / 2;
report "Debug: Accumulator 0 Value (Input to ALU1 - B): " & integer'image(to_integer(unsigned(acc0_out)));

-- Step 2: Write value into Register File at register 4 (Input for ALU1 - A)
immediate_data <= x"0005"; -- Load value 5
mux_sel <= "10";      -- Select immediate_data data
acc0_write <= '1';    -- Enable writing to acc0
wait until rising_edge(clock);
acc0_write <= '0';    -- Disable write

-- Now write acc0_internal (which is 5) into register 4
rf_address <= "100";  -- Address 4
rf_write <= '1';      -- Enable writing to Register File
rf_mode <= '0';       -- Single access mode
wait until rising_edge(clock);
rf_write <= '0';      -- Disable write

-- Wait for propagation
wait for clk_period / 2;
report "Debug: Value Written to Register File at Address 4: " & integer'image(to_integer(unsigned(acc0_out)));

-- Step 3: Set rf_mode to '1' to read both registers 0 and 4
rf_mode <= '1';       -- Dual access mode
rf_address <= "000";  -- Address 0 (will read registers 0 and 4)
wait for clk_period;
report "Debug: Register File Output rf1_out_internal (Input to ALU1 - A): " & integer'image(to_integer(unsigned(rf1_out)));

-- Step 4: Configure ALU1 for Addition
alu1_sel <= "0101"; -- ALU1 Addition
report "Debug: ALU1 Operation Code (alu1_sel): 0101";

-- Step 5: Write ALU1 Output to Accumulator 1
acc1_write <= '1'; -- Enable writing to acc1
wait until rising_edge(clock);
acc1_write <= '0'; -- Disable write

-- Wait for propagation
wait for clk_period / 2;
report "Debug: Accumulator 1 Value (After Write Back): " & integer'image(to_integer(unsigned(acc1_out)));

-- Step 6: Verify the Result
expected_value := std_logic_vector(unsigned(rf1_out) + unsigned(acc0_out)); -- Expected: 5 + 3 = 8
report "Debug: Expected Value for Accumulator 1: " & integer'image(to_integer(unsigned(expected_value)));

if acc1_out = expected_value then
    report "Test Case 17 Passed: Accumulator 1 is correct." severity note;
else
    report "Test Case 17 Failed: Accumulator 1 incorrect. Expected: " & 
           integer'image(to_integer(unsigned(expected_value))) & 
           " Actual: " & integer'image(to_integer(unsigned(acc1_out))) severity error;
end if;
------------------------------------------------------------------------
-- Test Case 18: ALU1 Subtraction
------------------------------------------------------------------------
report "Test Case 18: ALU1 Subtraction";

-- Step 1: Load value into Accumulator 0 (Input for ALU1 - B)
immediate_data <= x"0002"; -- Load value 2
mux_sel <= "10";      -- Select immediate_data data
acc0_write <= '1';    -- Enable writing to acc0
wait until rising_edge(clock);
acc0_write <= '0';    -- Disable write

wait for clk_period / 2;

-- Step 2: Write value into Register File at register 4 (Input for ALU1 - A)
immediate_data <= x"000A"; -- Load value 10
mux_sel <= "10";
acc0_write <= '1';
wait until rising_edge(clock);
acc0_write <= '0';

wait for clk_period / 2;

-- Write acc0_internal into register 4
rf_address <= "100";
rf_write <= '1';
rf_mode <= '0';
wait until rising_edge(clock);
rf_write <= '0';

wait for clk_period / 2;

-- Step 3: Set rf_mode to '1' to read registers 0 and 4
rf_mode <= '1';
rf_address <= "000";
wait for clk_period;

-- Step 4: Configure ALU1 for Subtraction
alu1_sel <= "0110"; -- ALU1 Subtraction

-- Step 5: Write ALU1 Output to Accumulator 1
acc1_write <= '1';
wait until rising_edge(clock);
acc1_write <= '0';

wait for clk_period / 2;

-- Step 6: Verify the Result
expected_value := std_logic_vector(unsigned(rf1_out) - unsigned(acc0_out)); -- Expected: 10 - 2 = 8

if acc1_out = expected_value then
    report "Test Case 18 Passed: Accumulator 1 is correct." severity note;
else
    report "Test Case 18 Failed: Accumulator 1 incorrect. Expected: " & 
           integer'image(to_integer(unsigned(expected_value))) & 
           " Actual: " & integer'image(to_integer(unsigned(acc1_out))) severity error;
end if;
------------------------------------------------------------------------
-- Test Case 19: ALU1 AND Operation
------------------------------------------------------------------------
report "Test Case 19: ALU1 AND Operation";

-- Load value x"00FF" into Accumulator 0 (B input)
immediate_data <= x"00FF";
mux_sel <= "10";
acc0_write <= '1';
wait until rising_edge(clock);
acc0_write <= '0';

wait for clk_period / 2;

-- Write value x"0F0F" into register 4 (A input)
immediate_data <= x"0F0F";
mux_sel <= "10";
acc0_write <= '1';
wait until rising_edge(clock);
acc0_write <= '0';

wait for clk_period / 2;

rf_address <= "100";
rf_write <= '1';
rf_mode <= '0';
wait until rising_edge(clock);
rf_write <= '0';

wait for clk_period / 2;

-- Set rf_mode to '1' and read registers
rf_mode <= '1';
rf_address <= "000";
wait for clk_period;

-- Configure ALU1 for AND operation
alu1_sel <= "1001";

-- Write ALU1 Output to Accumulator 1
acc1_write <= '1';
wait until rising_edge(clock);
acc1_write <= '0';

wait for clk_period / 2;

-- Verify the Result
expected_value := rf1_out and acc0_out; -- Expected: x"0F0F" AND x"00FF" = x"000F"

if acc1_out = expected_value then
    report "Test Case 19 Passed: Accumulator 1 is correct." severity note;
else
    report "Test Case 19 Failed: Accumulator 1 incorrect." severity error;
end if;
------------------------------------------------------------------------
-- Test Case 20: ALU1 OR Operation
------------------------------------------------------------------------
report "Test Case 20: ALU1 OR Operation";

-- Load value x"00FF" into Accumulator 0
immediate_data <= x"00FF";
mux_sel <= "10";
acc0_write <= '1';
wait until rising_edge(clock);
acc0_write <= '0';

wait for clk_period / 2;

-- Write value x"0F00" into register 4
immediate_data <= x"0F00";
mux_sel <= "10";
acc0_write <= '1';
wait until rising_edge(clock);
acc0_write <= '0';

wait for clk_period / 2;

rf_address <= "100";
rf_write <= '1';
rf_mode <= '0';
wait until rising_edge(clock);
rf_write <= '0';

wait for clk_period / 2;

-- Set rf_mode to '1' and read registers
rf_mode <= '1';
rf_address <= "000";
wait for clk_period;

-- Configure ALU1 for OR operation
alu1_sel <= "1010";

-- Write ALU1 Output to Accumulator 1
acc1_write <= '1';
wait until rising_edge(clock);
acc1_write <= '0';

wait for clk_period / 2;

-- Verify the Result
expected_value := rf1_out or acc0_out; -- Expected: x"0F00" OR x"00FF" = x"0FFF"

if acc1_out = expected_value then
    report "Test Case 20 Passed: Accumulator 1 is correct." severity note;
else
    report "Test Case 20 Failed: Accumulator 1 incorrect." severity error;
end if;
------------------------------------------------------------------------
-- Test Case 21: ALU1 Shift Left Operation
------------------------------------------------------------------------
report "Test Case 21: ALU1 Shift Left Operation";

-- Load value x"0001" into Accumulator 0
immediate_data <= x"0001";
mux_sel <= "10";
acc0_write <= '1';
wait until rising_edge(clock);
acc0_write <= '0';

wait for clk_period / 2;

-- Configure ALU1 for Shift Left
alu1_sel <= "0011";
shift_amt<= "0001"; -- Shift by 1

-- Write ALU1 Output to Accumulator 1
acc1_write <= '1';
mux_sel <= "00"; -- Select ALU1 output
wait until rising_edge(clock);
acc1_write <= '0';

wait for clk_period / 2;

-- Verify the Result
expected_value := std_logic_vector(shift_left(unsigned(acc0_out), 1)); -- Expected: x"0002"

if acc1_out = expected_value then
    report "Test Case 21 Passed: Accumulator 1 is correct." severity note;
else
    report "Test Case 21 Failed: Accumulator 1 incorrect." severity error;
end if;
------------------------------------------------------------------------
-- Test Case 22: ALU1 Shift Right Operation
------------------------------------------------------------------------
report "Test Case 22: ALU1 Shift Right Operation";

-- Load value x"0002" into Accumulator 0
immediate_data <= x"0002";
mux_sel <= "10";
acc0_write <= '1';
wait until rising_edge(clock);
acc0_write <= '0';

wait for clk_period / 2;

-- Configure ALU1 for Shift Right
alu1_sel <= "0100";
shift_amt <= "0001"; -- Shift by 1

-- Write ALU1 Output to Accumulator 1
acc1_write <= '1';
mux_sel <= "00"; -- Select ALU1 output
wait until rising_edge(clock);
acc1_write <= '0';

wait for clk_period / 2;

-- Verify the Result
expected_value := std_logic_vector(shift_right(unsigned(acc0_out), 1)); -- Expected: x"0001"

if acc1_out = expected_value then
    report "Test Case 22 Passed: Accumulator 1 is correct." severity note;
else
    report "Test Case 22 Failed: Accumulator 1 incorrect." severity error;
end if;
------------------------------------------------------------------------
-- Test Case 23: Accumulator 1 Increment Operation
------------------------------------------------------------------------
report "Test Case 23: Accumulator 1 Increment Operation";

-- Load value x"0005" into Accumulator 0
immediate_data <= x"0005";
mux_sel <= "10";
acc0_write <= '1';
wait until rising_edge(clock);
acc0_write <= '0';

wait for clk_period / 2;

-- Configure ALU1 for Increment
alu1_sel <= "0111";

-- Write ALU1 Output to Accumulator 1
acc1_write <= '1';
mux_sel <= "00";
wait until rising_edge(clock);
acc1_write <= '0';

wait for clk_period / 2;

-- Verify the Result
expected_value := std_logic_vector(unsigned(acc0_out) + 1); -- Expected: x"0006"

if acc1_out = expected_value then
    report "Test Case 23 Passed: Accumulator 1 is correct." severity note;
else
    report "Test Case 23 Failed: Accumulator 1 incorrect." severity error;
end if;
------------------------------------------------------------------------
-- Test Case 24: Accumulator 1 Decrement Operation
------------------------------------------------------------------------
report "Test Case 24: Accumulator 1 Decrement Operation";

-- Load value x"0005" into Accumulator 0
immediate_data <= x"0005";
mux_sel <= "10";
acc0_write <= '1';
wait until rising_edge(clock);
acc0_write <= '0';

wait for clk_period / 2;

-- Configure ALU1 for Decrement
alu1_sel <= "1000";

-- Write ALU1 Output to Accumulator 1
acc1_write <= '1';
mux_sel <= "00";
wait until rising_edge(clock);
acc1_write <= '0';

wait for clk_period / 2;

-- Verify the Result
expected_value := std_logic_vector(unsigned(acc0_out) - 1); -- Expected: x"0004"

if acc1_out = expected_value then
    report "Test Case 24 Passed: Accumulator 1 is correct." severity note;
else
    report "Test Case 24 Failed: Accumulator 1 incorrect." severity error;
end if;
------------------------------------------------------------------------
-- Test Case 25: ALU1 NOT Operation (Corrected)
------------------------------------------------------------------------
report "Test Case 25: ALU1 NOT Operation (Corrected)";

-- Step 1: Load value x"FFFF" into Accumulator 0
immediate_data <= x"FFFF";
mux_sel <= "10";
acc0_write <= '1';
wait until rising_edge(clock);
acc0_write <= '0';

wait for clk_period / 2;

-- Step 2: Configure ALU1 for NOT operation on B (acc0_internal)
alu1_sel <= "1100"; -- "1100" corresponds to "Logical NOT of B" in your ALU

-- Step 3: Write ALU1 Output to Accumulator 1
acc1_write <= '1';
mux_sel <= "00"; -- Select ALU1 output
wait until rising_edge(clock);
acc1_write <= '0';

wait for clk_period / 2;

-- Step 4: Verify the Result
expected_value := not acc0_out; -- Expected: x"0000"

if acc1_out = expected_value then
    report "Test Case 25 Passed: Accumulator 1 is correct." severity note;
else
    report "Test Case 25 Failed: Accumulator 1 incorrect." severity error;
end if;

------------------------------------------------------------------------
-- Test Case 26: Zero and Positive Flag Verification for Accumulator 1
------------------------------------------------------------------------
report "Test Case 26: Zero and Positive Flag Verification for Accumulator 1";

-- Load zero into Accumulator 1
immediate_data <= x"0000";
mux_sel <= "10";
acc1_write <= '1';
wait until rising_edge(clock);
acc1_write <= '0';

wait for clk_period / 2;

-- Verify zero_flag and sign_flag
if zero_flag = '1' and sign_flag = '1' then
    report "Test Case 26 Passed: Zero and Positive Flags are correct for zero value." severity note;
else
    report "Test Case 26 Failed: Zero and Positive Flags incorrect for zero value." severity error;
end if;

-- Load negative value into Accumulator 1
immediate_data <= x"8000"; -- Negative value
mux_sel <= "10";
acc1_write <= '1';
wait until rising_edge(clock);
acc1_write <= '0';

wait for clk_period / 2;

-- Verify zero_flag and sign_flag
if zero_flag = '0' and sign_flag = '0' then
    report "Test Case 26 Passed: Zero and Positive Flags are correct for negative value." severity note;
else
    report "Test Case 26 Failed: Zero and Positive Flags incorrect for negative value." severity error;
end if;
------------------------------------------------------------------------
-- Test Case 27: MUX4 Selection - immediate_data Data
------------------------------------------------------------------------
report "Test Case 27: MUX4 Selection - immediate_data Data";

-- Set immediate_data value
immediate_data <= x"1234";
mux_sel <= "10"; -- Select immediate_data data

-- Write to Accumulator 0 to capture the mux output
acc0_write <= '1';
wait until rising_edge(clock);
acc0_write <= '0';

wait for clk_period / 2;

-- Verify that Accumulator 0 received the immediate_data data
assert acc0_out = immediate_data report "Test Case 27 Failed: Accumulator 0 did not receive immediate_data data correctly." severity error;

report "Test Case 27 Passed: Accumulator 0 received immediate_data data correctly." severity note;

------------------------------------------------------------------------
-- Test Case 28: MUX4 Selection - User Input
------------------------------------------------------------------------
report "Test Case 28: MUX4 Selection - User Input";

-- Set user input value
user_input <= x"ABCD";
mux_sel <= "11"; -- Select user input

-- Write to Accumulator 0 to capture the mux output
acc0_write <= '1';
wait until rising_edge(clock);
acc0_write <= '0';

wait for clk_period / 2;

-- Verify that Accumulator 0 received the user input
assert acc0_out = user_input report "Test Case 28 Failed: Accumulator 0 did not receive user input correctly." severity error;

report "Test Case 28 Passed: Accumulator 0 received user input correctly." severity note;

------------------------------------------------------------------------
-- Test Case 29: MUX4 Selection - RF0 Output
------------------------------------------------------------------------
report "Test Case 29: MUX4 Selection - RF0 Output";

-- Write value to RF0
immediate_data <= x"5678";
mux_sel <= "10"; -- Select immediate_data data
acc0_write <= '1';
wait until rising_edge(clock);
acc0_write <= '0';

wait for clk_period;

-- Write to Register File
rf_address <= "000";
rf_write <= '1';
rf_mode <= '0'; -- Single access mode
wait until rising_edge(clock);
rf_write <= '0';

wait for clk_period;

-- Select RF0 Output in MUX4 and write to Accumulator 0
mux_sel <= "01"; -- Select rf0_out

wait for clk_period; -- Allow data to propagate through the mux

acc0_write <= '1';
wait until rising_edge(clock);
acc0_write <= '0';

wait for clk_period;

-- Verify that Accumulator 0 received the data from RF0
assert acc0_out = rf0_out report "Test Case 29 Failed: Accumulator 0 did not receive RF0 output correctly." severity error;

report "Test Case 29 Passed: Accumulator 0 received RF0 output correctly." severity note;

-----------------------------------------------------------------------
-- Test Case 30: MUX4 Selection - ALU0 Output
-----------------------------------------------------------------------
report "Test Case 30: MUX4 Selection - ALU0 Output";

-- Reset Accumulator 0
acc0_write <= '1';
mux_sel <= "10";       -- Select immediate_data data
immediate_data <= (others => '0');
wait for 0 ns;         -- Allow immediate_data to update
wait until rising_edge(clock);
acc0_write <= '0';
wait for clk_period;   -- Allow acc0_out to update

-- Step 1: Load immediate_data value into Accumulator 0
immediate_data <= x"0001";
wait for 0 ns;         -- Allow immediate_data to update
mux_sel <= "10";       -- Select immediate_data data
acc0_write <= '1';     -- Enable write to Accumulator 0
wait until rising_edge(clock);
acc0_write <= '0';     -- Disable write

wait for clk_period;   -- Allow acc0_out to update

-- Step 2: Verify Accumulator 0
report "Debug: Accumulator 0 after initial load: " &
       integer'image(to_integer(unsigned(acc0_out)));

-- Step 3: Configure ALU0 to increment Accumulator 0
alu0_sel <= "0111";    -- Increment operation
alu_mux_sel <= '1';    -- Select acc0_out as B input
wait for 0 ns;         -- Ensure control signals are updated

wait for clk_period;   -- Wait for ALU to process
wait until rising_edge(clock); -- Ensure alu0_out is updated

-- Step 4: Capture ALU0 Output

alu0_out_captured <= alu0_out;
wait for 0 ns;         -- Allow signal assignment

report "Debug: ALU0 Output after increment: " &
       integer'image(to_integer(unsigned(alu0_out_captured)));

-- Step 5: Set MUX4 to select ALU0 output
mux_sel <= "00";       -- Select alu0_out
wait for 0 ns;         -- Allow mux_sel to update

wait for clk_period;   -- Allow data to propagate

-- Step 6: Write MUX4 output to Accumulator 0
acc0_write <= '1';     -- Enable write to Accumulator 0
wait until rising_edge(clock);
acc0_write <= '0';     -- Disable write

wait for clk_period;   -- Allow acc0_out to update

-- Step 7: Verify that Accumulator 0 received ALU0 output
report "Debug: Accumulator 0 after writing ALU0 output: " &
       integer'image(to_integer(unsigned(acc0_out)));

-- Compare acc0_out with alu0_out_captured
if acc0_out = alu0_out_captured then
    report "Test Case 30 Passed: Accumulator 0 received ALU0 output correctly." severity note;
else
    report "Test Case 30 Failed: Accumulator 0 did not receive ALU0 output correctly." severity error;
end if;


-----------------------------------------------------------------------
-- Test Case 31: MUX2 (Accumulator MUX) Selection
-----------------------------------------------------------------------
report "Test Case 31: MUX2 (Accumulator MUX) Selection";

-- Reset Accumulators
acc0_write <= '1';
acc1_write <= '1';
mux_sel <= "10"; -- Select immediate_data data
immediate_data <= (others => '0');
wait until rising_edge(clock);
acc0_write <= '0';
acc1_write <= '0';
wait for clk_period;

-- Step 1: Load value into Accumulator 0
immediate_data <= x"000A";
wait for 0 ns;
mux_sel <= "10";
acc0_write <= '1';
wait until rising_edge(clock);
acc0_write <= '0';
wait for clk_period;

-- Step 2: Load value into Accumulator 1
immediate_data <= x"000B";
wait for 0 ns;
mux_sel <= "10";
acc1_write <= '1';
wait until rising_edge(clock);
acc1_write <= '0';
wait for clk_period;

-- Step 3: Prepare for Register File write in single access mode
rf_mode <= '0'; -- Single access mode
rf_address <= "001"; -- Arbitrary address

-- Step 4: Select Accumulator 0 and write to Register File
acc_mux_sel <= '0'; -- Select Accumulator 0
wait for clk_period; -- Allow acc_mux_sel to take effect
rf_write <= '1';
wait until rising_edge(clock);
rf_write <= '0';
wait for clk_period; -- Allow data to propagate

-- Step 5: Verify RF0 received data from Accumulator 0
report "Debug: acc_mux_sel = '0'";
report "Debug: acc0_out = " & integer'image(to_integer(unsigned(acc0_out)));
report "Debug: rf0_out = " & integer'image(to_integer(unsigned(rf0_out)));

-- Read back from the Register File to rf0_out
rf_write <= '0';
rf_mode <= '0';
rf_address <= "001";
wait until rising_edge(clock);
wait for clk_period;

-- Verify that rf0_out matches acc0_out
if rf0_out = acc0_out then
    report "Test Case 31 Passed: MUX2 selected Accumulator 0 correctly." severity note;
else
    report "Test Case 31 Failed: MUX2 did not select Accumulator 0 correctly." severity error;
end if;

-- Step 6: Switch to Dual Access Mode to test Accumulator 1
rf_mode <= '1'; -- Dual access mode
rf_address <= "001"; -- Address for dual access
acc_mux_sel <= '1'; -- Select Accumulator 1
wait for clk_period; -- Allow signals to propagate

-- Step 7: Write to Register File in dual access mode
rf_write <= '1';
wait until rising_edge(clock);
rf_write <= '0';
wait for clk_period;

-- Step 8: Verify RF1 received data from Accumulator 1
report "Debug: acc_mux_sel = '1'";
report "Debug: acc1_out = " & integer'image(to_integer(unsigned(acc1_out)));
report "Debug: rf1_out = " & integer'image(to_integer(unsigned(rf1_out)));

-- Read back from the Register File
rf_write <= '0';
rf_mode <= '1'; -- Stay in dual access mode
rf_address <= "001";
wait until rising_edge(clock);
wait for clk_period;

-- Verify that rf1_out matches acc1_out
if rf0_out = acc1_out then
    report "Test Case 31 Passed: MUX2 selected Accumulator 1 correctly." severity note;
else
    report "Test Case 31 Failed: MUX2 did not select Accumulator 1 correctly." severity error;
end if;


-----------------------------------------------------------------------
-- Test Case 32: ALU MUX Selection
-----------------------------------------------------------------------
report "Test Case 32: ALU MUX Selection";

-- Reset Accumulator 0 and Register File
acc0_write <= '1';
mux_sel <= "10";       -- Select immediate_data data
immediate_data <= (others => '0');
wait until rising_edge(clock);
acc0_write <= '0';
wait for clk_period;

-- Reset ALU0 Control Signals
alu0_sel <= "0000";
alu_mux_sel <= '0';
wait for clk_period;

-- Step 1: Load value into Accumulator 0
immediate_data <= x"0010";
mux_sel <= "10";
acc0_write <= '1';
wait until rising_edge(clock);
acc0_write <= '0';
wait for clk_period;

-- Step 2: Write value to Register File at address 1
rf_address <= "001";
rf_write <= '1';
rf_mode <= '0'; -- Single access mode
wait until rising_edge(clock);
rf_write <= '0';
wait for clk_period;

-- Step 3: Load another value into Accumulator 0
immediate_data <= x"0020";
mux_sel <= "10";
acc0_write <= '1';
wait until rising_edge(clock);
acc0_write <= '0';
wait for clk_period;

-- Step 4: Configure ALU0 to pass through the selected input
alu0_sel <= "0010"; -- Pass B (alu_mux_out)
mux_sel <= "00";    -- Select alu0_out

-- Test ALU MUX selection of rf0_out
alu_mux_sel <= '0'; -- Select rf0_out as input B
wait for clk_period; -- Allow control signals to propagate
wait until rising_edge(clock);
wait for clk_period;

-- Step 5: Verify ALU0 Output when alu_mux_sel = '0'
report "Debug: alu_mux_sel = '0'";
report "Debug: rf0_out = " & integer'image(to_integer(unsigned(rf0_out)));
report "Debug: alu0_out = " & integer'image(to_integer(unsigned(alu0_out)));

-- Write ALU output to Accumulator 0
acc0_write <= '1';
wait until rising_edge(clock);
acc0_write <= '0';
wait for clk_period;

-- Verify that Accumulator 0 received rf0_out
if acc0_out = rf0_out then
    report "Test Case 32 Passed: ALU MUX selected rf0_out correctly." severity note;
else
    report "Test Case 32 Failed: ALU MUX did not select rf0_out correctly." severity error;
end if;

-- Now select acc0_out via alu_mux_sel
alu_mux_sel <= '1'; -- Select acc0_out as input B
wait for clk_period; -- Allow control signals to propagate
wait until rising_edge(clock);
wait for clk_period;

-- Step 6: Verify ALU0 Output when alu_mux_sel = '1'
report "Debug: alu_mux_sel = '1'";
report "Debug: acc0_out = " & integer'image(to_integer(unsigned(acc0_out)));
report "Debug: alu0_out = " & integer'image(to_integer(unsigned(alu0_out)));

-- Write ALU output to Accumulator 0
acc0_write <= '1';
wait until rising_edge(clock);
acc0_write <= '0';
wait for clk_period;

-- Verify that Accumulator 0 received acc0_out
if acc0_out = alu0_out then
    report "Test Case 32 Passed: ALU MUX selected acc0_out correctly." severity note;
else
    report "Test Case 32 Failed: ALU MUX did not select acc0_out correctly." severity error;
end if;


------------------------------------------------------------------------
-- Test Case 33: Register File Dual Access Mode
------------------------------------------------------------------------
report "Test Case 33: Register File Dual Access Mode";

-- Load values into Accumulators
immediate_data <= x"AAAA";
mux_sel <= "10";
acc0_write <= '1';
wait until rising_edge(clock);
acc0_write <= '0';

wait for clk_period;

immediate_data <= x"BBBB";
mux_sel <= "10";
acc1_write <= '1';
wait until rising_edge(clock);
acc1_write <= '0';

wait for clk_period;

-- Set acc_mux_sel to select Accumulator 1 for rf1_in
acc_mux_sel <= '1';

wait for clk_period; -- Ensure acc_mux_sel is set

-- Write to Register File in dual access mode
rf_address <= "010"; -- Addresses 2 and 6
rf_write <= '1';
rf_mode <= '1';      -- Dual access mode
wait until rising_edge(clock);
rf_write <= '0';

wait for clk_period;

-- Read back values
rf_write <= '0';
rf_mode <= '1';
rf_address <= "010";
wait for clk_period;

-- Verify that rf0_out and rf1_out received the correct data
assert rf0_out = acc1_out report "Test Case 33 Failed: rf0_out incorrect in dual access mode." severity error;
assert rf1_out = acc0_out report "Test Case 33 Failed: rf1_out incorrect in dual access mode." severity error;

report "Test Case 33 Passed: Register File dual access mode working correctly." severity note;

-----------------------------------------------------------------------
-- Test Case 34: Register File Single Access Mode Read/Write
-----------------------------------------------------------------------
report "Test Case 34: Register File Single Access Mode Read/Write";

-- Reset signals and Register File
immediate_data <= (others => '0');
acc0_write <= '0';
rf_write <= '0';
rf_mode <= '0';
rf_address <= (others => '0');
wait for clk_period;

-- Step 1: Load immediate_data value into Accumulator 0
immediate_data <= x"5555";
wait for 0 ns; -- Allow immediate_data to update
mux_sel <= "10"; -- Select immediate_data data
acc0_write <= '1'; -- Enable write to acc0
wait until rising_edge(clock);
acc0_write <= '0'; -- Disable write
wait for clk_period;

-- Ensure acc0_out has updated
report "Debug: acc0_out = " & integer'image(to_integer(unsigned(acc0_out)));

-- Step 2: Write acc0_out to Register File at address 5
rf_address <= "101"; -- Address 5
rf_write <= '1';
rf_mode <= '0';      -- Single access mode
wait until rising_edge(clock);
rf_write <= '0';
wait for clk_period;

-- Step 3: Read back value from Register File
rf_address <= "101";
rf_write <= '0';
rf_mode <= '0';      -- Single access mode
wait until rising_edge(clock);
wait for clk_period;

-- Ensure rf0_out has updated
report "Debug: rf0_out = " & integer'image(to_integer(unsigned(rf0_out)));

-- Step 4: Verify the output
if rf0_out = x"5555" then
    report "Test Case 34 Passed: rf0_out correct in single access mode." severity note;
else
    report "Test Case 34 Failed: rf0_out incorrect in single access mode." severity error;
end if;

------------------------------------------------------------------------
-- Test Case 35: Tri-State Buffer Verification
------------------------------------------------------------------------
report "Test Case 35: Tri-State Buffer Verification";

-- Enable output and verify buffer output matches acc0_out
output_en <= '1';
wait for clk_period;
assert buffer_output = acc0_out report "Test Case 35 Failed: Buffer output does not match acc0_out when enabled." severity error;

-- Disable output and verify buffer output is high-impedance
output_en <= '0';
wait for clk_period;
for i in buffer_output'range loop
    assert buffer_output(i) = 'Z' report "Test Case 35 Failed: Buffer output not high-impedance when disabled." severity error;
end loop;

report "Test Case 35 Passed: Tri-State Buffer operates correctly." severity note;

------------------------------------------------------------------------
-- Test Case 36: ALU0 Pass-Through Operations
------------------------------------------------------------------------
report "Test Case 36: ALU0 Pass-Through Operations";

-- Load value into Accumulator 0 to use as B input
immediate_data <= x"4444";
mux_sel <= "10";
acc0_write <= '1';
wait until rising_edge(clock);
acc0_write <= '0';

wait for clk_period;

-- Load value into RF0 to use as A input
immediate_data <= x"3333";
mux_sel <= "10";
acc0_write <= '1';
wait until rising_edge(clock);
acc0_write <= '0';

rf_address <= "000";
rf_write <= '1';
rf_mode <= '0';
wait until rising_edge(clock);
rf_write <= '0';

wait for clk_period;

-- Configure ALU0 to pass A
alu0_sel <= "0001"; -- Pass A
alu_mux_sel <= '1'; -- Select acc0_out as B input
mux_sel <= "00";    -- Select alu0_out

wait for clk_period; -- Allow ALU operation to complete

acc0_write <= '1';  -- Write back to acc0
wait until rising_edge(clock);
acc0_write <= '0';

wait for clk_period;

-- Verify that acc0_out matches rf0_out
assert acc0_out = rf0_out report "Test Case 36 Failed: ALU0 did not pass A correctly." severity error;

-- Configure ALU0 to pass B
alu0_sel <= "0010"; -- Pass B

wait for clk_period; -- Allow ALU operation to complete

acc0_write <= '1';  -- Write back to acc0
wait until rising_edge(clock);
acc0_write <= '0';

wait for clk_period;

-- Verify that acc0_out matches initial B input (x"4444")
assert acc0_out = x"4444" report "Test Case 36 Failed: ALU0 did not pass B correctly." severity error;

report "Test Case 36 Passed: ALU0 pass-through operations working correctly." severity note;


        wait;
    end process;

end Behavioral;

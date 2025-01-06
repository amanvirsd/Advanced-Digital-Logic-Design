----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Antonio Andara Lara, Shyama Gandhi and Bruce Cockburn
-- Create Date: 10/29/2020 07:18:24 PM
-- Design Name: DATAPATH FOR THE CPU
-- Module Name: cpu - structural(datapath)
-- Description: CPU_PART 1 OF LAB 3 - ECE 410 (2021)
-- Revision:
-- Revision 0.01 - File Created
-- Revision 1.01 - File Modified by Raju Machupalli (October 31, 2021)
-- Revision 2.01 - File Modified by Shyama Gandhi (November 2, 2021)
-- Revision 3.01 - File Modified by Antonio Andara (October 31, 2023)
-- Revision 4.01 - File Modified by Antonio Andara (October 28, 2024)
-- Additional Comments:
--*********************************************************************************
-- datapath top level module that maps all the components used inside of it
-----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

entity datapath is
    port (
        clock        : in std_logic;
        reset        : in std_logic;
        -- Control signals from the controller
        acc0_write   : in std_logic; -- set
        acc1_write   : in std_logic; -- set 
        alu0_sel     : in std_logic_vector(3 downto 0); --
        alu1_sel     : in std_logic_vector(3 downto 0); --
        shift_amt : in std_logic_vector(3 downto 0);
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
        acc0_out     : out std_logic_vector(15 downto 0); --
        acc1_out     : out std_logic_vector(15 downto 0); --
        rf0_out      : out std_logic_vector(15 downto 0); 
        rf1_out      : out std_logic_vector(15 downto 0);
        alu0_out     : out std_logic_vector(15 downto 0);
        alu1_out     : out std_logic_vector(15 downto 0);
        buffer_output: out std_logic_vector(15 downto 0);
        of_flag0      : OUT std_logic;
        of_flag1     : OUT std_logic;
        zero_flag      : OUT STD_LOGIC;
        sign_flag  : OUT STD_LOGIC 
        );
end datapath;

architecture Structural of datapath is
    -- Internal signals
    signal acc0_internal      : std_logic_vector(15 downto 0);
    signal acc1_internal      : std_logic_vector(15 downto 0);
    signal alu0_out_internal  : std_logic_vector(15 downto 0);
    signal alu1_out_internal  : std_logic_vector(15 downto 0);
    signal rf0_out_internal   : std_logic_vector(15 downto 0);
    signal rf1_out_internal   : std_logic_vector(15 downto 0);
    signal mux4_out           : std_logic_vector(15 downto 0);
    signal alu_mux_out        : std_logic_vector(15 downto 0);
    signal acc_mux_out        : std_logic_vector(15 downto 0);
--    signal of_flag_0      :  std_logic;
--    signal of_flag_1     :  std_logic;
    signal zero_flag_acc : STD_LOGIC;
    signal sign_flag_acc : STD_LOGIC;
    constant ZERO_VECTOR : std_logic_vector(15 downto 0) := (others => '0');
begin

 
    -- Instantiate mux4
    input_mux: entity work.mux4
        port map (
            alu0_out       => alu0_out_internal,
            rf0_out        => rf0_out_internal,
            immediate_data => immediate_data,
            user_input     => user_input,
            mux_sel        => mux_sel,
            mux4_out       => mux4_out
        );

    
    -- Instantiate acc_mux
    acc_mux: entity work.mux2
        port map (
            mux_sel => acc_mux_sel,
            in0     => acc0_internal,
            in1     => acc1_internal,
            mux_out => acc_mux_out
        );
        
        
        
    -- Instantiate alu_mux 
    alu_mux: entity work.mux2
        port map (
            mux_sel => alu_mux_sel,
            in0     => rf1_out_internal,
            in1     => acc0_internal,
            mux_out => alu_mux_out
        );

    -- Instantiate accumulators
    acc0: entity work.accumulator
        port map (
            clock     => clock,
            reset     => reset,
            acc_write => acc0_write,
            acc_in    => mux4_out,
            acc_out   => acc0_internal,
            zero_flag => zero_flag_acc,
            sign_flag => sign_flag_acc
        );

    acc1: entity work.accumulator
       port map (
            clock     => clock,
            reset     => reset,
            acc_write => acc0_write,
            acc_in    => mux4_out,
            acc_out   => acc1_internal,
            zero_flag => zero_flag_acc,
            sign_flag => sign_flag_acc
        );

    -- Instantiate register file
    register_file_inst: entity work.register_file
        port map (
            clock      => clock,
            rf_write   => rf_write,
            rf_mode    => rf_mode,
            rf_address => rf_address,
            rf0_in     => acc0_internal,
            rf1_in     => acc_mux_out,
            rf0_out    => rf0_out_internal,
            rf1_out    => rf1_out_internal
        );
        
    -- Instantiate ALUs
    alu0: entity work.alu16
        port map (
            A         => rf0_out_internal,
            B         => alu_mux_out,
            shift_amt => shift_amt,
            alu_sel   => alu0_sel,
            alu_out   => alu0_out_internal,
            of_flag => of_flag0
        );

    alu1: entity work.alu16
        port map (
            A         => rf1_out_internal,
            B         => acc0_internal,
            shift_amt => shift_amt,
            alu_sel   => alu1_sel,
            alu_out   => alu1_out_internal,
            of_flag => of_flag1
        );

    -- Instantiate tri-state buffer
    tri_state_buffer_inst: entity work.tri_state_buffer
        port map (
            output_en     => output_en,
            buffer_in     => acc0_internal,
            buffer_out    => buffer_output
        );

    -- Output assignments
    acc0_out <= acc0_internal;
    acc1_out <= acc1_internal;
    alu0_out <= alu0_out_internal;
    alu1_out <= alu1_out_internal;
    rf0_out  <= rf0_out_internal;
    rf1_out  <= rf1_out_internal;


    sign_flag <= NOT(mux4_out(15));
    zero_flag     <= NOT(mux4_out(15) OR mux4_out(14) OR mux4_out(13) OR mux4_out(12) OR mux4_out(11) OR mux4_out(10) 
                   OR mux4_out(9) OR mux4_out(8) OR mux4_out(7) OR mux4_out(6) OR mux4_out(5) OR mux4_out(4)OR mux4_out(3)OR mux4_out(2)OR mux4_out(1)OR mux4_out(0));
                     
   -- zero_flag <= NOT (or_reduce(mux4_out));

end Structural;
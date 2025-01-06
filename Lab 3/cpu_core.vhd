----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Lab Members: Amanvir Dhanoa and Zhiyuan Li
-- 
-- Module Name   : CPU_core 
-- Project Name  : CPU_LAB 3 - ECE 410
-- Target Device : FPGA
-- Tool Versions : Xilinx Vivado 2019
-- Description   : Top-level structural design for the CPU, integrating controller and datapath.
-- 
-- Revision History:
-- 
-- Additional Comments:
-- - The CPU core integrates the datapath, controller, and clock divider.
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CPU_core is
    port (
        clock        : in std_logic;
        reset        : in std_logic;
        enter        : in std_logic;
        user_input   : in std_logic_vector(15 downto 0);
        CPU_output   : out std_logic_vector(15 downto 0);
        PC_output    : out std_logic_vector(4 downto 0);
        OPCODE_output: out std_logic_vector(3 downto 0);
        done         : out std_logic;
        of_flag0         : out std_logic;
        of_flag1         : out std_logic
        
    );
end entity CPU_core;

architecture Structural of CPU_core is
    signal clock_div        : std_logic;
    signal acc0_write       : std_logic;
    signal acc1_write       : std_logic;
    signal alu_sel0         : std_logic_vector(3 downto 0);
    signal alu_sel1         : std_logic_vector(3 downto 0);
    signal shift_amt        : std_logic_vector(3 downto 0);
    signal rf_write         : std_logic;
    signal rf_mode          : std_logic;
    signal rf_address       : std_logic_vector(2 downto 0);
    signal mux_sel          : std_logic_vector(1 downto 0);
    signal acc_mux_sel      : std_logic;
    signal alu_mux_sel      : std_logic;
    signal output_en        : std_logic;
    signal immediate_data   : std_logic_vector(15 downto 0);
    signal zero_flag        : std_logic;
    signal sign_flag        : std_logic;
    signal of_flag_0         : std_logic; 
    signal of_flag_1         : std_logic; 



begin
    -- Clock divider
    core_div: entity work.clock_divider
        generic map (
            freq_out => 62_500_000
        )
        port map (
            clock => clock,
            clock_div => clock_div
        );

    -- Datapath
    datapath_inst: entity work.datapath
        port map (
            clock           => clock_div,
            reset           => reset,
            acc0_write      => acc0_write,
            acc1_write      => acc1_write,
            alu0_sel        => alu_sel0,
            alu1_sel        => alu_sel1,
            shift_amt           => shift_amt,    
            rf_write        => rf_write,
            rf_mode         => rf_mode,
            rf_address      => rf_address,
            mux_sel         => mux_sel,
            acc_mux_sel     => acc_mux_sel,
            alu_mux_sel     => alu_mux_sel,
            output_en       => output_en,
            immediate_data  => immediate_data,
            user_input      => user_input,
--            acc0_out        => open,
--            acc1_out        => open,
--            rf0_out         => open,
--            rf1_out         => open,
--            alu0_out        => open,
--            alu1_out        => open,
            buffer_output   => CPU_output,
            zero_flag       => zero_flag,
            sign_flag       => sign_flag,
            of_flag0        => of_flag0,
            of_flag1        => of_flag1
        );

   -- Controller
    controller_inst: entity work.controller
        port map (
            clock           => clock_div,
            reset           => reset,
            enter           => enter,
            zero_flag       => zero_flag,
            sign_flag       => sign_flag,
          --  of_flag0        => of_flag_0,
         --   of_flag1        => of_flag_1,
            immediate_data => immediate_data,
            mux_sel         => mux_sel,
            acc_mux_sel     => acc_mux_sel,
            alu_mux_sel     => alu_mux_sel,
            acc0_write      => acc0_write,
            acc1_write      => acc1_write,
            rf_address      => rf_address,
            rf_write        => rf_write,
            rf_mode         => rf_mode,
            alu_sel0        => alu_sel0,
            alu_sel1        => alu_sel1,
            shift_amt       => shift_amt,
            output_en       => output_en,
            PC_out          => PC_output,
            OPCODE_output   => OPCODE_output,
            done            => done
        );

end architecture Structural;

----------------------------------------------------------------------------------
-- Filename : alu.vhdl
-- Author : Antonio Alejandro Andara Lara
-- Date : 31-Oct-2023
-- Design Name: alu_tb
-- Project Name: ECE 410 lab 3 2023
-- Description : testbench for the ALU of the simple CPU design
-- Revision 1.01 - File Modified by Antonio Andara (October 28, 2024)
-- Additional Comments:
-- Copyright : University of Alberta, 2023
-- License : CC0 1.0 Universal
-- Lab memebers: Amanvir Dhanoa and Zhiyuan Li
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY alu16_tb IS
END alu16_tb;

ARCHITECTURE sim OF alu16_tb IS
    SIGNAL alu_sel     : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL A           : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL B           : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL shift_amt   : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL alu_out     : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL of_flag : STD_LOGIC; 

BEGIN

    uut: ENTITY WORK.alu16(Dataflow)
        PORT MAP(
            A             => A,
            B             => B,
            shift_amt     => shift_amt,
            alu_sel       => alu_sel,
            alu_out       => alu_out,
            of_flag => of_flag 
        );
    stim_proc: PROCESS
    BEGIN
        -- Test Case 1: Pass A
        A <= "0000111100001111";
        alu_sel <= "0001";
        WAIT FOR 20 ns;
        ASSERT alu_out = A REPORT "Test Case 1 failed: Pass A" SEVERITY ERROR;

        -- Test Case 2: Pass B
        B <= "1111000011110000";
        alu_sel <= "0010";
        WAIT FOR 20 ns;
        ASSERT alu_out = B REPORT "Test Case 2 failed: Pass B" SEVERITY ERROR;

        -- Test Case 3: Logical shift left on B
        alu_sel <= "0011";
        shift_amt <= "0001";
        WAIT FOR 20 ns;
        ASSERT alu_out = std_logic_vector(shift_left(unsigned(B), 1)) REPORT "Test Case 3 failed: Logical shift left" SEVERITY ERROR;

        -- Test Case 4: Logical shift right on B
        alu_sel <= "0100";
        shift_amt <= "0010";
        WAIT FOR 20 ns;
        ASSERT alu_out = std_logic_vector(shift_right(unsigned(B), 2)) REPORT "Test Case 4 failed: Logical shift right" SEVERITY ERROR;

        -- Test Case 5: Add A and B
        alu_sel <= "0101";
        WAIT FOR 20 ns;
        ASSERT alu_out = std_logic_vector(unsigned(A) + unsigned(B)) REPORT "Test Case 5 failed: Add A and B" SEVERITY ERROR;

        -- Test Case 6: Subtract B from A
        alu_sel <= "0110";
        WAIT FOR 20 ns;
        ASSERT alu_out = std_logic_vector(unsigned(A) - unsigned(B)) REPORT "Test Case 6 failed: Subtract B from A" SEVERITY ERROR;

        -- Test Case 7: Increment B
        alu_sel <= "0111";
        WAIT FOR 20 ns;
        ASSERT alu_out = std_logic_vector(signed(B) + 1) REPORT "Test Case 7 failed: Increment B" SEVERITY ERROR;

        -- Test Case 8: Decrement B
        alu_sel <= "1000";
        WAIT FOR 20 ns;
        ASSERT alu_out = std_logic_vector(signed(B) - 1) REPORT "Test Case 8 failed: Decrement B" SEVERITY ERROR;

        -- Test Case 9: Logical AND of A and B
        alu_sel <= "1001";
        WAIT FOR 20 ns;
        ASSERT alu_out = (A AND B) REPORT "Test Case 9 failed: Logical AND of A and B" SEVERITY ERROR;

        -- Test Case 10: Logical OR of A and B
        alu_sel <= "1010";
        WAIT FOR 20 ns;
        ASSERT alu_out = (A OR B) REPORT "Test Case 10 failed: Logical OR of A and B" SEVERITY ERROR;

        -- Test Case 11: Logical NOT of A
        alu_sel <= "1011";
        WAIT FOR 20 ns;
        ASSERT alu_out = NOT A REPORT "Test Case 11 failed: Logical NOT of A" SEVERITY ERROR;

        -- Test Case 12: Logical NOT of B
        alu_sel <= "1100";
        WAIT FOR 20 ns;
        ASSERT alu_out = NOT B REPORT "Test Case 12 failed: Logical NOT of B" SEVERITY ERROR;

        -- Test Case 13: Set ALU output to 1
        alu_sel <= "1101";
        WAIT FOR 20 ns;
        ASSERT alu_out = X"0001" REPORT "Test Case 13 failed: Set ALU output to 1" SEVERITY ERROR;

        -- Test Case 14: Set ALU output to 0
        alu_sel <= "1110";
        WAIT FOR 20 ns;
        ASSERT alu_out = "0000000000000000" REPORT "Test Case 14 failed: Set ALU output to 0" SEVERITY ERROR;

        -- Test Case 15: Set ALU output to all 1s
        alu_sel <= "1111";
        WAIT FOR 20 ns;
        ASSERT alu_out = X"FFFF" REPORT "Test Case 15 failed: Set ALU output to all 1s" SEVERITY ERROR;
        

        
        -- End of test cases
        WAIT;
    END PROCESS stim_proc;

END sim;

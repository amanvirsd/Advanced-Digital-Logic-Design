----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Shyama Gandhi and Bruce Cockburn
-- Create Date: 10/29/2020 07:18:24 PM
-- Module Name: cpu - structural(datapath)
-- Description: CPU LAB 3 - ECE 410 (2023)
-- Revision:
-- Revision 0.01 - File Created
-- Revision 1.01 - File Modified by Raju Machupalli (October 31, 2021)
-- Revision 2.01 - File Modified by Shyama Gandhi (November 2, 2021)
-- Revision 3.01 - File Modified by Antonio Andara (October 31, 2023)
-- Revision 4.01 - File Modified by Antonio Andara (October 28, 2024)
-- Additional Comments:
-- Lab memebers: Amanvir Dhanoa and Zhiyuan Li
--*********************************************************************************
-- A total of fifteen operations can be performed using 4 select lines of this ALU.
-- The select line codes have been given to you in the lab manual.
-----------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY alu16 IS
    PORT (
        A             : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        B             : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        shift_amt     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0); -- bits rotate
        alu_sel       : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        alu_out       : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        of_flag : OUT STD_LOGIC -- New overflow flag
    );
END alu16;

ARCHITECTURE Dataflow OF alu16 IS

BEGIN
    PROCESS (A, B, shift_amt, alu_sel)
        VARIABLE temp_result : SIGNED(16 DOWNTO 0); -- Extended size for overflow detection
    BEGIN
        CASE alu_sel IS
            WHEN "0001" => -- Pass A
                alu_out <= A;
                of_flag <= '0';
            WHEN "0010" => -- Pass B
                alu_out <= B;
                of_flag <= '0';
            WHEN "0011" => -- Logical shift left on B
                alu_out <= std_logic_vector(unsigned(B) sll to_integer(unsigned(shift_amt)));
                of_flag <= '0';
            WHEN "0100" => -- Logical shift right on B
                alu_out <= std_logic_vector(unsigned(B) srl to_integer(unsigned(shift_amt)));
                of_flag <= '0';
            WHEN "0101" => -- Add A and B
                temp_result := resize(SIGNED(A), 17) + resize(SIGNED(B), 17);
                alu_out <= std_logic_vector(temp_result(15 DOWNTO 0));
                of_flag <= temp_result(16);
            WHEN "0110" => -- Subtract B from A
                temp_result := resize(SIGNED(B), 17)-  resize(SIGNED(A), 17) ;
                alu_out <= std_logic_vector(temp_result(15 DOWNTO 0));
                of_flag <= temp_result(16);
            WHEN "0111" => -- Increment B
                alu_out <= std_logic_vector(SIGNED(B) + 1);
                of_flag <= '0';
            WHEN "1000" => -- Decrement B
                alu_out <= std_logic_vector(SIGNED(B) - 1);
                of_flag <= '0';
            WHEN "1001" => -- Logical AND of A and B
                alu_out <= A AND B;
                of_flag <= '0';
            WHEN "1010" => -- Logical OR of A and B
                alu_out <= A OR B;
                of_flag <= '0';
            WHEN "1011" => -- Logical NOT of A
                alu_out <= NOT A;
                of_flag <= '0';
            WHEN "1100" => -- Logical NOT of B
                alu_out <= NOT B;
                of_flag <= '0';
            WHEN "1101" => -- Set ALU output to 1
                alu_out <= X"0001";
                of_flag <= '0';
            WHEN "1110" => -- Set ALU output to 0
                alu_out <= (OTHERS => '0');
                of_flag <= '0';
            WHEN "1111" => -- Set ALU output to all 1s
                alu_out <= (OTHERS => '1');
                of_flag <= '0';
            WHEN OTHERS =>
                alu_out <= (OTHERS => '0');
                of_flag <= '0';
        END CASE;
    END PROCESS;
END Dataflow;
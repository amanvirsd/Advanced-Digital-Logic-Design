----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Shyama Gandhi and Bruce Cockburn
-- Create Date: 10/29/2020 07:18:24 PM
-- Updated Date: 01/11/2021
-- Design Name: CONTROLLER FOR THE CPU
-- Module Name: cpu - behavioral(controller)
-- Description: CPU_LAB 3 - ECE 410 (2021)
-- Revision:
-- Revision 0.01 - File Created
-- Revision 1.01 - File Modified by Raju Machupalli (October 31, 2021)
-- Revision 2.01 - File Modified by Shyama Gandhi (November 2, 2021)
-- Revision 3.01 - File Modified by Antonio Andara (October 31, 2023)
-- Revision 4.01 - File Modified by Antonio Andara (October 28, 2024)
-- Additional Comments:
-- Lab members - Amanvir Dhanoa and Zhiyuan Li. 
--*********************************************************************************
-- The controller implements the states for each instructions and asserts appropriate control signals for the datapath during every state.
-- For detailed information on the opcodes and instructions to be executed, refer the lab manual.
-----------------------------



LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY controller IS
    PORT(
        clock          : IN  std_logic; 
        reset          : IN  std_logic;
        enter          : IN  std_logic;
        zero_flag      : IN  std_logic;
        sign_flag      : IN  std_logic; 
        immediate_data : BUFFER std_logic_vector(15 DOWNTO 0);
        mux_sel        : OUT std_logic_vector(1 DOWNTO 0);
        acc_mux_sel    : OUT std_logic;
        alu_mux_sel    : OUT std_logic;
        acc0_write     : OUT std_logic;
        acc1_write     : OUT std_logic;
        rf_address     : OUT std_logic_vector(2 DOWNTO 0);
        rf_write       : OUT std_logic;
        rf_mode        : OUT std_logic;
        alu_sel0       : OUT std_logic_vector(3 DOWNTO 0);
        alu_sel1       : OUT std_logic_vector(3 DOWNTO 0);  
        shift_amt      : OUT std_logic_vector(3 DOWNTO 0);
        output_en      : OUT std_logic;
        PC_out         : OUT std_logic_vector(4 DOWNTO 0);
        OPCODE_output  : OUT std_logic_vector(3 DOWNTO 0);
        done           : OUT std_logic
    );
END controller;

ARCHITECTURE Behavioral OF controller IS
    -- Instructions and their opcodes  
    CONSTANT OPCODE_INA  : std_logic_vector(3 DOWNTO 0) := "0001";
    CONSTANT OPCODE_LDI  : std_logic_vector(3 DOWNTO 0) := "0010"; 
    CONSTANT OPCODE_LDA  : std_logic_vector(3 DOWNTO 0) := "0011";
    CONSTANT OPCODE_STA  : std_logic_vector(3 DOWNTO 0) := "0100";
    CONSTANT OPCODE_ADD  : std_logic_vector(3 DOWNTO 0) := "0101";
    CONSTANT OPCODE_SUB  : std_logic_vector(3 DOWNTO 0) := "0110";
    CONSTANT OPCODE_SHFL : std_logic_vector(3 DOWNTO 0) := "1000";  
    CONSTANT OPCODE_INC  : std_logic_vector(3 DOWNTO 0) := "1001";
    CONSTANT OPCODE_DEC  : std_logic_vector(3 DOWNTO 0) := "1010";
    CONSTANT OPCODE_AND  : std_logic_vector(3 DOWNTO 0) := "1011"; 
    CONSTANT OPCODE_JMPZ : std_logic_vector(3 DOWNTO 0) := "1101";
    CONSTANT OPCODE_OUTA : std_logic_vector(3 DOWNTO 0) := "1110";
    CONSTANT OPCODE_HALT : std_logic_vector(3 DOWNTO 0) := "1111";
    
    CONSTANT OPCODE_NOT  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1100";
    CONSTANT OPCODE_XCHG : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0111";

    TYPE state_type IS (
        STATE_FETCH, 
        STATE_DECODE,
        STATE_INA,
        STATE_LDI,
        STATE_LDA,  
        STATE_STA,
        STATE_ADD,
        STATE_SUB,
        STATE_SHFL,  
        STATE_INC,
        STATE_DEC,
        STATE_AND,
        STATE_JMPZ,
        STATE_OUTA,                         
        STATE_HALT,
        STATE_XCHG,
        STATE_NOT,
        STATE_UPDATE_FLAGS  -- New state to update flags
    );

    SIGNAL state          : state_type;
    SIGNAL IR             : std_logic_vector(15 DOWNTO 0); -- instruction register     
    SIGNAL PC             : INTEGER RANGE 0 TO 31 := 0;    -- program counter
    SIGNAL zero_flag_reg  : std_logic := '0'; -- Internal register for zero flag
    SIGNAL sign_flag_reg  : std_logic := '0'; -- Internal register for sign flag
    SIGNAL SIMD           : std_logic;  

    TYPE PM_BLOCK IS ARRAY(0 TO 31) OF std_logic_vector(15 DOWNTO 0); -- Program memory

BEGIN
    -- Output opcode
    OPCODE_output <= IR(7 DOWNTO 4);
    SIMD <= IR(15); -- SIMD bit

    PROCESS(clock, reset)
        VARIABLE PM : PM_BLOCK;
    BEGIN
        IF reset = '1' THEN
            -- Reset logic
            PC <= 0;
            IR <= (OTHERS => '0');
            PC_out <= (OTHERS => '0');
            mux_sel <= "00";
            acc_mux_sel <= '0';
            alu_mux_sel <= '0';
            immediate_data <= (OTHERS => '0');
            acc0_write <= '0';
            acc1_write <= '0';
            rf_address <= "000";
            rf_write <= '0';
            rf_mode <= '0';
            alu_sel0 <= "0000";
            alu_sel1 <= "0000";
            shift_amt <= "0000";
            output_en <= '0';
            done <= '0';
            zero_flag_reg <= '0';
            sign_flag_reg <= '0';
            state <= STATE_FETCH;

           -- Test program from lab manual
--            PM(0) := "0000000000010000"; -- INA
--            PM(1) := "0000000001000000"; -- STA R[0]
--            PM(2) := "0000000000110000"; -- LDA A, R[0]
--            PM(3) := "0000000010100000"; -- DEC A
--            PM(4) := "0000000001000000"; -- STA R[0], A
--            PM(5) := "0000000011100000"; -- OUTA
--            PM(6) := "0000110011010000"; -- JMPZ x0C
--            PM(7) := "0000000000100000"; -- LDI A, x0000
--            PM(8) := "0000000000000000"; -- x0000
--            PM(9) := "0000001011010000"; -- JMPZ x02
--            PM(10) := "0000000000100000"; -- LDI A, x000F
--            PM(11) := "0000000000001111"; -- x000F
--            PM(12) := "0000000001000000"; -- STA R[0], A
--            PM(13) := "0000000000100000"; -- LDI A, x00AA
--            PM(14) := "0000000010101010"; -- x00AA
--            PM(15) := "0000000010110000"; -- AND A, R[0]
--            PM(16) := "0000000011100000"; -- OUTA
--            PM(17) := "0000000010010000"; -- INC A
--            PM(18) := "0000000001000000"; -- STA R[0], A
--            PM(19) := "0000000000100000"; -- LDI A, x000F
--            PM(20) := "0000000000001111"; -- x000F
--            PM(21) := "1000000001010000"; -- ADD A, R[0]
--            PM(22) := "0000000011100000"; -- OUTA
--            PM(23) := "0000000011110000"; -- HALT

---- Custom Program
PM( 0) := "0000000000010000"; -- INA: Read user input into accumulator A.
PM( 1) := "0000000001000000"; -- STA R[0]: Store A into R[0].
PM( 2) := "0000000000100000"; -- LDI A: Prepare to load immediate data into A.
PM( 3) := "0000000000000101"; -- Immediate data: 0x0005.
PM( 4) := "0000000001000001"; -- STA R[1]: Store A into R[1].
PM( 5) := "0000000000110000"; -- LDA A, R[0]: Load A from R[0].
PM( 6) := "0000000001010001"; -- ADD A, R[1]: Add R[1] to A.
PM( 7) := "0000000011100000"; -- OUTA: Output the value of A.
PM( 8) := "0000000000100000"; -- LDI A: Prepare to load immediate data into A.
PM( 9) := "0000000011111111"; -- Immediate data: 0x00FF.
PM(10) := "1000000011000000"; -- NOT A: Perform bitwise NOT on A.
PM(11) := "0000000011100000"; -- OUTA: Output the value of A.
PM(12) := "0000000000100000"; -- LDI A: Prepare to load immediate data into A.
PM(13) := "1010101111001101"; -- Immediate data: 0xABCD.
PM(14) := "0000000001000010"; -- STA R[2]: Store A into R[2].
PM(15) := "0000000000100000"; -- LDI A: Load immediate data into A
PM(16) := "0001001000110100"; -- Immediate data: 0x1234.
PM(17) := "1000000001010010"; -- SIMD ADD A, R[2]: SIMD add R[2] to A.
PM(18) := "0000000011100000"; -- OUTA: Output the value of A.
PM(19) := "0000000000100000"; -- LDI A: Prepare to load immediate data into A.
PM(20) := "0001001000110100"; --  Immediate data: 0x1234.
PM(21) := "1000000001110000"; -- XCHG A, R[0]: Exchange A with R[0].
PM(22) := "0000000011100000"; -- OUTA: Output the value of A.
PM(23) := "0000000000100000"; -- LDI A: Prepare to load immediate data into A.
PM(24) := "0000000000000111"; -- Immediate data: 0x0007.
PM(25) := "1000000001100001"; -- SUB A, R[1]: Subtract R[1] from A.
PM(26) := "0001101111010000"; -- JMPZ x1B
PM(27) := "0000000011100000"; -- OUTA: Output the value of A.
PM(28) := "0000000011110000"; -- HALT: Stop execution.

        ELSIF rising_edge(clock) THEN
            CASE state IS
                WHEN STATE_FETCH =>
                    PC_out <= STD_LOGIC_VECTOR(to_unsigned(PC, PC_out'length));
                    IR <= PM(PC);
                    -- Initialize control signals
                    mux_sel        <= "00"; 
                    alu_mux_sel    <= '0';
                    acc_mux_sel    <= '0';
                    immediate_data <= (OTHERS => '0');
                    acc0_write     <= '0';
                    acc1_write     <= '0';
                    rf_address     <= "000";
                    rf_write       <= '0';
                    rf_mode        <= '0';
                    alu_sel0       <= "0000";
                    alu_sel1       <= "0000";  
                    shift_amt      <= "0000";
                    done           <= '0';        
                    IF enter = '1' THEN   
                        output_en <= '0';
                        PC       <= PC +1;
                        state    <= STATE_DECODE;
                    ELSE  
                        state <= STATE_FETCH;
                    END IF;

                WHEN STATE_DECODE =>
                    -- Decode instruction
                    CASE IR(7 DOWNTO 4) IS
                        WHEN OPCODE_INA  => state <= STATE_INA;
                        WHEN OPCODE_LDI  => state <= STATE_LDI;
                        WHEN OPCODE_LDA  => state <= STATE_LDA;
                        WHEN OPCODE_STA  => state <= STATE_STA;
                        WHEN OPCODE_ADD  => state <= STATE_ADD;
                        WHEN OPCODE_SUB  => state <= STATE_SUB;
                        WHEN OPCODE_SHFL => state <= STATE_SHFL;
                        WHEN OPCODE_INC  => state <= STATE_INC;
                        WHEN OPCODE_DEC  => state <= STATE_DEC;
                        WHEN OPCODE_AND  => state <= STATE_AND;
                        WHEN OPCODE_JMPZ => state <= STATE_JMPZ;
                        WHEN OPCODE_XCHG => state <= STATE_XCHG;
                        WHEN OPCODE_NOT => state <= STATE_NOT;
                        WHEN OPCODE_OUTA => state <= STATE_OUTA;
                        WHEN OTHERS      => state <= STATE_HALT;
                    END CASE;

                    -- Setup control signals for the next state
                    mux_sel        <= "00";
                    acc_mux_sel    <= '0'; 
                    alu_mux_sel    <= '0';
                    acc0_write     <= '0';
                    acc1_write     <= '0';
                    rf_address     <= IR(2 DOWNTO 0); 
                    rf_write       <= '0';
                    rf_mode        <= SIMD; -- SIMD mode if SIMD bit is set
                    alu_sel0       <= "0000"; 
                    alu_sel1       <= "0000";
                    shift_amt      <= IR(3 DOWNTO 0);
                    immediate_data <= PM(PC); -- Pre-fetch immediate data
                    output_en      <= '0';
                    done           <= '0';

                WHEN STATE_INA =>
                    mux_sel        <= "11"; -- Read input into accumulator  
                    acc_mux_sel    <= '0';
                    alu_mux_sel    <= '0'; 
                    acc0_write     <= '1';
                    acc1_write     <= '0';
                    state          <= STATE_UPDATE_FLAGS;

                WHEN STATE_LDI =>
                    mux_sel        <= "10";
                    acc_mux_sel    <= '0'; 
                    alu_mux_sel    <= '0';
                    immediate_data <= PM(PC);  
                    acc0_write     <= '1';
                    acc1_write     <= '0';
                    PC             <= PC + 1;
                    state          <= STATE_UPDATE_FLAGS;

                WHEN STATE_LDA =>
                    mux_sel        <= "01";  
                    acc_mux_sel    <= '0';
                    alu_mux_sel    <= '0';
                    acc0_write     <= '1';
                    acc1_write     <= SIMD;  
                    state          <= STATE_UPDATE_FLAGS;

                WHEN STATE_STA =>
                    rf_address     <= IR(2 DOWNTO 0);
                    rf_write       <= '1';
                    state          <= STATE_FETCH;

                WHEN STATE_ADD =>
                    mux_sel <= "00";
                    alu_sel0       <= "0101";
                    alu_sel1 <= "0101";
                    alu_mux_sel    <= '1';  
                    acc0_write     <= '1';
                    acc1_write     <= SIMD;
                    rf_address     <= IR(2 DOWNTO 0);
                    state          <= STATE_UPDATE_FLAGS;

                WHEN STATE_SUB =>
                    mux_sel <= "00";
                    alu_sel0       <= "0110";  
                    alu_sel1 <= "0110";
                    alu_mux_sel    <= '1';
                    acc0_write     <= '1'; 
                    acc1_write     <= SIMD;
                    rf_address     <= IR(2 DOWNTO 0);
                    state          <= STATE_UPDATE_FLAGS;

                WHEN STATE_SHFL =>
                    alu_sel0       <= "0011"; 
                    alu_mux_sel    <= '1';
                    acc0_write     <= '1';
                    acc1_write     <= SIMD;
                    shift_amt      <= IR(3 DOWNTO 0);
                    state          <= STATE_UPDATE_FLAGS;

                WHEN STATE_INC =>
                    alu_sel0       <= "0111";
                    alu_mux_sel    <= '1';
                    acc0_write     <= '1';
                    acc1_write     <= SIMD; 
                    state          <= STATE_UPDATE_FLAGS;

                WHEN STATE_DEC =>
                    alu_sel0       <= "1000";
                    alu_mux_sel    <= '1';  
                    acc0_write     <= '1';
                    acc1_write     <= SIMD;
                    state          <= STATE_UPDATE_FLAGS;

                WHEN STATE_AND =>
                    alu_sel0       <= "1001";
                    alu_mux_sel    <= '1';
                    acc0_write     <= '1';
                    acc1_write     <= SIMD;
                    rf_address     <= IR(2 DOWNTO 0);
                    state          <= STATE_UPDATE_FLAGS;

                WHEN STATE_JMPZ =>
                    IF zero_flag_reg = '1' THEN 
                        PC <= to_integer(unsigned(IR(12 DOWNTO 8)));
                    END IF;
                    state <= STATE_FETCH;

                WHEN STATE_OUTA =>
                    output_en <= '1'; -- Enable output
                    state     <= STATE_FETCH;

                WHEN STATE_UPDATE_FLAGS =>
                    -- Update zero and sign flags
                    zero_flag_reg <= zero_flag;
                    sign_flag_reg <= sign_flag;
                    -- Reset write enable signals to prevent unintended writes
                    acc0_write    <= '0';
                    acc1_write    <= '0';
                    state         <= STATE_FETCH;


              WHEN STATE_NOT =>
                  immediate_data <= (OTHERS => '0');
                  alu_sel0       <= "1100"; -- Bitwise NOT 
                  alu_sel1       <= "1100";
                  shift_amt      <= "0000";
                  mux_sel        <= "00";
                  acc_mux_sel    <= '0'; 
                  alu_mux_sel    <= '1';
                  acc0_write     <= '1';
                  acc1_write     <= SIMD;
                  rf_address     <= "000"; 
                  rf_write       <= '0';
                  output_en      <= '0';
                  done           <= '0';  
                  state          <= STATE_UPDATE_FLAGS;
                  
--              WHEN STATE_JMPR =>
                                    
----                  mux_sel        <= "00";
----                  acc_mux_sel    <= '0';
----                  alu_mux_sel    <= '0'; 
----                  immediate_data <= (OTHERS => '0');
----                  acc0_write     <= '0';
----                  acc1_write     <= '0';
----                  rf_address     <= "000";
----                  rf_write       <= '0';
----                  alu_sel0       <= "0010";
----                  alu_sel1       <= "0010"; 
----                  output_en      <= '0';
----                  done           <= '0';
                  
--                  -- Calculate new PC by adding signed offset
--                  PC <= PC + to_integer(signed(resize(signed(IR(3 DOWNTO 0)), 31)));
                  
--                  state <= STATE_FETCH;
                  
              WHEN STATE_XCHG =>
              mux_sel     <= "01";
              acc_mux_sel <= '1';
           --   alu_mux_sel <= '0';
              acc0_write  <= '1';
              acc1_write  <= SIMD ;
              rf_address  <= IR(2 DOWNTO 0);
              rf_write    <= '1';
              rf_mode <= '1' ;
              alu_sel0    <= "0000";
              alu_sel1    <= "0000";
              output_en   <= '0';
              done        <= '0';
              state       <= STATE_UPDATE_FLAGS;
              
               WHEN STATE_HALT =>
                    done  <= '1'; -- Signal completion
                    state <= STATE_HALT; -- Stay in HALT state

               WHEN OTHERS =>
                    state <= STATE_HALT;
            END CASE;
        END IF;
    END PROCESS;
END Behavioral;

----------------------------------------------------------------------------------
-- Filename      : clock_divider.vhd
-- Project Name  : ECE 410 lab 3 2024
-- Description   : Implementation of a clock divider for the CPU core file.
--  
-- Copyright     : University of Alberta, 2024
-- License       : CC0 1.0 Universal
-- Lab Members   : Amanvir Dhanoa and Zhiyuan Li
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY clock_divider IS
    GENERIC (
        freq_in  : POSITIVE := 125_000_000; 
        freq_out : POSITIVE := 1_000       
    );

    PORT (
        clock     : IN STD_LOGIC; 
        clock_div : OUT STD_LOGIC 
    );
END clock_divider;

ARCHITECTURE Behavioral OF clock_divider IS

    
    CONSTANT limit      : POSITIVE                  := freq_in/(2 * freq_out);

    
    SIGNAL count        : POSITIVE RANGE 1 TO limit := 1; 
    SIGNAL clock_signal : STD_LOGIC                 := '0';

BEGIN
    clock_div <= clock_signal;
    PROCESS (clock)
    BEGIN
        IF rising_edge(clock) THEN
            IF count < limit THEN
                count <= count + 1;
            ELSE
                count        <= 1;
                clock_signal <= NOT clock_signal;
            END IF;
        END IF;
    END PROCESS;
END Behavioral;

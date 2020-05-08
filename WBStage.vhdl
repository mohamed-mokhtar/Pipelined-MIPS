LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;


ENTITY WBEnt IS
    GENERIC(
            n : integer := 32
        ); 

    PORT(
            --  For entity
            Clk,Enable: IN std_logic;

            -- Signals
            ControlSignals : IN std_logic_vector(26 DOWNTO 0);
            Int: IN std_logic;

            -- SP 
            SP : IN std_logic_vector(n-1 DOWNTO 0);

            -- Data
            MemOut,ALUResult: IN std_logic_vector(n-1 DOWNTO 0);

            -- Outputs
            ControlSignalsOut : OUT std_logic_vector(26 DOWNTO 0);
            IntOut : OUT std_logic;
            Mux10Out, SPOut : OUT std_logic_vector(n-1 DOWNTO 0)

        );
END ENTITY;


ARCHITECTURE WBArch OF WBEnt IS 
COMPONENT Mux21Ent IS
PORT ( 
        s0: IN STD_LOGIC ;
        IN0,IN1 : IN std_logic_vector(n-1 DOWNTO 0);
        F : OUT std_logic_vector(n-1 DOWNTO 0)
    );
END COMPONENT;


SIGNAL SPDecrement: std_logic_vector(n-1 DOWNTO 0);
SIGNAL SMux9 : std_logic;

-- CONTROL SIGNALS
SIGNAL IncOrDec,MemToReg: std_logic;

BEGIN

    -- MUXES
    Mux9    : Mux21Ent port map(SMux9,SPDecrement,SP,SPOut);
    Mux10   : Mux21Ent port map(MemToReg,ALUResult,MemOut,Mux10Out);

    PROCESS(Clk) BEGIN 
        IF(rising_edge(Clk) AND Enable='1') THEN
            -- Signals 
            IncOrDec <= ControlSignals(17);
            MemToReg <= ControlSignals(8);

            SMux9 <= (NOT Int) OR IncOrDec;
            SPDecrement <= SP-1;

            -- Outputs
            IntOut <= Int;
            ControlSignalsOut <= ControlSignals;
        END IF;
    END PROCESS;
    
END ARCHITECTURE;
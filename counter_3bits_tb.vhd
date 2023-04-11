library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE IEEE.std_logic_unsigned.ALL;

ENTITY count3_tb IS
END ENTITY count3_tb;

ARCHITECTURE bench OF count3_tb IS
    COMPONENT count3 IS
        PORT (
            clk : IN STD_LOGIC;
            resetn : IN STD_LOGIC;
            count_en : IN STD_LOGIC;
            sum : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            up : IN STD_LOGIC;
            cout : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL clk : STD_LOGIC;
    SIGNAL resetn : STD_LOGIC := '0';
    SIGNAL count_en : STD_LOGIC;
    SIGNAL sum : STD_LOGIC_VECTOR(2 DOWNTO 0) ;
    SIGNAL up : STD_LOGIC;
    SIGNAL cout : STD_LOGIC;

    CONSTANT CLOCK_PERIOD : TIME := 10ns;

    BEGIN

    uut : count3  
    port map (
            clk => clk,
            resetn => resetn,
            count_en => count_en,
            sum => sum,
            up => up,
            cout => cout
        );
    
           stimulus : PROCESS
    BEGIN
        resetn <= '0';
        wait for CLOCK_PERIOD;
        resetn <= '1';
        count_en <= '1';
        up <= '1';
        wait for CLOCK_PERIOD;
        count_en <= '1';
        up <= '1';
        wait for CLOCK_PERIOD;
        count_en <= '1';
        up <= '0';
        wait for CLOCK_PERIOD;
        count_en <= '1';
        up <= '1';
        wait for CLOCK_PERIOD;
        count_en <= '1';
        up <= '1';
        wait for CLOCK_PERIOD;
        count_en <= '1';
        up <= '1';
        wait for CLOCK_PERIOD;
        count_en <= '1';
        up <= '1';
        wait for CLOCK_PERIOD;
        count_en <= '1';
        up <= '1';
        wait for CLOCK_PERIOD;
        count_en <= '1';
        up <= '1';
        wait for CLOCK_PERIOD;
        count_en <= '1';
        up <= '1';
        wait for CLOCK_PERIOD;
    END PROCESS;

    generate_clk : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR CLOCK_PERIOD/2;
        clk <= '1';
        WAIT FOR CLOCK_PERIOD/2;
    END PROCESS;

END ARCHITECTURE;
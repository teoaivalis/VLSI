library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity FIR_Test is
--end entity;
generic (
data_width : integer :=8 -- width of dc (bits)
);
end FIR_Test;

architecture tbFIR of FIR_Test is
-- DUT component
component FIR is
port ( x_in : in std_logic_vector(data_width-1 downto 0);
valid_in : in std_logic;
rst : in std_logic;
valid_out : out std_logic;
y : out std_logic_vector(15 downto 0);
CLK : in std_logic);
end component;
signal x_in : std_logic_vector(data_width-1 downto 0);
signal valid_in : std_logic;
signal rst : std_logic;
signal valid_out : std_logic;
signal y : std_logic_vector(15 downto 0);
SIGNAL CLK : STD_LOGIC := '0';

CONSTANT TIME_DELAY : time := 10 ns;
--SIGNAL CLK : STD_LOGIC := '0';
begin
-- Connect DUT
UUT: FIR
port map(x_in=>x_in, valid_in=>valid_in, rst=>rst, valid_out=>valid_out, y=>y, CLK=>CLK);

process is
begin
rst <='1';
valid_in <='0';
x_in <="00000000";
wait for 9*TIME_DELAY;
rst <= '0';
valid_in <='1';
x_in<="00000010";
wait for 9*TIME_DELAY;
--rst <='0';
--valid_in <='0';
--x_in<="00000000";
--wait for 9*TIME_DELAY;
rst <='0';
valid_in <='1';
x_in<="00000100";
wait for 9*TIME_DELAY;
rst <='0';
valid_in <='1';
x_in<="00001000";
wait for 9*TIME_DELAY;

--assert false report "Test done." severity note;
--wait;
end process;

generate_clock: process
begin
CLK <= '0';
wait for TIME_DELAY/2;
CLK <= '1';
wait for TIME_DELAY/2;
end process;
--CLK <= not CLK after clk_period/2;
end tbFIR;

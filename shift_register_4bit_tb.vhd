library ieee;
use ieee.std_logic_1164.all;

entity tb_rshift_reg3 is
end tb_rshift_reg3;

architecture tb of tb_rshift_reg3 is

    component rshift_reg3
        port (clk   : in std_logic;
              rst   : in std_logic;
              si    : in std_logic;
              en    : in std_logic;
              pl    : in std_logic;
              shift : in std_logic;
              din   : in std_logic_vector (3 downto 0);
              so    : out std_logic);
    end component;

    signal clk   : std_logic;
    signal rst   : std_logic;
    signal si    : std_logic;
    signal en    : std_logic;
    signal pl    : std_logic;
    signal shift : std_logic;
    signal din   : std_logic_vector (3 downto 0);
    signal so    : std_logic;

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : rshift_reg3
    port map (clk   => clk,
              rst   => rst,
              si    => si,
              en    => en,
              pl    => pl,
              shift => shift,
              din   => din,
              so    => so);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        si <= '0';
        en <= '0';
        pl <= '0';
        shift <= '0';
        din <= (others => '0');

        -- Reset generation
        -- EDIT: Check that rst is really your reset signal
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;
        pl <= '1';
        shift <= '1';
        din <= "1111";
        wait for 100 ns;
        pl <= '0';
        en <= '1';
        wait for 100 ns;
        en <= '1';
        wait for 100 ns;
        shift <= '0';
        en <= '1';

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_rshift_reg3 of tb_rshift_reg3 is
    for tb
    end for;
end cfg_tb_rshift_reg3;
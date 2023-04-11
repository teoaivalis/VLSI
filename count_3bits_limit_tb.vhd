library ieee;
use ieee.std_logic_1164.all;

entity tb_count3_limit is
end tb_count3_limit;

architecture tb of tb_count3_limit is

    component count3_limit
        port (clk      : in std_logic;
              resetn   : in std_logic;
              count_en : in std_logic;
              limit    : in std_logic_vector (2 downto 0);
              sum      : out std_logic_vector (2 downto 0);
              cout     : out std_logic);
    end component;

    signal clk      : std_logic;
    signal resetn   : std_logic;
    signal count_en : std_logic;
    signal limit    : std_logic_vector (2 downto 0);
    signal sum      : std_logic_vector (2 downto 0);
    signal cout     : std_logic;

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : count3_limit
    port map (clk      => clk,
              resetn   => resetn,
              count_en => count_en,
              limit    => limit,
              sum      => sum,
              cout     => cout);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        count_en <= '0';
        limit <= (others => '0');
        

        -- Reset generation
        -- EDIT: Check that resetn is really your reset signal
        resetn <= '0';
        wait for 100 ns;
        resetn <= '1';
        wait for 100 ns;
        count_en <= '1';
        limit <= "100";
        wait for 100 ns;

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_count3_limit of tb_count3_limit is
    for tb
    end for;
end cfg_tb_count3_limit;
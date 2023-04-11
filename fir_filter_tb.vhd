LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_fir_filter_4 IS
END tb_fir_filter_4;

ARCHITECTURE tb OF tb_fir_filter_4 IS

    COMPONENT fir_filter_4
        PORT (
            i_clk : IN STD_LOGIC;
            i_rstb : IN STD_LOGIC;
            i_coeff_0 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            i_coeff_1 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            i_coeff_2 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            i_coeff_3 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            i_coeff_4 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            i_coeff_5 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            i_coeff_6 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            i_coeff_7 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            i_data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            valid_in : IN STD_LOGIC;
            o_data : OUT STD_LOGIC_VECTOR (18 DOWNTO 0);
            valid_out : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL i_clk : STD_LOGIC;
    SIGNAL i_rstb : STD_LOGIC;
    SIGNAL i_coeff_0 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL i_coeff_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL i_coeff_2 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL i_coeff_3 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL i_coeff_4 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL i_coeff_5 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL i_coeff_6 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL i_coeff_7 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL i_data : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL valid_in : STD_LOGIC;
    SIGNAL o_data : STD_LOGIC_VECTOR (18 DOWNTO 0);
    SIGNAL valid_out : STD_LOGIC;

    CONSTANT TbPeriod : TIME := 100 ns; -- EDIT Put right period here
    SIGNAL TbClock : STD_LOGIC := '0';
    SIGNAL TbSimEnded : STD_LOGIC := '0';

BEGIN

    dut : fir_filter_4
    PORT MAP(
        i_clk => i_clk,
        i_rstb => i_rstb,
        i_coeff_0 => i_coeff_0,
        i_coeff_1 => i_coeff_1,
        i_coeff_2 => i_coeff_2,
        i_coeff_3 => i_coeff_3,
        i_coeff_4 => i_coeff_4,
        i_coeff_5 => i_coeff_5,
        i_coeff_6 => i_coeff_6,
        i_coeff_7 => i_coeff_7,
        i_data => i_data,
        valid_in => valid_in,
        o_data => o_data,
        valid_out =>valid_out);

    -- Clock generation
    TbClock <= NOT TbClock AFTER TbPeriod/2 WHEN TbSimEnded /= '1' ELSE
        '0';

    -- EDIT: Check that i_clk is really your main clock signal
    i_clk <= TbClock;

    stimuli : PROCESS
    BEGIN
        -- EDIT Adapt initialization as needed
        i_coeff_0 <= (OTHERS => '0');
        i_coeff_1 <= (OTHERS => '0');
        i_coeff_2 <= (OTHERS => '0');
        i_coeff_3 <= (OTHERS => '0');
        i_coeff_4 <= (OTHERS => '0');
        i_coeff_5 <= (OTHERS => '0');
        i_coeff_6 <= (OTHERS => '0');
        i_coeff_7 <= (OTHERS => '0');
        valid_in <= '0';
        i_data <= (OTHERS => '0');

        -- Reset generation
        -- EDIT: Check that i_rstb is really your reset signal
        i_rstb <= '1';
        WAIT FOR 100 ns;
        i_rstb <= '0';
        WAIT FOR 100 ns;
        i_coeff_0 <= "00000001";
        i_coeff_1 <= "00000010";
        i_coeff_2 <= "00000011";
        i_coeff_3 <= "00000100";
        i_coeff_4 <= "00000101";
        i_coeff_5 <= "00000110";
        i_coeff_6 <= "00000111";
        i_coeff_7 <= "00001000";
        i_data <= "00011011";
        valid_in <= '1';
        WAIT FOR 100 ns;
        i_data <= "11110110";
        valid_in <= '1';
        WAIT FOR 100 ns;
        i_data <= "00000001";
        valid_in <= '1';
        WAIT FOR 100 ns;
        i_data <= "11000110";
        valid_in <= '1';
        WAIT FOR 100 ns;
        i_data <= "11010001";
        valid_in <= '1';
        WAIT FOR 100 ns;
        i_data <= "11011110";
        valid_in <= '1';
        WAIT FOR 100 ns;
        i_data <= "00010101";
        valid_in <= '1';
        WAIT FOR 100 ns;
        i_data <= "01100110";
        valid_in <= '1';
        WAIT FOR 100 ns;
        i_data <= "01000010";
        valid_in <= '1';
        WAIT FOR 100 ns;
        i_data <= "11001100";
        valid_in <= '1';
        WAIT FOR 100 ns;

        -- EDIT Add stimuli here
        WAIT FOR 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        WAIT;
    END PROCESS;

END tb;
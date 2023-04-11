LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_fir_filter_paral IS
END tb_fir_filter_paral;

ARCHITECTURE tb OF tb_fir_filter_paral IS

    COMPONENT fir_filter_paral
        PORT (
            i_clk : IN STD_LOGIC;
            i_rstb : IN STD_LOGIC;
            coeff_0 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            coeff_1 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            coeff_2 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            coeff_3 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            coeff_4 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            coeff_5 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            coeff_6 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            coeff_7 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            valid_in :IN STD_LOGIC;
            in_1 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            in_2 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            out_1 : OUT STD_LOGIC_VECTOR (18 DOWNTO 0);
            out_2 : OUT STD_LOGIC_VECTOR (18 DOWNTO 0);
            valid_out_1 : OUT STD_LOGIC;
            valid_out_2 : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL i_clk : STD_LOGIC;
    SIGNAL i_rstb : STD_LOGIC;
    SIGNAL coeff_0 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL coeff_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL coeff_2 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL coeff_3 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL coeff_4 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL coeff_5 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL coeff_6 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL coeff_7 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL valid_in : STD_LOGIC;
    SIGNAL in_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL in_2 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL out_1 : STD_LOGIC_VECTOR (18 DOWNTO 0);
    SIGNAL out_2 : STD_LOGIC_VECTOR (18 DOWNTO 0);
    SIGNAL valid_out_1 : STD_LOGIC;
    SIGNAL valid_out_2 : STD_LOGIC;

    CONSTANT TbPeriod : TIME := 100 ns; -- EDIT Put right period here
    SIGNAL TbClock : STD_LOGIC := '0';
    SIGNAL TbSimEnded : STD_LOGIC := '0';

BEGIN

    dut : fir_filter_paral
    PORT MAP(
        i_clk => i_clk,
        i_rstb => i_rstb,
        coeff_0 => coeff_0,
        coeff_1 => coeff_1,
        coeff_2 => coeff_2,
        coeff_3 => coeff_3,
        coeff_4 => coeff_4,
        coeff_5 => coeff_5,
        coeff_6 => coeff_6,
        coeff_7 => coeff_7,
        valid_in => valid_in,
        in_1 => in_1,
        in_2 => in_2,
        out_1 => out_1,
        out_2 => out_2,
        valid_out_1 => valid_out_1,
        valid_out_2 => valid_out_2);

    -- Clock generation
    TbClock <= NOT TbClock AFTER TbPeriod/2 WHEN TbSimEnded /= '1' ELSE
        '0';

    -- EDIT: Check that i_clk is really your main clock signal
    i_clk <= TbClock;

    stimuli : PROCESS
    BEGIN
        -- EDIT Adapt initialization as needed
        coeff_0 <= (OTHERS => '0');
        coeff_1 <= (OTHERS => '0');
        coeff_2 <= (OTHERS => '0');
        coeff_3 <= (OTHERS => '0');
        coeff_4 <= (OTHERS => '0');
        coeff_5 <= (OTHERS => '0');
        coeff_6 <= (OTHERS => '0');
        coeff_7 <= (OTHERS => '0');
        valid_in <= '0';
        in_1 <= (OTHERS => '0');
        in_2 <= (OTHERS => '0');

        -- Reset generation
        -- EDIT: Check that i_rstb is really your reset signal
        i_rstb <= '1';
        WAIT FOR 100 ns;
        i_rstb <= '0';
        WAIT FOR 100 ns;
        coeff_0 <= "00000001";
        coeff_1 <= "00000010";
        coeff_2 <= "00000011";
        coeff_3 <= "00000100";
        coeff_4 <= "00000101";
        coeff_5 <= "00000110";
        coeff_6 <= "00000111";
        coeff_7 <= "00001000";
        valid_in <= '1';
        in_1 <= "00011011";
        in_2 <= "11110110";
        WAIT FOR 100 ns;
        valid_in <= '1';
        in_1 <= "00000001";
        in_2 <= "11000110";
        WAIT FOR 100 ns;
        valid_in <= '1';
        in_1 <= "11010001";
        in_2 <= "11011110";
        WAIT FOR 100 ns;
        valid_in <= '1';
        in_1 <= "00010101";
        in_2 <= "01100110";
        WAIT FOR 100 ns;
        valid_in <= '1';
        in_1 <= "01000010";
        in_2 <= "11001100";
        WAIT FOR 100 ns;

        -- EDIT Add stimuli here
        WAIT FOR 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        WAIT;
    END PROCESS;

END tb;


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY fir_filter_paral IS
    PORT (
        i_clk : IN STD_LOGIC;
        i_rstb : IN STD_LOGIC;
        -- coefficient
        coeff_0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        coeff_1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        coeff_2 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        coeff_3 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        coeff_4 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        coeff_5 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        coeff_6 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        coeff_7 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        valid_in : IN STD_LOGIC;
        -- data input
        in_1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        in_2 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        -- filtered data 
        out_1 : OUT STD_LOGIC_VECTOR(18 DOWNTO 0);
        out_2 : OUT STD_LOGIC_VECTOR(18 DOWNTO 0);
        valid_out_1 : OUT STD_LOGIC;
        valid_out_2 : OUT STD_LOGIC);
END fir_filter_paral;

ARCHITECTURE rtl OF fir_filter_paral IS
    COMPONENT fir_filter_paral_1 IS
        PORT (
            i_clk : IN STD_LOGIC;
            i_rstb : IN STD_LOGIC;
            -- coefficient
            coeff_0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            coeff_1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            coeff_2 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            coeff_3 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            coeff_4 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            coeff_5 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            coeff_6 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            coeff_7 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            valid_in : IN STD_LOGIC;
            -- data input
            i_data_1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            i_data_2 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            -- filtered data 
            out_data_1 : OUT STD_LOGIC_VECTOR(18 DOWNTO 0);
            valid_out : OUT STD_LOGIC);
    END COMPONENT;
    COMPONENT fir_filter_paral_2 IS
        PORT (
            i_clk : IN STD_LOGIC;
            i_rstb : IN STD_LOGIC;
            -- coefficient
            coeff_0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            coeff_1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            coeff_2 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            coeff_3 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            coeff_4 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            coeff_5 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            coeff_6 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            coeff_7 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            valid_in : IN STD_LOGIC;
            -- data input
            i_data_1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            i_data_2 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            -- filtered data 
            out_data_2 : OUT STD_LOGIC_VECTOR(18 DOWNTO 0);
            valid_out : OUT STD_LOGIC);
    END COMPONENT;
    --SIGNAL out_helper_1, out_helper_2 : STD_LOGIC_VECTOR(18 DOWNTO 0);

BEGIN
    P1 : fir_filter_paral_1 PORT MAP(i_clk, i_rstb, coeff_0, coeff_1, coeff_2, coeff_3, coeff_4, coeff_5, coeff_6, coeff_7, valid_in, in_1, in_2, out_1, valid_out_1);
    P2 : fir_filter_paral_2 PORT MAP(i_clk, i_rstb, coeff_0, coeff_1, coeff_2, coeff_3, coeff_4, coeff_5, coeff_6, coeff_7, valid_in, in_1, in_2, out_2, valid_out_2);
END rtl;
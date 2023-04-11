LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY fir_filter_paral_1 IS
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
END fir_filter_paral_1;

ARCHITECTURE rtl OF fir_filter_paral_1 IS
    --TYPE t_data_pipe IS ARRAY (0 TO 8) OF signed(7 DOWNTO 0);
    TYPE t_data_pipe_1 IS ARRAY (0 TO 3) OF unsigned(7 DOWNTO 0); -- x[0], x[2]
    TYPE t_data_pipe_2 IS ARRAY (0 TO 4) OF unsigned(7 DOWNTO 0); -- x[1], x[3]
    TYPE t_coeff IS ARRAY (0 TO 7) OF unsigned(7 DOWNTO 0);
    TYPE t_mult IS ARRAY (0 TO 7) OF unsigned(15 DOWNTO 0);
    TYPE t_add_st0 IS ARRAY (0 TO 3) OF unsigned(18 DOWNTO 0);
    TYPE t_add_st1 IS ARRAY (0 TO 1) OF unsigned(18 DOWNTO 0);
    SIGNAL r_coeff : t_coeff;
    SIGNAL p_data_1 : t_data_pipe_1;
    SIGNAL p_data_2 : t_data_pipe_2;
    SIGNAL r_mult : t_mult;
    SIGNAL r_add_st0 : t_add_st0;
    SIGNAL r_add_st1 : t_add_st1;
    SIGNAL r_add_st2 : unsigned(18 DOWNTO 0);
BEGIN
    p_input : PROCESS (i_rstb, i_clk)
    BEGIN
        IF (i_rstb = '1') THEN
            p_data_1 <= (OTHERS => (OTHERS => '0'));
            p_data_2 <= (OTHERS => (OTHERS => '0'));
            r_coeff <= (OTHERS => (OTHERS => '0'));
        ELSIF (rising_edge(i_clk)) THEN
            IF (valid_in = '1') THEN
                p_data_1 <= unsigned(i_data_1) & p_data_1(0 TO p_data_1'length - 2);
                p_data_2 <= unsigned(i_data_2) & p_data_2(0 TO p_data_2'length - 2);
                r_coeff(0) <= unsigned(coeff_0);
                r_coeff(1) <= unsigned(coeff_1);
                r_coeff(2) <= unsigned(coeff_2);
                r_coeff(3) <= unsigned(coeff_3);
                r_coeff(4) <= unsigned(coeff_4);
                r_coeff(5) <= unsigned(coeff_5);
                r_coeff(6) <= unsigned(coeff_6);
                r_coeff(7) <= unsigned(coeff_7);
            ELSE
                p_data_1 <= (OTHERS => (OTHERS => '0'));
                p_data_2 <= (OTHERS => (OTHERS => '0'));
                r_coeff <= (OTHERS => (OTHERS => '0'));
            END IF;
        END IF;
    END PROCESS p_input;
    p_mult : PROCESS (i_rstb, i_clk)
    BEGIN
        IF (i_rstb = '1') THEN
            r_mult <= (OTHERS => (OTHERS => '0'));
        ELSIF (rising_edge(i_clk)) THEN
            r_mult(0) <= p_data_1(0) * r_coeff(0);
            r_mult(1) <= p_data_2(1) * r_coeff(1);
            r_mult(2) <= p_data_1(1) * r_coeff(2);
            r_mult(3) <= p_data_2(2) * r_coeff(3);
            r_mult(4) <= p_data_1(2) * r_coeff(4);
            r_mult(5) <= p_data_2(3) * r_coeff(5);
            r_mult(6) <= p_data_1(3) * r_coeff(6);
            r_mult(7) <= p_data_2(4) * r_coeff(7);
        END IF;
    END PROCESS p_mult;

    p_add_st0 : PROCESS (i_rstb, i_clk)
    BEGIN
        IF (i_rstb = '1') THEN
            r_add_st0 <= (OTHERS => (OTHERS => '0'));
        ELSIF (rising_edge(i_clk)) THEN
            FOR k IN 0 TO 3 LOOP
                r_add_st0(k) <= resize(r_mult(2 * k), 19) + resize(r_mult(2 * k + 1), 19);
            END LOOP;
        END IF;
    END PROCESS p_add_st0;
    p_add_st1 : PROCESS (i_rstb, i_clk)
    BEGIN
        IF (i_rstb = '1') THEN
            r_add_st1 <= (OTHERS => (OTHERS => '0'));
        ELSIF (rising_edge(i_clk)) THEN
            FOR k IN 0 TO 1 LOOP
                r_add_st1(k) <= r_add_st0(2 * k) + r_add_st0(2 * k + 1);
            END LOOP;
        END IF;
    END PROCESS p_add_st1;
    p_add_st2 : PROCESS (i_rstb, i_clk)
    BEGIN
        IF (i_rstb = '1') THEN
            r_add_st2 <= (OTHERS => '0');
        ELSIF (rising_edge(i_clk)) THEN
            r_add_st2 <= r_add_st1(0) + r_add_st1(1);
        END IF;
    END PROCESS p_add_st2;

    p_output : PROCESS (i_rstb, i_clk)
    BEGIN
        IF (i_rstb = '1') THEN
            out_data_1 <= (OTHERS => '0');
        ELSIF (rising_edge(i_clk)) THEN
            out_data_1 <= STD_LOGIC_VECTOR(r_add_st2(18 DOWNTO 0));
        END IF;
    END PROCESS p_output;
    valid_out <= '0' WHEN r_add_st2 = 0 ELSE
        '1';
END rtl;
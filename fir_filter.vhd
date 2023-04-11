LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY fir_filter_4 IS
    PORT (
        i_clk : IN STD_LOGIC;
        i_rstb : IN STD_LOGIC;
        -- coefficient
        i_coeff_0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        i_coeff_1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        i_coeff_2 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        i_coeff_3 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        i_coeff_4 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        i_coeff_5 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        i_coeff_6 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        i_coeff_7 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        valid_in : IN STD_LOGIC;
        -- data input
        i_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        -- filtered data 
        o_data : OUT STD_LOGIC_VECTOR(18 DOWNTO 0);
        valid_out : OUT STD_LOGIC);
END fir_filter_4;
ARCHITECTURE rtl OF fir_filter_4 IS
    TYPE t_data_pipe IS ARRAY (0 TO 7) OF unsigned(7 DOWNTO 0);
    TYPE t_coeff IS ARRAY (0 TO 7) OF unsigned(7 DOWNTO 0);
    TYPE t_mult IS ARRAY (0 TO 7) OF unsigned(15 DOWNTO 0);
    TYPE t_add_st0 IS ARRAY (0 TO 3) OF unsigned(18 DOWNTO 0);
    TYPE t_add_st1 IS ARRAY (0 TO 1) OF unsigned(18 DOWNTO 0);
    SIGNAL r_coeff : t_coeff;
    SIGNAL p_data : t_data_pipe;
    SIGNAL r_mult : t_mult;
    SIGNAL r_add_st0 : t_add_st0;
    SIGNAL r_add_st1 : t_add_st1;
    SIGNAL r_add_st2 : unsigned(18 DOWNTO 0);
BEGIN
    p_input : PROCESS (i_rstb, i_clk)
    BEGIN
        IF (i_rstb = '1') THEN
            p_data <= (OTHERS => (OTHERS => '0'));
            r_coeff <= (OTHERS => (OTHERS => '0'));
        ELSIF (rising_edge(i_clk)) THEN
            IF (valid_in = '1') THEN
                p_data <= unsigned(i_data) & p_data(0 TO p_data'length - 2);
                r_coeff(0) <= unsigned(i_coeff_0);
                r_coeff(1) <= unsigned(i_coeff_1);
                r_coeff(2) <= unsigned(i_coeff_2);
                r_coeff(3) <= unsigned(i_coeff_3);
                r_coeff(4) <= unsigned(i_coeff_4);
                r_coeff(5) <= unsigned(i_coeff_5);
                r_coeff(6) <= unsigned(i_coeff_6);
                r_coeff(7) <= unsigned(i_coeff_7);
            ELSE
                p_data <= (OTHERS => (OTHERS => '0'));
                r_coeff <= (OTHERS => (OTHERS => '0'));
            END IF;
        END IF;
    END PROCESS p_input;
    p_mult : PROCESS (i_rstb, i_clk)
    BEGIN
        IF (i_rstb = '1') THEN
            r_mult <= (OTHERS => (OTHERS => '0'));
        ELSIF (rising_edge(i_clk)) THEN
            FOR k IN 0 TO 7 LOOP
                r_mult(k) <= p_data(k) * r_coeff(k);
            END LOOP;
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
            o_data <= (OTHERS => '0');
        ELSIF (rising_edge(i_clk)) THEN
            o_data <= STD_LOGIC_VECTOR(r_add_st2(18 DOWNTO 0));
        END IF;
    END PROCESS p_output;
    valid_out <= '0' WHEN r_add_st2 = 0 ELSE
        '1';
END rtl;
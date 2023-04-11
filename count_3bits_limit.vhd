LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
--USE IEEE.NUMERIC_STD

ENTITY count3_limit IS
    PORT (
        clk,
        resetn,
        count_en : IN STD_LOGIC;
        limit : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        sum : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        cout : OUT STD_LOGIC
    );
END;
ARCHITECTURE rtl_nolimit OF count3_limit IS
    SIGNAL count : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN
    PROCESS (clk, resetn)
    BEGIN
        IF resetn = '0' THEN
            -- �?�?δικας για την πε�?ίπτωση του reset (ενε�?γ�? χαμηλά)
            count <= (OTHERS => '0');
        ELSIF clk'event AND clk = '1' THEN
            IF count_en = '1' THEN
                -- �?έτ�?ηση μ�?νο αν count_en = 1
                count <= count + 1;
            END IF;
        END IF;
        IF (count - limit) = "001" THEN
            IF count_en = '1' THEN
                sum <= "000";
                count <= "000";
            END IF;
        ELSE
            sum <= count;
        END IF;
    END PROCESS;

    cout <= '1' WHEN (count - limit) = "001" AND count_en = '1' ELSE
        '0';
END rtl_nolimit;
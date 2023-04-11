LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
ENTITY count3 IS
    PORT (
        clk,
        resetn,
        count_en : IN STD_LOGIC;
        sum : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        up : IN STD_LOGIC;
        cout : OUT STD_LOGIC
        );
END;
ARCHITECTURE rtl_nolimit OF count3 IS
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
                CASE up IS
                WHEN '1' =>
                    count <= count + 1;
                WHEN '0' =>
                    count <= count - 1;
                when others =>
                    count <= count + 1;                
                END CASE;
            END IF;
        END IF;
    END PROCESS;
    -- Ανάθεση τιμ�?ν στα σήματα εξ�?δου
    sum <= count;
    cout <= '1' WHEN count = 7 AND count_en = '1' AND up = '1' ELSE
        '0';
END rtl_nolimit;


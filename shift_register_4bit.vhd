LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY rshift_reg3 IS
    PORT (
        clk, rst, si, en, pl, shift : IN STD_LOGIC;
        din : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        so : OUT STD_LOGIC
    );
END rshift_reg3;

ARCHITECTURE behavioral OF rshift_reg3 IS

    SIGNAL dff : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    -- SIGNAL final : STD_LOGIC := '0';

BEGIN
    edge : PROCESS (clk, rst)

    BEGIN
        IF rst = '1' THEN
            dff <= (OTHERS => '0');
            --so <= '0';
        ELSIF clk'event AND clk = '1' THEN
            CASE shift IS
                WHEN '1' =>
                    IF pl = '1' THEN
                        dff <= din;
                    ELSIF en = '1' THEN
                        --so <= (si & dff(3 DOWNTO 1))(0);
                        dff <= si & dff(3 DOWNTO 1);
                        --so <= dff(0);
                    END IF;
                WHEN '0' =>
                    IF pl = '1' THEN
                        dff <= din;
                    ELSIF en = '1' THEN
                        --so <= (si & dff(3 DOWNTO 1))(3);
                        dff <= dff(2 DOWNTO 0) & si;
                        --so <= dff(3);
                    END IF;
                WHEN OTHERS =>
                    so <= '0';
            END CASE;
        END IF;
        IF shift = '1' THEN
            so <= dff(0);
        ELSE
            so <= dff(3);
        END IF;
    END PROCESS;

END behavioral;
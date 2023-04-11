LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY mlab_rom IS
    GENERIC (
        data_width : INTEGER := 8 --- width of coefficients (bits)
    );
    PORT (
        CLK : IN STD_LOGIC;
        en : IN STD_LOGIC; --- operation enable
        addr : IN STD_LOGIC_VECTOR (2 DOWNTO 0); -- memory address
        rom_out : OUT STD_LOGIC_VECTOR (data_width - 1 DOWNTO 0)); -- output data
END mlab_rom;

ARCHITECTURE Behavioral OF mlab_rom IS

    TYPE rom_type IS ARRAY (7 DOWNTO 0) OF STD_LOGIC_VECTOR (data_width - 1 DOWNTO 0);
    SIGNAL rom : rom_type := ("00001000", "00000111", "00000110", "00000101", "00000100", "00000011", "00000010",
    "00000001"); -- initialization of rom with user data                 

    --SIGNAL rdata : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0) := (OTHERS => '0');
BEGIN

    --rdata <= rom(conv_integer(addr));

    PROCESS (CLK)
    BEGIN
        IF (CLK'event AND CLK = '1') THEN
            IF (en = '1') THEN
                rom_out <= rom(conv_integer(addr));
            END IF;
        END IF;
    END PROCESS;

END Behavioral;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY mlab_ram IS
    GENERIC (
        data_width : INTEGER := 8 --- width of data (bits)
    );
    PORT (
        CLK : IN STD_LOGIC;
        we : IN STD_LOGIC; --- memory write enable
        en : IN STD_LOGIC; --- operation enable
        addr : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- memory address
        di : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0); -- input data
        do : OUT STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0)); -- output data
END mlab_ram;

ARCHITECTURE Behavioral OF mlab_ram IS

    TYPE ram_type IS ARRAY (7 DOWNTO 0) OF STD_LOGIC_VECTOR (data_width - 1 DOWNTO 0);
    SIGNAL RAM : ram_type := (OTHERS => (OTHERS => '0'));

BEGIN
    PROCESS (CLK)
    BEGIN
        IF (CLK'event AND CLK = '1') THEN
            IF (en = '1') THEN
                IF addr = "000" AND we = '1' THEN -- write operation
                    FOR i IN 0 TO 6 LOOP
                        RAM(7 - i) <= RAM(6 - i);
                    END LOOP;
                    RAM(conv_integer(addr)) <= di;
                    do <= di;
                ELSE -- read operation
                    do <= RAM(conv_integer(addr));
                END IF;
            END IF;
        END IF;
    END PROCESS;
END Behavioral;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY MAC_Accumulator IS
    PORT (
        ROM_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        RAM_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        reset : IN STD_LOGIC;
        CLK : IN STD_LOGIC;
        mac_init : IN STD_LOGIC;
        L_out : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY MAC_Accumulator;
ARCHITECTURE behave OF MAC_Accumulator IS
BEGIN
    PROCESS (CLK)
    BEGIN
        IF reset = '1' THEN
            L_out <= (OTHERS => '0');
        ELSIF (CLK' event AND CLK = '1') THEN
            IF mac_init = '1' THEN
                L_out <= (OTHERS => '0');
            ELSE
                L_out <= (L_out + ROM_in * RAM_in);
            END IF;
        END IF;
    END PROCESS;
END behave;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY Control_Unit IS
    PORT (
        rst_count : IN STD_LOGIC;
        CLK : IN STD_LOGIC;
        rom_address : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        ram_address : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        mac_init : OUT STD_LOGIC;
        cu_valid_out : OUT STD_LOGIC
    );
END Control_Unit;
ARCHITECTURE behave OF Control_Unit IS
    SIGNAL cu_out : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL mac_out : STD_LOGIC;
    SIGNAL cu_valid_out_w : STD_LOGIC;
BEGIN
    PROCESS (CLK, rst_count)
    BEGIN
        IF rst_count = '1' THEN
            cu_out <= "000";
            mac_out <= '1';
            cu_valid_out_w <= '0';
        ELSE
            IF (CLK' event AND CLK = '1') THEN
                IF cu_out = "111" THEN
                    mac_out <= '1';
                    cu_out <= "000";
                    cu_valid_out_w <= '1';
                ELSE
                    cu_out <= (cu_out + 1);
                    mac_out <= '0';
                    cu_valid_out_w <= '0';
                END IF;
            END IF;
        END IF;
    END PROCESS;
    -- Assign output
    rom_address <= cu_out;
    ram_address <= cu_out;
    mac_init <= mac_out;
    cu_valid_out <= cu_valid_out_w;
END behave;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY DFF IS
    PORT (
        data_in : IN STD_LOGIC;
        CLK : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        data_out : OUT STD_LOGIC
    );
END DFF;
ARCHITECTURE Behavioral OF DFF IS
BEGIN
    PROCESS (CLK, rst)
    BEGIN
        IF rst = '1' THEN
            data_out <= '0';
        ELSE
            IF rising_edge(CLK) THEN
                data_out <= data_in;
            END IF;
        END IF;
    END PROCESS;
END Behavioral;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY FIR IS
    GENERIC (
        data_width : INTEGER := 8 -- width of dc (bits)
    );
    PORT (
        x_in : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
        valid_in : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        valid_out : OUT STD_LOGIC;
        y : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        CLK : IN STD_LOGIC);
END FIR;
ARCHITECTURE Structural OF FIR IS
    COMPONENT mlab_rom IS
        PORT (
            CLK : IN STD_LOGIC;
            en : IN STD_LOGIC; -- operation enable
            addr : IN STD_LOGIC_VECTOR (2 DOWNTO 0); -- memory address
            rom_out : OUT STD_LOGIC_VECTOR (data_width - 1 DOWNTO 0)); -- output data
    END COMPONENT;
    COMPONENT mlab_ram IS
        PORT (
            CLK : IN STD_LOGIC;
            we : IN STD_LOGIC; -- memory write enable
            en : IN STD_LOGIC; -- operation enable
            addr : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- memory address
            di : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0); -- input data
            do : OUT STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0));-- output data
    END COMPONENT;
    COMPONENT MAC_Accumulator IS
        PORT (
            ROM_in : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
            RAM_in : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
            reset : IN STD_LOGIC;
            CLK : IN STD_LOGIC;
            mac_init : IN STD_LOGIC;
            L_out : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0));
    END COMPONENT;
    COMPONENT Control_Unit IS
        PORT (
            rst_count : IN STD_LOGIC;
            CLK : IN STD_LOGIC;
            rom_address : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            ram_address : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            mac_init : OUT STD_LOGIC;
            cu_valid_out : OUT STD_LOGIC);
    END COMPONENT;
    COMPONENT DFF IS
        PORT (
            data_in : IN STD_LOGIC;
            CLK : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            data_out : OUT STD_LOGIC);
    END COMPONENT;
    SIGNAL rom_address_w : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL ram_address_w : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL mac_init_w1 : STD_LOGIC;
    SIGNAL mac_init_w2 : STD_LOGIC;
    SIGNAL mac_init_w3 : STD_LOGIC;
    SIGNAL valid_out_w1 : STD_LOGIC;
    SIGNAL valid_out_w2 : STD_LOGIC;
    SIGNAL rom_out_w : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    SIGNAL ram_out_w : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    SIGNAL mac_out_w : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL x_w : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    SIGNAL en_w : STD_LOGIC;
    SIGNAL we_w : STD_LOGIC;
    SIGNAL CLK_w : STD_LOGIC;
BEGIN
    c0 : CLK_w <= CLK;
    c1 : Control_Unit PORT MAP(
        rst_count => rst,
        CLK => CLK_w,
        rom_address => rom_address_w,
        ram_address => ram_address_w,
        mac_init => mac_init_w1,
        cu_valid_out => valid_out_w1);
    c2 : mlab_rom PORT MAP(
        CLK => CLK_w,
        en => en_w,
        addr => rom_address_w,
        rom_out => rom_out_w);
    c3 : mlab_ram PORT MAP(
        CLK => CLK_w,
        we => we_w,
        en => en_w,
        addr => ram_address_w,
        di => x_w,
        do => ram_out_w);
    c4 : DFF PORT MAP(
        data_in => mac_init_w1,
        CLK => CLK_w,
        rst => '0',
        data_out => mac_init_w2);
    c5 : MAC_Accumulator PORT MAP(
        ROM_in => rom_out_w,
        RAM_in => ram_out_w,
        reset => rst,
        CLK => CLK_w,
        mac_init => mac_init_w3,
        L_out => mac_out_w);
    c6 : DFF PORT MAP(
        data_in => valid_out_w1,
        CLK => CLK_w,
        rst => rst,
        data_out => valid_out_w2);
    c7 : DFF PORT MAP (
        data_in => mac_init_w2,
        CLK => CLK_w,
        rst => '0',
        data_out => mac_init_w3);
    
    --Assig
    y <= mac_out_w;
    x_w <= x_in;
    we_w <= '1';
    valid_out <= valid_out_w2;
    en_w <= '1';

END Structural;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dec_3to8_behavioral_tb is

  end entity;

  ARCHITECTURE bench OF dec_3to8_behavioral_tb IS
    COMPONENT dec_3to8_behavioral IS
        PORT (
            dec_enc    : in  std_logic_vector(2 downto 0);
            dec_out    : out std_logic_vector(7 downto 0)
        );
    END COMPONENT;

    signal dec_enc : std_logic_vector(2 downto 0) := (others => '0');
    signal dec_out : std_logic_vector(7 downto 0);

    constant TIME_DELAY : time := 5 ns;

    begin

        uut : dec_3to8_behavioral
        port map (
              dec_enc  => dec_enc,
              dec_out => dec_out
              );

  stimulus : process
  begin
    dec_enc <= (others => '0');
    wait for TIME_DELAY;
    dec_enc <= "001";
    wait for TIME_DELAY;
    dec_enc <= "010";
    wait for TIME_DELAY;
    dec_enc <= "111";
    wait for TIME_DELAY;
    end process;

end architecture;




library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dec_3to8_behavioral is
    port(
         dec_enc    : in  std_logic_vector(2 downto 0);
         dec_out    : out std_logic_vector(7 downto 0)
        );
  end entity; 

  architecture behavioral_arch of dec_3to8_behavioral is

    begin
    
      MUX_LOGIC : process(dec_enc)
      begin
        case dec_enc is
          when "000" =>
            dec_out <= "00000001";
          when "001" =>
            dec_out <= "00000010";
          when "010" =>
            dec_out <= "00000100";
          when "011" =>
            dec_out <= "00001000";
          when "100" =>
            dec_out <= "00010000";
          when "101" =>
            dec_out <= "00100000";
          when "110" =>
            dec_out <= "01000000";
          when "111" =>
            dec_out <= "10000000";
          when others =>
            dec_out <= (others => '-');
        end case;
      end process;
    
    end architecture ; 
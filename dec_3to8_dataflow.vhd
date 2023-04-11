library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dec_3to8_dataflow is
  port(
       dec_enc    : in  std_logic_vector(2 downto 0);
       dec_out    : out std_logic_vector(7 downto 0)
      );
end entity; 

architecture dataflow_arch of dec_3to8_dataflow is

begin

  with dec_enc select dec_out <=
    "00000001" when "000",
    "00000010" when "001",
    "00000100" when "010",
    "00001000" when "011",
    "00010000" when "100",
    "00100000" when "101",
    "01000000" when "110",
    "10000000" when "111",
    "----" when others;

end architecture ; 
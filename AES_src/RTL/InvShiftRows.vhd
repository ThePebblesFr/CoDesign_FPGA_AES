library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library lib_rtl;
use lib_rtl.state_definition_package.all;

entity InvShiftRows is
  port(data_i : in  type_state;
       data_o : out type_state);
end entity InvShiftRows;

architecture InvShiftRows_arch of InvShiftRows is
begin
  Pr : for i in 0 to 3 generate
    Pc : for j in 0 to 3 generate
      data_o(i)(j) <= data_i(i)((j+4-i) mod 4);
    end generate;
  end generate;
end architecture InvShiftRows_arch;



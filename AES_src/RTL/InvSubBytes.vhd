library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library lib_rtl;
use lib_rtl.state_definition_package.all;

entity InvSubBytes is
  port(data_i : in  type_state;
       data_o : out type_state);
end entity InvSubBytes;

architecture InvSubBytes_arch of InvSubBytes is
  component InvSBOX
    port(InvSBOX_in  : in  bit8;
         InvSBOX_out : out bit8);
  end component;
begin
  Pc : for i in 0 to 3 generate
    Pr : for j in 0 to 3 generate
      U0 : InvSBOX
        port map(
          InvSBOX_in  => data_i(i)(j),
          InvSBOX_out => data_o(i)(j));
    end generate;
  end generate;
end architecture InvSubBytes_arch;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library lib_rtl;
use lib_rtl.state_definition_package.all;

entity matrixMultiplier is
port(   data_i : in column_state;
        data_o : out column_state);
end matrixMultiplier;

architecture matrixMultiplier_arch of matrixMultiplier is
signal data2_s : column_state;
signal data4_s : column_state;
signal data8_s : column_state;
signal data9_s : column_state;
signal datab_s : column_state;
signal datad_s : column_state;
signal datae_s : column_state;
begin
	F0 : for i in 0 to 3 generate
		data2_s(i) <= (data_i(i)(6 downto 0) & '0') xor "00011011" when data_i(i)(7) = '1'  else data_i(i)(6 downto 0) & '0';
		data4_s(i) <= (data2_s(i)(6 downto 0) & '0') xor "00011011" when data2_s(i)(7) = '1'  else data2_s(i)(6 downto 0) & '0';
		data8_s(i) <= (data4_s(i)(6 downto 0) & '0') xor "00011011" when data4_s(i)(7) = '1'  else data4_s(i)(6 downto 0) & '0';	
	end generate;

	F1: for i in 0 to 3 generate
		data9_s(i) <= data8_s(i) xor data_i(i);
		datab_s(i) <= (data8_s(i) xor data2_s(i)) xor data_i(i);
		datad_s(i) <= (data8_s(i) xor data4_s(i)) xor data_i(i);
		datae_s(i) <= (data8_s(i) xor data4_s(i)) xor data2_s(i);
	end generate;

	data_o(0) <= datae_s(0) xor datab_s(1) xor datad_s(2) xor data9_s(3);
	data_o(1) <= data9_s(0) xor datae_s(1) xor datab_s(2) xor datad_s(3);
	data_o(2) <= datad_s(0) xor data9_s(1) xor datae_s(2) xor datab_s(3);
	data_o(3) <= datab_s(0) xor datad_s(1) xor data9_s(2) xor datae_s(3);
end architecture matrixMultiplier_arch;


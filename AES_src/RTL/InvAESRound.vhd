library IEEE;
use IEEE.std_logic_1164.all;
library lib_rtl;
use lib_rtl.state_definition_package.all;

entity InvAESRound is
  port(currenttext_i          : in  bit128;
       currentkey_i           : in  bit128;
       data_o                 : out bit128;
       clock_i                : in  std_logic;
       resetb_i               : in  std_logic;
       enableInvMixcolumns_i  : in  std_logic;
       enableRoundcomputing_i : in  std_logic);
end entity InvAESRound;

architecture InvAESRound_arch of InvAESRound is
  component AddRoundKey
    port(data_i : in  type_state;
         key_i  : in  type_state;
         data_o : out type_state);
  end component;
  component InvMixColumns
    port(data_i             : in  type_state;
         enableMixColumns_i : in  std_logic;
         data_o             : out type_state);
  end component;
  component InvShiftRows
    port(data_i : in  type_state;
         data_o : out type_state);
  end component;
  component InvSubBytes
    port(data_i : in  type_state;
         data_o : out type_state);
  end component;
  signal currenttextState_s    : type_state;
  signal currentStateKey_s     : type_state;
  signal outputInvShiftRows_s  : type_state;
  signal outputInvSubBytes_s   : type_state;
  signal inputAddRoundkey_s    : type_state;
  signal outputAddRoundKey_s   : type_state;
  signal outputInvMixColumns_s : type_state;
  signal data_s                : type_state;
  signal data_os               : type_state;
begin
  -- convert current key to type state
  F0 : for i in 0 to 3 generate
    F1 : for j in 0 to 3 generate
      currentStateKey_s(i)(j) <= currentKey_i(127-32*j-8*i downto 120-32*j-8*i);
    end generate;
  end generate;

  -- convert text on 128bits to type state
  F2 : for i in 0 to 3 generate
    F3 : for j in 0 to 3 generate
      currenttextState_s(i)(j) <= currenttext_i(127-32*j-8*i downto 120-32*j-8*i);
    end generate;
  end generate;

  U0 : InvShiftRows
    port map(
      data_i => outputInvMixColumns_s,
      data_o => outputInvShiftRows_s);

  U1 : InvSubBytes
    port map(
      data_i => outputInvShiftRows_s,
      data_o => outputInvSubBytes_s);


  -- select AddRoundKey function input according to round computing (initial or next others)
  inputAddRoundKey_s <= currenttextState_s;

  U2 : AddRoundkey
    port map(
      data_i => inputAddRoundKey_s,
      key_i  => currentStateKey_s,
      data_o => outputAddRoundkey_s);

  U3 : InvMixColumns
    port map(
      data_i             => outputAddRoundKey_s,
      enableMixColumns_i => enableInvMixcolumns_i,
      data_o             => outputInvMixColumns_s);

  data_s <= outputInvSubBytes_s when enableRoundComputing_i = '1' else outputAddRoundkey_s;

  -- store InvMixColumns function output
  P0 : process(outputInvMixColumns_s, clock_i, resetb_i)
  begin
    if resetb_i = '0' then
      F4 : for i in 0 to 3 loop
        F5 : for j in 0 to 3 loop
          data_os(i)(j) <= (others => '0');
        end loop;
      end loop;
    elsif (rising_edge(clock_i)) then
      data_os <= data_s;
    end if;
  end process P0;

  -- convert type state in 128bits vector
  F6 : for i in 0 to 3 generate
    F7 : for j in 0 to 3 generate
      data_o(127-32*j-8*i downto 120-32*j-8*i) <= data_os(i)(j);
    end generate;
  end generate;

end architecture InvAESRound_arch;

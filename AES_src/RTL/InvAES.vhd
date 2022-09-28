library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library lib_rtl;
use lib_rtl.state_definition_package.all;

entity InvAES is
  port(clock_i  : in  std_logic;
       reset_i  : in  std_logic;
       start_i  : in  std_logic;
       data_i   : in  bit128;
       data_o   : out bit128;
       aes_on_o : out std_logic;
       end_aes_o : out std_logic);
end entity InvAES;

architecture InvAES_arch of InvAES is
  component KeyExpansion_table
    port (round_i         : in  bit4;
          expansion_key_o : out bit128);
  end component;
  component FSM_InvAES
    port (resetb_i               : in  std_logic;
          clock_i                : in  std_logic;
          start_i                : in  std_logic;
          round_i                : in  bit4;
          getciphertext_o        : out std_logic;
          resetCounter_o         : out std_logic;
          enableCounter_o        : out std_logic;
          enableMixcolumns_o     : out std_logic;
          enableRoundcomputing_o : out std_logic;
          enableOutput_o         : out std_logic;
          done_o                 : out std_logic;
          end_o                  : out std_logic);
  end component;
  component InvAESRound
    port(currenttext_i          : in  bit128;
         currentkey_i           : in  bit128;
         data_o                 : out bit128;
         clock_i                : in  std_logic;
         resetb_i               : in  std_logic;
         enableInvMixcolumns_i  : in  std_logic;
         enableRoundcomputing_i : in  std_logic);
  end component;
  component Counter
    port(resetb_i : in  std_logic;
         enable_i : in  std_logic;
         clock_i  : in  std_logic;
         count_o  : out bit4);
  end component;
  signal resetb_s               : std_logic;
  signal outputCounter_s        : bit4;
  signal data_s                 : bit128;
  signal data_out_s                 : bit128;
  signal currenttext_s          : bit128;
  signal outputKeyExpander_s    : bit128;
  signal enableMixcolumns_s     : std_logic;
  signal enableRoundcomputing_s : std_logic;
  signal enableOutput_s         : std_logic;
  signal resetCounter_s         : std_logic;
  signal enableCounter_s        : std_logic;
  signal getciphertext_s        : std_logic;
begin
  -- positive reset
  resetb_s <= not reset_i;

  -- key expander component
  U0 : KeyExpansion_table
    port map(
      round_i         => outputCounter_s,
      expansion_key_o => outputKeyExpander_s);

  U1 : FSM_InvAES
    port map(
      resetb_i               => resetb_s,
      clock_i                => clock_i,
      start_i                => start_i,
      round_i                => outputCounter_s,
      getciphertext_o        => getciphertext_s,
      resetCounter_o         => resetCounter_s,
      enableCounter_o        => enableCounter_s,
      enableMixcolumns_o     => enableMixColumns_s,
      enableRoundComputing_o => enableRoundComputing_s,
      enableOutput_o         => enableOutput_s,
      done_o                 => aes_on_o,
      end_o                  => end_aes_o);

  U2 : InvAESRound
    port map(
      currenttext_i          => currenttext_s,
      currentkey_i           => outputKeyExpander_s,
      data_o                 => data_s,
      clock_i                => clock_i,
      resetb_i               => resetb_s,
      enableInvMixcolumns_i  => enableMixColumns_s,
      enableRoundcomputing_i => enableRoundComputing_s);

  U3 : Counter
    port map(
      resetb_i => resetCounter_s,
      enable_i => enableCounter_s,
      clock_i  => clock_i,
      count_o  => outputCounter_s
      );

  P0 : process(data_s, enableOutput_s, clock_i, resetb_s)
  begin
    if resetb_s = '0' then 
    data_out_s <= (others=> '0') ;
    elsif (clock_i'event and clock_i = '1') then
    if enableOutput_s = '1' then
      data_out_s <= data_s;
      else 
      data_out_s <= data_out_s;
      end if;
    end if;
  end process P0;
  
data_o <= data_out_s;

  currenttext_s <= data_i when getciphertext_s = '1' else data_s;
end architecture InvAES_arch;

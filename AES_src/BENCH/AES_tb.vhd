library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library lib_rtl;
use lib_rtl.state_definition_package.all;
-- library source;
-- use source.all;

entity AES_tb is
end entity AES_tb;

architecture AES_tb_arch of AES_tb is
  component InvAES
    port(clock_i  : in  std_logic;
         reset_i  : in  std_logic;
         start_i  : in  std_logic;
         data_i   : in  bit128;
         data_o   : out bit128;
         aes_on_o : out std_logic);
  end component;
  signal data_is  : bit128;
  signal data_os  : bit128;
  signal done_os  : std_logic;
  signal reset_is : std_logic;
  signal clock_is : std_logic;
  signal start_is : std_logic;
begin
  DUT : InvAES
    port map(
      clock_i  => clock_is,
      reset_i  => reset_is,
      start_i  => start_is,
      data_i   => data_is,
      data_o   => data_os,
      aes_on_o => done_os);

  P0 : process
  begin
    data_is <= X"8c11354406ad4488decaec83aa034306";
    wait;
  end process P0;

  P1 : process
  begin
    reset_is <= '1';
    wait for 10 ns;
    reset_is <= '0';
    wait;
  end process P1;

  P2 : process
  begin
    start_is <= '0';
    wait for 100 ns;
    -- déchiffrement du premier message
    start_is <= '1';
    wait for 120 ns;
    start_is <= '0';
    wait for 1200 ns;
   wait;
  end process P2;

  Pclk : process
  begin
    clock_is <= '0';
    wait for 50 ns;
    clock_is <= '1';
    wait for 50 ns;
  end process Pclk;

end architecture AES_tb_arch;



library IEEE;
use IEEE.STD_LOGIC_1164.all;

library lib_rtl;
use lib_rtl.state_definition_package.all;

entity FSM_InvAES is
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
end FSM_InvAES;

architecture FSM_InvAES_arch of FSM_InvAES is
  type state_type is (reset, hold, round0, roundn, roundA, done);
  signal present_state, next_state : state_type;
begin

  sequentiel : process(clock_i, resetb_i)
  begin
    if resetb_i = '0' then
      present_state <= reset;
    elsif rising_edge(clock_i) then
      present_state <= next_state;
    end if;
  end process;

  C0 : process(present_state, start_i, round_i)
  begin
    case present_state is
      when reset =>
        next_state <= hold;
      when hold =>
        if start_i = '1' then
          next_state <= roundA;
        else
          next_state <= hold;
        end if;
      when roundA =>
        next_state <= roundn;
      when roundn =>
        if round_i = x"1" then
          next_state <= round0;
        else
          next_state <= roundn;
        end if;
      when round0 =>
        next_state <= done;
      when done =>
        if (start_i = '0') then
          next_state <= hold;
        else
          next_state <= done;
        end if;
    end case;
  end process C0;

  C1 : process(present_state, round_i)
  begin
    case present_state is
      when reset =>
        getciphertext_o        <= '1';
        resetCounter_o         <= '0';
        enableCounter_o        <= '0';
        enableMixcolumns_o     <= '0';
        enableRoundcomputing_o <= '1';
        enableOutput_o         <= '0';
        done_o                 <= '0';
        end_o                  <= '0';

      when hold =>
        getciphertext_o        <= '1';
        resetCounter_o         <= '0';
        enableCounter_o        <= '0';
        enableMixcolumns_o     <= '0';
        enableRoundcomputing_o <= '1';
        enableOutput_o         <= '0';
        done_o                 <= '0';
        end_o                  <= '0';

      when roundA =>
        getciphertext_o        <= '1';
        resetCounter_o         <= '1';
        enableCounter_o        <= '1';
        enableMixcolumns_o     <= '0';
        enableRoundcomputing_o <= '1';
        enableOutput_o         <= '0';
        done_o                 <= '1';
        end_o                  <= '0';

      when roundn =>
        getciphertext_o        <= '0';
        resetCounter_o         <= '1';
        enableCounter_o        <= '1';
        enableMixcolumns_o     <= '1';
        enableRoundcomputing_o <= '1';
        enableOutput_o         <= '0';
        done_o                 <= '1';
        end_o                  <= '0';

      when round0 =>
        getciphertext_o        <= '0';
        resetCounter_o         <= '1';
        enableCounter_o        <= '0';
        enableMixcolumns_o     <= '0';
        enableRoundcomputing_o <= '0';
        enableOutput_o         <= '0';
        done_o                 <= '1';
        end_o                  <= '0';

      when done =>
        getciphertext_o        <= '0';
        resetCounter_o         <= '1';
        enableCounter_o        <= '0';
        enableMixcolumns_o     <= '0';
        enableRoundcomputing_o <= '0';
        enableOutput_o         <= '1';
        done_o                 <= '0';
        end_o                  <= '1';

    end case;
  end process C1;

end FSM_InvAES_arch;


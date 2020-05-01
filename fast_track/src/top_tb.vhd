library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- no input or output signals for testbench
entity top_tb is
end top_tb; 

architecture sim of top_tb is

  -- declare signals in "declarity" region of architecture

  constant clk_hz : integer := 100; -- 100 Hz
  -- time is a built-in type in VHDL
  -- n.b.: time type is not synthesizable, and can only be used in simulation
  constant clk_period : time := 1 sec / clk_hz;

  -- declare the signals appearing in our design
  signal clk : std_logic := '1';
  signal rst_n : std_logic := '0'; -- reset ACTIVE LOW, so we start off in reset
  signal segments : std_logic_vector(6 downto 0);
  signal digit_sel : std_logic;

begin

  -- instantiate our "top" design, DUT (design under test)
  DUT : entity work.top(rtl)
  generic map (
    clk_hz => clk_hz,
    alt_counter_len => 16
  )
  port map (
    -- map signals from entity to local signals in testbench
    clk => clk,
    rst_n => rst_n,
    segments => segments,
    digit_sel => digit_sel
  );

  --
  -- define a process named CLOCK_PROC
  -- notes:
  --   - remove sensitivity list since this is a testbench that drives the underlying design
  --   - a process without a sensitivity list simply is an infinite loop
  CLOCK_PROC : process
  begin

    wait for clk_period / 2;
    clk <= not clk;
    
  end process;
  --
  --

  --
  -- define process RESET_PROC
  --
  RESET_PROC : process
  begin

    for count in 1 to 10 loop
      wait until clk = '1';
    end loop;

    rst_n <= '1'; -- move out of RESET by setting active-low reset to HIGH
    wait; -- wait indefinitely, to prevent this process from waking up again
  end process;
  --
  --

end architecture;
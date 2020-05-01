-- https://vhdlwhiz.com/wait-on-wait-until/

entity T07_WaitOnUntilTb is
end entity;

architecture sim of T07_WaitOnUntilTb is
  signal CountUp : integer := 0;
  signal CountDown : integer := 10;
begin

  --
  -- Process to increment/decrement CountUp/CountDown over time
  --
  process is
  begin
      CountUp <= CountUp + 1;
      CountDown <= CountDown - 1;
      wait for 10 ns;
  end process;

  --
  -- Process to wake up when CountUp or CountDown change
  --
  process is
  begin

    -- wake up when either CountUp or CountDown are changed
    wait on CountUp, CountDown;
    report "CountUp=" & integer'image(CountUp) & " CountDown=" & integer'image(CountDown);
  end process;

  --
  -- Process with "wait_until"
  --
  process is
  begin

    -- this process wakes up every time either of the CountUp or CountDown signals change, but will
    --   only continue if the expression evaluates to true, otherwise it will go back to sleep.
    wait until CountUp = CountDown;
    report "JackPot!";
  end process;


end architecture;
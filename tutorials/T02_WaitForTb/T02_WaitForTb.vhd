-- https://vhdlwhiz.com/wait-for/

entity T02_WaitForTb is
end entity;

architecture sim of T02_WaitForTb is
begin

  process is
  begin
    -- this is the start of the process thread

    report "Hello World!";
    -- In VHDL (sim), only "wait" statements consume time.
    -- Without this wait statement, the loop simply returns back and nothing ever happens
    -- (the simulation never advances its timestep).
    wait for 10 ns; -- wait for 10 ns and restart the process once more

    -- the process will loop back to the start from here
  end process;
end architecture;
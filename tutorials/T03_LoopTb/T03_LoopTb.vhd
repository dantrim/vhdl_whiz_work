-- https://vhdlwhiz.com/loop-and-exit/

entity T03_LoopTb is
end entity;

architecture sim of T03_LoopTb is
begin

  process is
  begin
    report "Hello!";

    -- start another loop within the process loop/"thread"
    loop
      wait for 10 ns;
      report "Peekaboo!";
      exit;
    end loop;

    report "Goodbye!";

    -- indefinite wait, prevents process from re-starting
    wait;
  end process;

end architecture;
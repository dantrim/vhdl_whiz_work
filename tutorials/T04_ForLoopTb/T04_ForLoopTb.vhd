-- https://vhdlwhiz.com/for-loop/

entity T04_ForLoopTb is
end entity;

architecture sim of T04_ForLoopTb is
begin

  -- Initiate a process "thread"
  process is
  begin

    for i in 1 to 10 loop
      -- print out the current count index ever 1 ns
      wait for 1 ns;
      report "i=" & integer'image(i); -- An integer can be converted to a string by using integer'image()
    end loop;

    -- indefinite wait to halt this process
    wait;

  end process;

end architecture;
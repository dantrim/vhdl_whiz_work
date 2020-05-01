-- https://vhdlwhiz.com/while-loop/

entity T05_WhileLoopTb is
end entity;

architecture sim of T05_WhileLoopTb is
begin

  -- Initialize a process "thread" with variables local only to it's "scope"
  process is
    -- Variables in VHDL are defined at the "head" of the process, between
    -- the process instantiation and the "begin".
    variable i : integer := 0;
  begin

    while i < 10 loop
      report "i=" & integer'image(i);
      -- variable assignment in VHDL is done using the ":=" operator
      i := i + 2;
    end loop;
    wait; -- indefinite wait halts the process

  end process;
  

end architecture;
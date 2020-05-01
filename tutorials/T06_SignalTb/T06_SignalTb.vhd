-- https://vhdlwhiz.com/signals-vs-variables/

-- Notes:
-- Scope of a variable is only within that process in which it was declared.
-- Signals can only be declared in a certain place within the VHDL file:
--    between the "architecture is" and "begin" tags
-- Variables are updated immediately within the simulation.
-- Signals are only updated after "wait" statements or after simulation advances timestep.

entity T06_SignalTb is
end entity;

architecture sim of T06_SignalTb is
  -- this signal is available everywhere and to every process within this architecture
  signal MySignal : integer := 0;
begin

  process is
    variable MyVariable : integer := 0;
  begin

    report "*** Process Begins ***";

    MyVariable := MyVariable + 1; -- variable assignment is ":="
    MySignal <= MySignal + 1; -- signal assignment is "<="
    wait for 10 ns;

    report "MyVariable=" & integer'image(MyVariable) &
        ", MySignal=" & integer'image(MySignal);

    --MyVariable := MyVariable + 1; -- variable assignment is ":="
    --MySignal <= MySignal + 1; -- signal assignment is "<="


    --report "MyVariable=" & integer'image(MyVariable) &
    --    ", MySignal=" & integer'image(MySignal);

  end process;

end architecture;

-- https://vhdlwhiz.com/hello-world/

entity T01_HelloWorldTb is
end entity;
   
architecture sim of T01_HelloWorldTb is
--             ^ name of archtecture
--                        ^ entity under which this architecture sits
begin

  -- Inside of the architecture we can define our processes.
  -- Processes can be thought of as a "programming thread".
  -- Inside of our architecture, each process is run concurrently.
  process is
  begin
    report "Hello World!";
    wait; -- an indefinite wait
  end process;
 
end architecture;
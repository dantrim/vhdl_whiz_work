library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
  -- generics are constants, available throughout the entity implementation
  generic (
    -- define clk_hz with a default value of 12 MHz
    clk_hz : integer := 12e6;
    alt_counter_len : integer := 16
  );
  -- ports are signals and are used during runtime
  port (
    clk       : in std_logic;
    rst_n     : in std_logic;
    segments  : out std_logic_vector(6 downto 0);
    digit_sel : out std_logic
  );
end top;

architecture rtl of top is 

  -- internal reset
  signal rst : std_logic;

  -- shift register for generating the internal reset
  signal shift_reg : std_logic_vector(7 downto 0) ;

  -- Binary coded decimal
  subtype digit_type is integer range 0 to 9;
  signal digit : digit_type;
  type digits_type is array (0 to 1) of digit_type; -- array with two elements of type digit_type
  signal digits : digits_type;

  -- constants and signals for timing 7-segment counting
  constant tick_counter_max : integer := clk_hz / 10 - 1;
  signal tick_counter : integer range 0 to tick_counter_max;
  signal tick : std_logic;

  -- unsigned types are like logic_vectors but we can do arithmetical operations on them

  -- counter for alternating between ones and tens on the display
  -- 12e6 MHz / (2 ** 16) = 183 Hz refresh rate
  --   ^ clock frequency
  --                ^ number of bits in alt_counter
  signal alt_counter : unsigned(alt_counter_len - 1 downto 0);

  -- finite state machine
  type bcd_state_type is (COUNT_ONES, COUNT_TENS);
  signal bcd_state : bcd_state_type;

  -- functions and procedures
  --function incr_wrap(d : digit_type) return digit_type is
  --  -- declarative region of function
  --begin
  --  if d = 9 then
  --    return 0;
  --  else
  --    return d + 1;
  --  end if;
  --end function;

  -- main difference between procedure and a function, function has a return value
  -- but procedures can return values through the parameter list (function can only return one value through the return statement)
  -- function cannot have wait statements, whereas a procedure can
  procedure incr_wrap(signal d : inout digit_type) is
  begin
    if d = 9 then
      d <= 0;
    else
      d <= d + 1;
    end if;
  end procedure;

-- architecture implementation
begin

  --
  -- "bcd" : binary coded decimal
  --
  BCD_FSM_PROC : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        digits <= (others => 0);
        bcd_state <= COUNT_ONES;
      else
        if tick = '1' then
          incr_wrap(digits(0));
        end if;

        case bcd_state is
        
          when COUNT_ONES =>
            if digits(0) = 9 then
              bcd_state <= COUNT_TENS;
            end if;
          when COUNT_TENS =>
            if tick = '1' then
              incr_wrap(digits(1));
              bcd_state <= COUNT_ONES;
            end if;
        end case;
      end if;
    end if;
  end process;
  --
  --
  --

  ALTERNATE_COUNTER_PROC : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        alt_counter <= (others => '0');
      else
        alt_counter <= alt_counter + 1; -- we do not need to handle wrap, because unsigned type automatically wraps
      end if;
    end if;
  end process;

  --
  -- process to determine which digit of the SSD is illuminated
  --
  OUTPUT_MUX_PROC : process(alt_counter)
  begin
    if alt_counter(alt_counter'high) = '1' then -- "high" is a signal attribute
      digit <= digits(1);
      digit_sel <= '1';
    else
      digit <= digits(0);
      digit_sel <= '0';
    end if;
  end process;
  --
  --
  --

  --
  --
  --
  TICK_PROC : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
       tick_counter <= 0; 
       tick <= '0';
      else
        if tick_counter = tick_counter_max then
          tick_counter <= 0;
          tick <= '1';
        else
          tick_counter <= tick_counter + 1;
          tick <= '0';
        end if;
      end if;
    end if;
  end process;

  --
  -- SHIFT_REG_PROC to implment a shift register
  --
  SHIFT_REG_PROC : process(clk)
  begin
    -- The "rising_edge" function returns true if there is a 0-to-1 transition 
    -- within the timestep that we are in when we enter this process
    if rising_edge(clk) then
      -- use vector slicing, [6:0] & rst_n lops off MSB of shift_reg and concatenates rst_n at LSB
      -- this is equivalent to shifting our 8-bits in shift_reg to the left 1-bit and OR'ing with rst_n
      shift_reg <= shift_reg(6 downto 0) & rst_n;

    end if;
    
  end process;

  --
  -- RESET_PROC 
  --
  RESET_PROC : process(shift_reg)
  begin
    if shift_reg = "11111111" then
      rst <= '0';
    else
      rst <= '1';
    end if;
  end process;
  --
  --
  --

  --
  -- create a process called "ENCODER_PROC", sensitive to the "digit" signal
  --
  ENCODER_PROC : process(digit)
    -- can define constants inside of any process
    -- when we define contstants here, in the "declarity region of a process",
    -- the constants are only visible to the process scope
    constant A : integer := 0; -- when defining constants use ":="
    constant B : integer := 1;
    constant C : integer := 2;
    constant D : integer := 3;
    constant E : integer := 4;
    constant F : integer := 5;
    constant G : integer := 6;
  begin
    segments <= (others => '1'); -- others is an "aggregate assignment"

    case digit is

      when 0 =>
        segments(G) <= '0';

      when 1 =>
        segments <= "0000000";
        segments <= (others => '0');
        segments(B) <= '1';
        segments(C) <= '1';

      when 2 =>
        segments(C) <= '0';
        segments(F) <= '0';
      when 3 =>
        segments(E) <= '0';
        segments(F) <= '0';
      when 4 =>
        segments(A) <= '0';
        segments(D) <= '0';
        segments(E) <= '0';
      when 5 =>
        segments(B) <= '0';
        segments(E) <= '0';
      when 6 =>
        segments(B) <= '0';
      when 7 =>
        segments(F) <= '0';
        segments(G) <= '0';
        segments(D) <= '0';
        segments(E) <= '0';
      when 8 =>

      when 9 =>
        segments(E) <= '0';

      when others =>
        segments <= (others => '0');

    end case;
  end process;
  --
  -- ENCODER_PROC end
  --

end architecture;
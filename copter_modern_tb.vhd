library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity copter_modern is
  
end;

architecture Behavioral of copter_modern is

  component lab
    port (clk : in std_logic);
  end component;

  signal clk : std_logic;
begin

  clk <= not clk after 5 ns;
  
end Behavioral;

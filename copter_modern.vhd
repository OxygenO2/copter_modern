library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity copter_modern is
  port (clk : in std_logic);  
end copter_modern;

architecture Behavioral of copter_modern is

  component CPU
    port (
      clk :in std_logic);
    
  end component;

  component GPU
    port (
      clk : in std_logic);
    
  end component;

  --signal collision : std_logic;

begin  -- Behavioral

  CP : CPU port map (clk => clk);
                     --collision => collision);
  GP : GPU port map (clk => clk);
                     --collision => collision);
 
  process (clk)
    begin
      if rising_edge(clk) then
        
      end if;
   end process;

end Behavioral;

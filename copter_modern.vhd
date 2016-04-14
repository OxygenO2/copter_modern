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
      clk : in std_logic;
      collision : in std_logic);
    
  end component;

  component GPU
  port (  clk : in std_logic; --system clock
          cpu_x : in std_logic_vector(9 downto 0);
          cpu_y : in std_logic_vector(8 downto 0);
          sprite_x : in integer;
          sprite_y : in integer;
          cpu_data : in std_logic_vector(7 downto 0);
          collision : out std_logic);
   
  end component;

  signal collision : std_logic;
  signal cpu_x : std_logic_vector(9 downto 0);
  signal cpu_y : std_logic_vector(8 downto 0);
  signal cpu_data : std_logic_vector(7 downto 0);
  signal sprite_x : integer;
  signal sprite_y : integer;
   
  
begin  -- Behavioral

  CP : CPU port map (clk => clk,
                     collision => collision);

  GP : GPU port map (clk => clk,
                     cpu_x => cpu_x,
                     cpu_y => cpu_y,
                     sprite_x => sprite_x,
                     sprite_y => sprite_y,
                     cpu_data => cpu_data,
                     collision => collision);
 
  process (clk)
    begin
      if rising_edge(clk) then
        
      end if;
   end process;

end Behavioral;

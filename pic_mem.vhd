-- library declaration
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;            -- basic IEEE library
use IEEE.NUMERIC_STD.ALL;               -- IEEE library for the unsigned type


-- entity
entity PIC_MEM is
  port ( clk		: in std_logic;
         -- port 1
         we1		: in std_logic;
         data_in1	: in std_logic_vector(7 downto 0);
         data_out1	: out std_logic_vector(7 downto 0);
         x1             : in unsigned(9 downto 0);
         y1             : in unsigned(8 downto 0);
         -- port 2
         we2		: in std_logic;
         data_in2	: in std_logic_vector(7 downto 0);
         data_out2	: out std_logic_vector(7 downto 0);
         x2             : in unsigned(9 downto 0);
         y2             : in unsigned(8 downto 0));
end PIC_MEM;

	
-- architecture
architecture Behavioral of PIC_MEM is

  signal tile_type : std_logic;
  
  signal x_internal : unsigned(9 downto 0);
  signal y_internal : unsigned(8 downto 0);

  signal x_mod_tile_s : unsigned(9 downto 0);
  signal y_mod_tile_s : unsigned(8 downto 0);
  
  
  -- Tile_memory
  type tile_ram is array (0 to 128) of std_logic_vector(7 downto 0);
  signal tileMem : tile_ram := (others => "00000000");

  -- tile grid type (61 * 34 = 2074)
  type tile_grid is array (0 to 2074) of std_logic;
  signal obstacle_grid : tile_grid := (others => '0');

begin 

  --modulus tile_size
--  x_mod_tile_s <= x_internal mod 8;
--  y_mod_tile_s <= y_internal mod 8;

  --flip-flopp
  process(clk)
  begin  
    if rising_edge(clk) then
      x_internal <= x2;
      y_internal <= y2;
    end if;
  end process;

  --Tile_memory
-- process(clk)
--  begin
--    if rising_edge(clk) then
--      data_out2 <= tileMem((y_mod_tile_s*8) + x_mod_tile_s + (tile_type*64));
--    end if;
--  end process;

end Behavioral;

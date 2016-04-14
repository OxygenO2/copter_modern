-- library declaration
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;            -- basic IEEE library
use IEEE.std_logic_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;               -- IEEE library for the unsigned type


-- entity
entity PIC_MEM is
  port ( clk		: in std_logic;
         -- port 1
         we1		: in std_logic;
         data_in1	: in std_logic_vector(7 downto 0);
         x1             : in std_logic_vector(9 downto 0);
         y1             : in std_logic_vector(8 downto 0);
         sprite_x     : in integer;
         sprite_y     : in integer;
         -- port 2
         we2		: in std_logic;
         tile_out	: out std_logic_vector(7 downto 0);
         sprite_out     : out std_logic_vector(7 downto 0);
         x2             : in std_logic_vector(9 downto 0);
         y2             : in std_logic_vector(8 downto 0));
end PIC_MEM;

	
-- architecture
architecture Behavioral of PIC_MEM is

  signal tile_type : std_logic;
  signal tile_int : integer;
  
  signal x_internal : std_logic_vector(9 downto 0);
  signal y_internal : std_logic_vector(8 downto 0);

  signal x_mod_tile_s : integer range 0 to 7;
  signal y_mod_tile_s : integer range 0 to 7;

  signal x_mod_sprite_s : integer range 0 to 15;
  signal y_mod_sprite_s : integer range 0 to 15;
  
  -- tile_grid type (61 * 34 = 2074)
  type tile_grid is array (0 to 2074) of std_logic;
  signal obstacle_grid : tile_grid := (others => '0');

  -- Tile_memory type
  type tile_ram is array (0 to 127) of std_logic_vector(7 downto 0);
  signal tile_mem : tile_ram := (others => "00000000");

  --sprite_memory type
  type sprite_ram is array (0 to 255) of std_logic_vector(7 downto 0);
  signal sprite_mem : sprite_ram := (others => "00000000");

begin
  --set tile int
  tile_int <= 1 when tile_type = '1' else 0;

  --tile_grid memory
  process(clk)
    begin
      if rising_edge(clk) then
        if (we1 = '0') then
          --code for port 1 (CPU)
        end if;
        tile_type <= obstacle_grid((conv_integer(y2)*34/8) + ((conv_integer(x2)/8)));
--fel "måste heltalsdivideras med tile-storlek"
      end if;
    end process;
    
  --modulus tile_size
  x_mod_tile_s <= conv_integer(x_internal) mod 8;
  y_mod_tile_s <= conv_integer(y_internal) mod 8;

  --flip-flopp
  process(clk)
  begin  
    if rising_edge(clk) then
      x_internal <= x2;
      y_internal <= y2;
    end if;
  end process;

  --Tile memory
  process(clk)
  begin
    if rising_edge(clk) then
      tile_out <= tile_mem((y_mod_tile_s*8) + x_mod_tile_s + tile_int*64);
    end if;
  end process;

  --modulus sprite_size
  x_mod_sprite_s <= sprite_x mod 16;
  y_mod_sprite_s <= sprite_y mod 16;
  
  
  --sprite memory
  process(clk)
  begin
    if rising_edge(clk) then
      if (x_internal >= sprite_x) and (y_internal >= sprite_y) then
        if (x_internal < (sprite_x+16)) and (y_internal < (sprite_y+16)) then
          sprite_out <= sprite_mem((y_mod_sprite_s*16) + x_mod_sprite_s);
        else
          sprite_out <= x"00";
        end if;
      end if;
    end if;
  end PROCESS;
  
end Behavioral;

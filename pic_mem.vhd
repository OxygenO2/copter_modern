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

  -- picture memory type
  type tile_ram is array (0 to 2047) of std_logic_vector(7 downto 0);
  -- initiate picture memory to one cursor ("1F") followed by spaces ("00")
  signal tileMem : tile_ram := (0 => x"1F", others => (others => '0'));


  -- tile grid type (61 * 34 = 2074)
  type tile_grid is array (0 to 2074) of std_logic;
  signal obstacle_grid : tile_grid := (others => '0');

begin

  process(clk)
  begin
    if rising_edge(clk) then
      if (we1 = '1') then
        tileMem(287 * to_integer(y1) + to_integer(x1)) <= data_in1;
      end if;
      data_out1 <= tileMem(287 * to_integer(y1) + to_integer(x1));
      
      if (we2 = '1') then
        tileMem(287 * to_integer(y2) + to_integer(x2)) <= data_in2;
      end if;
      data_out2 <= tileMem(287 * to_integer(y2) + to_integer(x2));
    end if;
  end process;

end Behavioral;

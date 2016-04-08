
-- library declaration
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;            -- basic IEEE library
use IEEE.NUMERIC_STD.ALL;               -- IEEE library for the unsigned type
                                        -- and various arithmetic operations

-- entity
entity PIXEL_CHOOSER is
  port (clk : in std_logic;
        player_pixel : in std_logic_vector(7 downto 0);
        tile_pixel : in std_logic_vector(7 downto 0);
        background_pixel : in std_logic_vector(7 downto 0);
        out_pixel : out std_logic_vector(7 downto 0);
        collision: out std_logic);
  
end PIXEL_CHOOSER;


-- architecture
architecture Behavioral of PIXEL_CHOOSER is
begin

  process (clk)
  begin
    if rising_edge(clk) then
      if player_pixel /= x"00" then
        out_pixel <= player_pixel;
        if tile_pixel /= x"00" then
          collision <= '1';  
        else
          collision <= '0';
        end if;
      elsif tile_pixel /= x"00" then
        out_pixel <= tile_pixel;
        collision <= '0';
      else
        out_pixel <= background_pixel;
        collision <= '0';
      end if;
    end if;
  end process;
  
end Behavioral;

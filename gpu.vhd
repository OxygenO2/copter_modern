--GPU

-- library declaration
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;            -- basic IEEE library
use IEEE.NUMERIC_STD.ALL;               -- IEEE library for the unsigned type

entity GPU is
  port (  clk : in std_logic; --system clock
          collision : out std_logic);    
 
end GPU;

-- alla andra kretsar och saker
architecture Behavioral of GPU is  

--BILDMINNE
  component PIC_MEM
      port ( clk		: in std_logic;
         -- port 1
         we1		: in std_logic;
         data_in1	: in std_logic_vector(7 downto 0);
         data_out1	: out std_logic_vector(7 downto 0);
         addr1		: in unsigned(10 downto 0);
         -- port 2
         we2		: in std_logic;
         data_in2	: in std_logic_vector(7 downto 0);
         data_out2	: out std_logic_vector(7 downto 0);
         addr2		: in unsigned(10 downto 0));  
      
  end component;

  
--PIXELVÄLJARE
  component PIXEL_CHOOSER
    port ( clk : in std_logic;
           player_pixel : in std_logic_vector(7 downto 0);
           tile_pixel : in std_logic_vector(7 downto 0);
           background_pixel : in std_logic_vector(7 downto 0);
           out_pixel : out std_logic_vector(7 downto 0);
           collision: out std_logic);
      
  end component;

  signal clk_div : unsigned(4 downto 0);
  signal x_pixel : unsigned(9 downto 0);
  signal y_pixel : unsigned(8 downto 0);
  signal GPU_clk : std_logic;
  signal PIC_MEM_we : std_logic;
  signal PIC_MEM_data1 : std_logic_vector(7 downto 0);
  signal PIC_MEM_addr1 : unsigned(10 downto 0);
  signal PIC_MEM_data2 : std_logic_vector(7 downto 0);
  signal PIC_MEM_addr2 : unsigned(10 downto 0);
  signal PIXEL_CHOOSER_player_pixel : std_logic_vector(7 downto 0);
  signal PIXEL_CHOOSER_tile_pixel : std_logic_vector(7 downto 0);
  signal PIXEL_CHOOSER_background_pixel : std_logic_vector(7 downto 0);
  signal PIXEL_CHOOSER_out : std_logic_vector(7 downto 0);
  signal out_pixel : std_logic_vector(7 downto 0);
  signal blank : std_logic;
   
begin  -- Behavioral
  
-- PIC_MEM component connection
  PM : PIC_MEM port map(clk=>clk,
                        we1=>PIC_MEM_we,
                        data_in1=>PIC_MEM_data1,
                        addr1=>PIC_MEM_addr1,
                        we2=>'0',
                        data_in2=>"00000000",
                        data_out2=>PIC_MEM_data2,
                        addr2=>PIC_MEM_addr2);
	
  -- PIXEL_CHOOSER component connection
  PC : PIXEL_CHOOSER port map(clk => clk,
                              player_pixel => PIXEL_CHOOSER_player_pixel,
                              tile_pixel => PIXEL_CHOOSER_tile_pixel,
                              background_pixel => PIXEL_CHOOSER_background_pixel,
                              out_pixel => PIXEL_CHOOSER_out,
                              collision => collision);
  
  --clk_divider
  process (clk)
  begin
    if rising_edge(clk) then
      if (clk_div = 10) then
        clk_div <= (others => '0'); 
      else
        clk_div <= clk_div + 1;
      end if;
    end if;
  end process;
  
  GPU_clk <= '1' when (clk_div = 10) else '0';
  
  --x_pixel_counter
  process (clk)
  begin
    if rising_edge(clk) then
      if GPU_clk = '1' then
        if (x_pixel = 524) then
          x_pixel <= (others => '0');
        else
          x_pixel <= x_pixel + 1;
        end if;
      end if;
    end if;
  end process;
  
  
  --y_pixel_counter
  process (clk)
  begin
    if rising_edge(clk) then
      if GPU_clk = '1' and (x_pixel = 524) then
        if (y_pixel = 287) then
          y_pixel <= (others => '0');
        else
          y_pixel <= y_pixel +1;
        end if;
      end if;
    end if;
  end process; 

  blank <= '1' when x_pixel > 480 or y_pixel > 272 else '0';

  out_pixel <= PIXEL_CHOOSER_out when blank = '0' else "0";

end Behavioral;

--GPU

-- library declaration
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;            -- basic IEEE library
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.ALL;               -- IEEE library for the unsigned type

entity GPU is
  port (  clk : in std_logic; --system clock
          cpu_x : in std_logic_vector(9 downto 0);
          cpu_y : in std_logic_vector(8 downto 0);
          cpu_data : in std_logic_vector(7 downto 0);
          collision : out std_logic);
 
end GPU;

-- alla andra kretsar och saker
architecture Behavioral of GPU is  

  component PIC_MEM
      port ( clk		: in std_logic;
         -- port 1
         we1		: in std_logic;
         data_in1	: in std_logic_vector(7 downto 0);
         x1	        : in std_logic_vector(9 downto 0);
         y1		: in std_logic_vector(8 downto 0);
         -- port 2
         we2		: in std_logic;
         data_out2	: out std_logic_vector(7 downto 0);
         x2     	: in std_logic_vector(9 downto 0);
         y2		: in std_logic_vector(8 downto 0));  
      
  end component;

  component PIXEL_CHOOSER
    port ( clk : in std_logic;
           player_pixel : in std_logic_vector(7 downto 0);
           tile_pixel : in std_logic_vector(7 downto 0);
           background_pixel : in std_logic_vector(7 downto 0);
           out_pixel : out std_logic_vector(7 downto 0);
           collision: out std_logic);
    
  end component;

  component LCD_MOTOR
   Port (
         clk : in STD_LOGIC;
         --CLK_180_I : in STD_LOGIC;
         rst : in STD_LOGIC;
         x: in integer;
         y: in integer;
         z: in STD_LOGIC_VECTOR (11 downto 0);
         we : in std_logic;
         wr_clk : in std_logic;
         r : out  STD_LOGIC_VECTOR (7 downto 0);
         g : out  STD_LOGIC_VECTOR (7 downto 0);
         b : out  STD_LOGIC_VECTOR (7 downto 0);
         de : out  STD_LOGIC;
         clk_0 : out  STD_LOGIC;
         disp : out  STD_LOGIC;
         bklt : out  STD_LOGIC; --PWM backlight control
         vdden_0 : out STD_LOGIC;
         MSEL_I : in STD_LOGIC_VECTOR(3 downto 0)); -- Mode selection
  
  end component;

  signal clk_div : unsigned(4 downto 0);
  signal x_pixel : std_logic_vector(9 downto 0);
  signal y_pixel : std_logic_vector(8 downto 0);
  signal GPU_clk : std_logic;
  signal PIC_MEM_we : std_logic;
  signal PIC_MEM_data2 : std_logic_vector(7 downto 0);
  signal PIXEL_CHOOSER_player_pixel : std_logic_vector(7 downto 0);
  signal PIXEL_CHOOSER_tile_pixel : std_logic_vector(7 downto 0);
  signal PIXEL_CHOOSER_background_pixel : std_logic_vector(7 downto 0);
  signal PIXEL_CHOOSER_out : std_logic_vector(7 downto 0);
  signal blank : std_logic;
  signal out_pixel : std_logic_vector(7 downto 0);


  signal LCD_rst : std_logic;
  signal LCD_x: integer;
  signal LCD_y: integer;
  signal LCD_z: STD_LOGIC_VECTOR (11 downto 0);
  signal LCD_we : std_logic;
  signal LCD_wr_clk : std_logic;
  
  signal LCD_r : STD_LOGIC_VECTOR (7 downto 0);
  signal LCD_g : STD_LOGIC_VECTOR (7 downto 0);
  signal LCD_b : STD_LOGIC_VECTOR (7 downto 0);
  signal LCD_de : STD_LOGIC;
  signal LCD_clk_0 : STD_LOGIC;
  signal LCD_disp : STD_LOGIC;
  signal LCD_bklt : STD_LOGIC; --PWM backlight control
  signal LCD_vdden_0 : STD_LOGIC;

  signal LCD_msel : STD_LOGIC_VECTOR(3 downto 0); -- Mode selection

  
begin  -- Behavioral
  
-- PIC_MEM component connection
  PM : PIC_MEM port map(clk=>clk,
                        we1=>PIC_MEM_we,
                        data_in1=>cpu_data,
                        x1=>cpu_x,
                        y1=>cpu_y,
                        we2=>'0',
                        data_out2=>PIC_MEM_data2,
                        x2=>x_pixel,
                        y2=>y_pixel);
	
  -- PIXEL_CHOOSER component connection
  PC : PIXEL_CHOOSER port map(clk => clk,
                              player_pixel => PIXEL_CHOOSER_player_pixel,
                              tile_pixel => PIXEL_CHOOSER_tile_pixel,
                              background_pixel => PIXEL_CHOOSER_background_pixel,
                              out_pixel => PIXEL_CHOOSER_out,
                              collision => collision);

  LCD : LCD_MOTOR port map (clk => clk,
                            rst => LCD_rst,
                            x => LCD_x,
                            y => LCD_y,
                            z => LCD_z,
                            we => LCD_we,
                            wr_clk => LCD_wr_clk,
                            r => LCD_r,
                            g => LCD_g,
                            b => LCD_b,
                            de => LCD_de,
                            clk_0 => LCD_clk_0,
                            disp => LCD_disp,
                            bklt => LCD_bklt,
                            vdden_0 => LCD_vdden_0,
                            MSEL_I => LCD_msel);

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

  out_pixel <= PIXEL_CHOOSER_out when blank = '0' else (others => '0');

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.NUMERIC_STD.ALL;               -- IEEE library for the unsigned type

entity copter_modern is
  port(clk : in std_logic;
       TFT_CLK_O : out std_logic;      
       TFT_DISP_O : out std_logic;
       TFT_EN_O : out std_logic;
       TFT_BKLT_O : out std_logic;
       TFT_DE_O : out std_logic;
       TFT_R_O : out  STD_LOGIC_VECTOR (7 downto 0);
       TFT_G_O : out  STD_LOGIC_VECTOR (7 downto 0);
       TFT_B_O : out  STD_LOGIC_VECTOR (7 downto 0);

       TP_BUSY_O : out std_logic;
       TP_DIN_O : out std_logic;
       TP_CS_O : out std_logic;
       TP_DCLK_O : out std_logic;
       TP_DOUT_O : out std_logic;
       TP_PENIRQ_O : out std_logic;

       LED_EN_O : out std_logic;
       NC_O : out std_logic;              -- Den här gör ingenting
       
       --7-seg
       seg0 : out std_logic;
       seg1 : out std_logic;
       seg2 : out std_logic;
       seg3 : out std_logic;
       seg4 : out std_logic;
       seg5 : out std_logic;
       seg6 : out std_logic;

       --led
       led0 : out std_logic;       
       led1 : out std_logic;
       led2 : out std_logic;
       led3 : out std_logic;
       led4 : out std_logic;
       led5 : out std_logic;
       led6 : out std_logic;
       led7 : out std_logic
       );    
  
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
          r : out  STD_LOGIC_VECTOR (7 downto 0);
          g : out  STD_LOGIC_VECTOR (7 downto 0);
          b : out  STD_LOGIC_VECTOR (7 downto 0);
          de : out  STD_LOGIC;
          clk_O : out  STD_LOGIC;
          disp : out  STD_LOGIC;
          bklt : out  STD_LOGIC;
          en_O : out STD_LOGIC;
          collision : out std_logic);
   
  end component;

  signal collision : std_logic;
  signal cpu_x : std_logic_vector(9 downto 0);
  signal cpu_y : std_logic_vector(8 downto 0);
  signal cpu_data : std_logic_vector(7 downto 0);

  signal sprite_x : integer;
  signal sprite_y : integer;

  signal en_debug : std_logic;
  signal disp_debug : std_logic;
  signal bklt_debug : std_logic;
  
begin  -- Behavioral

  CP : CPU port map (clk => clk,
                     collision => collision);

  GP : GPU port map (clk => clk,
                     cpu_x => cpu_x,
                     cpu_y => cpu_y,
                     sprite_x => sprite_x,
                     sprite_y => sprite_y,
                     cpu_data => cpu_data,
                     r => TFT_R_O,
                     g => TFT_G_O,
                     b => TFT_B_O,
                     de => TFT_DE_O,
                     clk_O => TFT_CLK_O,
                     disp => disp_debug,
                     bklt => bklt_debug,
                     en_O => en_debug,
                     collision => collision);
 
  process (clk)
    begin
      if rising_edge(clk) then
        
      end if;
   end process;

      TP_BUSY_O <= '0';                   --Dummyvärde, vet inte vad det här gör
      TP_DIN_O <= '0';                   --Dummyvärde, vet inte vad det här gör
      TP_CS_O <= '0';                   --Dummyvärde, vet inte vad det här gör 
      TP_DCLK_O <= '0';                   --Dummyvärde, vet inte vad det här gör 
      TP_DOUT_O <= '0';                   --Dummyvärde, vet inte vad det här gör 
      TP_PENIRQ_O <= '0';                   --Dummyvärde, vet inte vad det här gör 
      LED_EN_O <= '0';                   --Dummyvärde, vet inte vad det här gör.
                                         --Rimligtvis ska LED vara enabled dock
      TFT_CLK_O <= clk;                 --Den här tilldelas värden i olika
                                        --moduler vilket nog inte borde ske
      NC_O <= '0';


      TFT_EN_O <= en_debug;
      TFT_DISP_O <= disp_debug;
      TFT_BKLT_O <= bklt_debug;
      
      seg0 <= '1';
      seg1 <= '1';
      seg2 <= '1';
      seg3 <= '1';
      seg4 <= '1';
      seg5 <= '1';
      seg6 <= '1';

      led0 <= en_debug;
      led1 <= disp_debug;
      led2 <= bklt_debug;
      led3 <= '0';
      led4 <= '0';
      led5 <= '0';
      led6 <= '0';
      led7 <= '0';
    end Behavioral;

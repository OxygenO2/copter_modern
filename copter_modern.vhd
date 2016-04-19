library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity copter_modern is
  port (EXP-IO_P<0> : out std_logic;
        EXP-IO_P<1> : out std_logic;
        EXP-IO_P<2> : out std_logic;
        EXP-IO_P<3> : out std_logic;
        EXP-IO_P<4> : out std_logic;
        EXP-IO_P<5> : out std_logic;
        EXP-IO_P<6> : out std_logic;
        EXP-IO_P<7> : out std_logic;
        EXP-IO_P<8> : out std_logic;
        EXP-IO_P<9> : out std_logic;
        EXP-IO_P<10> : out std_logic;
        EXP-IO_P<11> : out std_logic;
        EXP-IO_P<12> : out std_logic;
        EXP-IO_P<13> : out std_logic;
        EXP-IO_P<14> : out std_logic;
        EXP-IO_P<15> : out std_logic;
        EXP-IO_P<16> : out std_logic;
        EXP-IO_P<17> : out std_logic;
        EXP-IO_P<18> : out std_logic;
        EXP-IO_P<19> : out std_logic;
        EXP-IO_P<20> : out std_logic);


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

  signal TP_BUSY : std_logic;
  signal TP_DIN : std_logic;
  signal TP_CS : std_logic;
  signal TP_DCLK : std_logic;
  signal TP_DOUT : std_logic;
  signal TP_PENIRQ : std_logic;

  signal TFT_CLK : std_logic;
  signal TFT_DISP : std_logic;
  signal TFT_EN : std_logic;
  signal TFT_DE : std_logic;
  signal LED_EN : std_logic;

 
  signal sprite_x : integer;
  signal sprite_y : integer;
   
  
  signal TFT_B[7] : std_logic;
  signal TFT_B[6] : std_logic;
  signal TFT_B[5] : std_logic;
  signal TFT_B[4] : std_logic;
  signal TFT_B[3] : std_logic;
  signal TFT_B[2] : std_logic;
  signal TFT_B[1] : std_logic;
  signal TFT_B[0] : std_logic;

  signal TFT_G[7] : std_logic;
  signal TFT_G[6] : std_logic;
  signal TFT_G[5] : std_logic;
  signal TFT_G[4] : std_logic;
  signal TFT_G[3] : std_logic;
  signal TFT_G[2] : std_logic;
  signal TFT_G[1] : std_logic;
  signal TFT_G[0] : std_logic;

  signal TFT_R[7] : std_logic;
  signal TFT_R[6] : std_logic;
  signal TFT_R[5] : std_logic;
  signal TFT_R[4] : std_logic;
  signal TFT_R[3] : std_logic;
  signal TFT_R[2] : std_logic;
  signal TFT_R[1] : std_logic;
  signal TFT_R[0] : std_logic;

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

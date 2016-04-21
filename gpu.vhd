--GPU

-- library declaration
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;            -- basic IEEE library
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.ALL;               -- IEEE library for the unsigned type

entity GPU is
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
          clk_O : out STD_LOGIC;
          disp : out STD_LOGIC;
          bklt : out STD_LOGIC;
          en_O : out STD_LOGIC;
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
         sprite_x       : in integer;
         sprite_y       : in integer;
         -- port 2
         we2		: in std_logic;
         tile_out	: out std_logic_vector(7 downto 0);
         sprite_out     : out std_logic_vector(7 downto 0);
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

  signal clk_div : unsigned(4 downto 0) := "00000";
  signal x_pixel : std_logic_vector(9 downto 0) := (others => '0');
  signal y_pixel : std_logic_vector(8 downto 0) := (others => '0');
  signal PIC_MEM_we : std_logic;
  signal PIC_MEM_data2 : std_logic_vector(7 downto 0);
  signal PIXEL_CHOOSER_player_pixel : std_logic_vector(7 downto 0);
  signal PIXEL_CHOOSER_tile_pixel : std_logic_vector(7 downto 0);
  signal PIXEL_CHOOSER_background_pixel : std_logic_vector(7 downto 0) := "00000011";
  signal PIXEL_CHOOSER_out : std_logic_vector(7 downto 0);
  signal blank : std_logic;


  signal LCD_clk : std_logic;
  signal LCD_rst : std_logic := '0';
  signal LCD_we : std_logic;
  signal LCD_de : STD_LOGIC;
  signal LCD_clk_O : STD_LOGIC;
  signal LCD_disp : STD_LOGIC;
  signal LCD_bklt : STD_LOGIC; --PWM backlight control
  signal LCD_en_O : STD_LOGIC;
  signal LCD_msel : STD_LOGIC_VECTOR(3 downto 0) := "1111"; -- Mode selection
                                                            -- 1111 för att starta
                                                            -- (egentligen 1000)
  
  constant CLOCKFREQ : natural := 9; --MHZ
  constant TPOWERUP : natural := 1; --ms
  constant TPOWERDOWN : natural := 1; --ms
  constant TLEDWARMUP : natural := 200; --ms
  constant TLEDCOOLDOWN : natural := 200; --ms
  --Argumenten nedan var multiplicerade med CLOCKFREQ, men vår klocka är
  --redan mod 9 när den kommer in
  constant TLEDWARMUP_CYCLES : natural := natural(TLEDWARMUP*1000);
  constant TLEDCOOLDOWN_CYCLES : natural := natural(TLEDCOOLDOWN*1000);
  constant TPOWERUP_CYCLES : natural := natural(TPOWERUP*1000);
  constant TPOWERDOWN_CYCLES : natural := natural(TPOWERDOWN*1000);	


  type state_type is (stOff, stPowerUp, stLEDWarmup, stLEDCooldown, stPowerDown, stOn); 
  signal state, nstate : state_type := stPowerDown;
  signal waitCnt : natural range 0 to TLEDCOOLDOWN_CYCLES := 0;
  signal waitCntEn : std_logic;

  signal int_Bklt : std_logic;
  signal int_De, clkStop : std_logic := '0';
  signal int_r, int_g, int_b : std_logic_vector(7 downto 0);

  signal bklt_counter : unsigned(31 downto 0) := (others => '0');

  
begin  -- Behavioral

--Backlight 
   process(clk)
   begin
     if rising_edge(clk) then
       if bklt_counter > 10000 then    -- 10000 is known to work
         bklt_counter <= (others => '0');
         if int_Bklt = '1' then
           int_Bklt <= '0';
         else
           int_Bklt <= '1';
         end if;
       else
         bklt_counter <= bklt_counter + 1;
       end if;
     end if;
   end process;
  
-- PIC_MEM component connection
  PM : PIC_MEM port map(clk=>clk,
                        we1=>PIC_MEM_we,
                        data_in1=>cpu_data,
                        x1=>cpu_x,
                        y1=>cpu_y,
                        sprite_x=>sprite_x,
                        sprite_y=>sprite_y,
                        we2=>'0',
                        tile_out=>PIXEL_CHOOSER_tile_pixel,
                        sprite_out=>PIXEL_CHOOSER_player_pixel,
                        x2=>x_pixel,
                        y2=>y_pixel);
	
  -- PIXEL_CHOOSER component connection
  PC : PIXEL_CHOOSER port map(clk => clk,
                              player_pixel => PIXEL_CHOOSER_player_pixel,
                              tile_pixel => PIXEL_CHOOSER_tile_pixel,
                              background_pixel => PIXEL_CHOOSER_background_pixel,
                              out_pixel => PIXEL_CHOOSER_out,
                              collision => collision); 

  --Generates CLOCKFREQ MHz LCD_clk
  process (clk)
  begin
    if rising_edge(clk) then
      if (clk_div = CLOCKFREQ - 1) then
        clk_div <= (others => '0'); 
      else
        clk_div <= clk_div + 1;
      end if;
    end if;
  end process;
  
  LCD_clk <= '1' when (clk_div = CLOCKFREQ - 1) else '0';
  
  --x_pixel_counter
  process (LCD_clk)
  begin
    if rising_edge(LCD_clk) then
      --if LCD_clk = '1' then
        if (x_pixel = 524) then
          x_pixel <= (others => '0');
        else
          x_pixel <= x_pixel + 1;
        end if;
    --end if;
    end if;
  end process;
  
  
  --y_pixel_counter
  process (LCD_clk)
  begin
    if rising_edge(LCD_clk) then
      if (x_pixel = 524) then
        if (y_pixel = 287) then
          y_pixel <= (others => '0');
        else
          y_pixel <= y_pixel +1;
        end if;
      end if;
    end if;
  end process; 








  
----------------------------------------------------------------------------------
-- LCD MOTOR
----------------------------------------------------------------------------------	

--LCD & backlight power 
  en_O <= '0' when state = stOff or state = stPowerDown else '1';

--Display On/Off signal
  disp <= '0' when state = stOff or state = stPowerUp or state = stPowerDown else '1';

--Interface signals
  de <= '0' when state = stOff or state = stPowerUp or state = stPowerDown else int_De;

  r <= (others => '0') when state = stOff or state = stPowerUp or state = stPowerDown else int_r;
  g <= (others => '0') when state = stOff or state = stPowerUp or state = stPowerDown else int_g;
  b <= (others => '0') when state = stOff or state = stPowerUp or state = stPowerDown else int_b;


--Clock signal
  clkStop <= '1' when state = stOff or state = stPowerUp or state = stPowerDown else '0';

--Backlight adjust/enable
  bklt <= int_Bklt when state = stOn else '0';

--Wait States
  waitCntEn <= '1' when (state = stPowerUp or state = stLEDWarmup or state = stLEDCooldown or state = stPowerDown) and (state = nstate) else '0';
					
  --Sync process
  process (LCD_clk)
   begin
      if rising_edge(LCD_clk) then
         state <= nstate;
      end if;
   end process;

   --next state decode
   process (state, waitCnt, LCD_msel)
   begin
      nstate <= state;
      case (state) is
        when stOff =>
          if (LCD_msel(3) = '1' and LCD_rst = '0') then
            nstate <= stPowerUp;
          end if;
        when stPowerUp => --turn power on first
          if (waitCnt = TPOWERUP_CYCLES) then
            nstate <= stLEDWarmup;
          end if;
        when stLEDWarmup => --turn on interface signals
          if (waitCnt = TLEDWARMUP_CYCLES) then
            nstate <= stOn;
          end if;
        when stOn => --turn on backlight too
          if (LCD_msel(3) = '0' or LCD_rst = '1') then
            nstate <= stLEDCooldown;
          end if;
        when stLEDCooldown =>
          if (waitCnt = TLEDCOOLDOWN_CYCLES) then
            nstate <= stPowerDown;
          end if;
        when stPowerDown => --turn off power last
          if (waitCnt = TPOWERDOWN_CYCLES) then
            nstate <= stOff;
          end if; 
      end case;      
   end process;

   --Process that pushes RGB-data
   process(LCD_clk)
     begin
     if Rising_Edge(LCD_clk) then
       if state = stOn then
         if blank = '0' then
           int_g <= PIXEL_CHOOSER_out(7 downto 5) & "00000";
           int_r <= PIXEL_CHOOSER_out(4 downto 2) & "00000";
           int_b <= PIXEL_CHOOSER_out(1 downto 0) & "000000";
         else
           int_g <= (others => '0');
           int_r <= (others => '0');
           int_b <= (others => '0');
         end if;
       else
           int_g <= (others => 'U');
           int_r <= (others => 'U');
           int_b <= (others => 'U');
       end if;
     end if;     
   end process;
     
----------------------------------------------------------------------------------
-- Wait Counter
----------------------------------------------------------------------------------  
   process(LCD_clk)
   begin
     if Rising_Edge(LCD_clk) then
       if waitCntEn = '0' then
         waitCnt <= 0;
       else
         waitCnt <= waitCnt + 1;
       end if;
     end if;
   end process;

   blank <= '1' when x_pixel > 480 or y_pixel > 272 else '0';
   int_De <= not blank;
   
end Behavioral;

--Taget från exempelkod på kurshemsidan
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

--library digilent;
--use digilent.video.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lcd_motor is
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
         vdden_O : out STD_LOGIC;

         MSEL_I : in STD_LOGIC_VECTOR(3 downto 0) -- Mode selection
	);
end lcd_motor;

architecture Behavioral of lcd_motor is
	constant CLOCKFREQ : natural := 9; --MHZ
	constant TPOWERUP : natural := 1; --ms
	constant TPOWERDOWN : natural := 1; --ms
	constant TLEDWARMUP : natural := 200; --ms
	constant TLEDCOOLDOWN : natural := 200; --ms
	constant TLEDWARMUP_CYCLES : natural := natural(CLOCKFREQ*TLEDWARMUP*1000);
	constant TLEDCOOLDOWN_CYCLES : natural := natural(CLOCKFREQ*TLEDCOOLDOWN*1000);
	constant TPOWERUP_CYCLES : natural := natural(CLOCKFREQ*TPOWERUP*1000);
	constant TPOWERDOWN_CYCLES : natural := natural(CLOCKFREQ*TPOWERDOWN*1000);	


----------------------------------------------------------------------------------
-- LCD Power Sequence
----------------------------------------------------------------------------------	

type state_type is (stOff, stPowerUp, stLEDWarmup, stLEDCooldown, stPowerDown, stOn); 
signal state, nstate : state_type := stPowerDown;
signal waitCnt : natural range 0 to TLEDCOOLDOWN_CYCLES := 0;
signal waitCntEn : std_logic;
signal int_Bklt, int_De, clkStop : std_logic := '0';
signal int_R, int_G, int_B : std_logic_vector(7 downto 0);

begin
--LCD & backlight power 
  vdden_O <= '0' when state = stOff or state = stPowerDown else '1';

--Display On/Off signal
  disp <= '0' when state = stOff or state = stPowerUp or state = stPowerDown else '1';

--Interface signals
  de <= '0' when state = stOff or state = stPowerUp or state = stPowerDown else int_De;
  r <= (others => '0') when state = stOff or state = stPowerUp or state = stPowerDown else int_R;
  g <= (others => '0') when state = stOff or state = stPowerUp or state = stPowerDown else int_G;
  b <= (others => '0') when state = stOff or state = stPowerUp or state = stPowerDown else int_B;
  
--Clock signal
  clkStop <= '1' when state = stOff or state = stPowerUp or state = stPowerDown else '0';

--Backlight adjust/enable
  bklt <= int_Bklt when state = stOn else '0';

--Wait States
  waitCntEn <= '1' when (state = stPowerUp or state = stLEDWarmup or state = stLEDCooldown or state = stPowerDown) and (state = nstate) else '0';
					
  --Sync process
  process (clk)
   begin
      if rising_edge(clk) then
         state <= nstate;
      end if;
   end process;				

   --next state decode
   process (state, waitCnt, MSEL_I)
   begin
      nstate <= state;
      case (state) is
        when stOff =>
          if (MSEL_I(3) = '1' and rst = '0') then
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
          if (MSEL_I(3) = '0' or rst = '1') then
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
   
end Behavioral;

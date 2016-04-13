--CPU

-- library declaration
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;            -- basic IEEE library
use IEEE.NUMERIC_STD.ALL;               -- IEEE library for the unsigned type



entity CPU is
  port ( clk : in std_logic;
         collision : in std_logic
         --reset : in std_logic;
         --input : in std_logic
    );
    
 
end CPU;


architecture Behavioral of CPU is

  -- Component ALU goes here


  signal data_bus : std_logic_vector(15 downto 0);
  signal pc : std_logic_vector(15 downto 0);
  signal asr : std_logic_vector(15 downto 0);
  signal alu_res : std_logic_vector(15 downto 0);
  signal res : std_logic_vector(15 downto 0);
  signal ir : std_logic_vector(31 downto 0);

  signal reg1 : std_logic_vector(15 downto 0);
  signal reg2 : std_logic_vector(15 downto 0);
  signal reg3 : std_logic_vector(15 downto 0);
  signal reg4 : std_logic_vector(15 downto 0);


  -- RAM (Max is 65535 for 16 bit addresses)
  type ram_t is array (0 to 4096) of std_logic_vector(15 downto 0);
  signal ram : ram_t := (others => "0000000000000000");


  
begin  -- Behavioral

  process(clk)
  begin
    if rising_edge(clk) then
      -- assign value
    end if;
  end process;

end Behavioral;

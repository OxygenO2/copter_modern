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


  signal data_bus : std_logic_vector(15 downto 0); -- := "0101010101010101";
  signal pc : std_logic_vector(15 downto 0); -- := "0000000000000000";
  signal asr : std_logic_vector(15 downto 0); -- := "1111111111111111";
  signal alu_res : std_logic_vector(15 downto 0);
  signal res : std_logic_vector(15 downto 0);
  signal ir : std_logic_vector(31 downto 0);

  signal reg1 : std_logic_vector(15 downto 0);
  signal reg2 : std_logic_vector(15 downto 0);
  signal reg3 : std_logic_vector(15 downto 0);
  signal reg4 : std_logic_vector(15 downto 0);

  signal micro_instr : std_logic_vector(7 downto 0);

  -- RAM (Max is 65535 for 16 bit addresses)
  type ram_t is array (0 to 4096) of std_logic_vector(15 downto 0);
  signal pmem : ram_t := (others => "0000000000000000");


begin  -- Behavioral


  with micro_instr(7 downto 4) select
    data_bus <= pc when "0001",
                asr when "0010",
                alu_res when "0101",
                res when "0110",
                ir when "0111",
                reg1 when "1000",
                reg2 when "1001",
                reg3 when "1010",
                reg4 when "1011",
                data_bus when others;
      
  process(clk)
  begin
    if rising_edge(clk) then
      if micro_instr(3 downto 0) = "0001" then
        pc <= data_bus;
      elsif micro_instr(3 downto 0) = "0010" then
        asr <= data_bus;
      elsif micro_instr(3 downto 0) = "0101" then
        alu_res <= data_bus;
      elsif micro_instr(3 downto 0) = "0110" then
        res <= data_bus;
      elsif micro_instr(3 downto 0) = "0111" then
        ir <= data_bus;
      elsif micro_instr(3 downto 0) = "1000" then
        reg1 <= data_bus;
      elsif micro_instr(3 downto 0) = "1001" then
        reg2 <= data_bus;
      elsif micro_instr(3 downto 0) = "1010" then
        reg3 <= data_bus;
      elsif micro_instr(3 downto 0) = "1011" then
        reg4 <= data_bus;
      end if;    
    end if;
  end process;



  
end Behavioral;

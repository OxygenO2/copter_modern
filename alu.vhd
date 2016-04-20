library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
port ( clk : in std_logic;
       OP : in std_logic_vector(2 downto 0);
       input : in signed(15 downto 0);
       result : buffer std_logic_vector(15 downto 0));
end ALU;

architecture Behavioral of ALU is

  signal reg1, reg2, reg3 : signed(15 downto 0) := (others => '0');
  
begin

  reg1 <= input;
  reg2 <= signed(result);
  result <= std_logic_vector(reg3);

  process(clk)
  begin
    if rising_edge(clk) then
      case OP is
        when "000" => --addition
             reg3 <= reg1 + reg2;
        when "001" =>
            reg3 <= reg1 - reg2; --subtraction
        when "010" =>
            reg3 <= not reg1;  --NOT gate
        when "011" =>
            reg3 <= reg1 nand reg2; --NAND gate
        when "100" =>
            reg3 <= reg1 nor reg2; --NOR gate              
        when "101" =>
            reg3 <= reg1 and reg2;  --AND gate
        when "110" =>
            reg3 <= reg1 or reg2;  --OR gate   
        when "111" =>
            reg3 <= reg1 xor reg2; --XOR gate  
        when others => null;
      end case;
    end if;
  end process;

end Behavioral;

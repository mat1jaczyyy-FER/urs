library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
-- use IEEE.NUMERIC_STD.ALL;

entity alu is
   port (
      INS       : in  std_logic_vector(2 downto 0);
      DR0, DR1  : in  std_logic_vector(1 downto 0);
      C_in      : in  std_logic;
      O_alu     : out std_logic_vector(1 downto 0);
      C_out     : out std_logic
   );
end alu;

architecture Behavioral of alu is

   signal result : std_logic_vector(2 downto 0);
   
begin
   
   execute_operation : process (INS, DR0, DR1, C_in)
   begin
      case INS is
         -- Implementacija naredbi za svaki kod instrukcije.
         -- Najviši bit vektora `results` cuva izlaznu vrijednost carryja,
         -- zato se 2-bitni ulazni podaci proširuju s nulom u najvišem bitu.
         -- Dakle, npr.: DR0 ima neka dva bita, recimo "11"
         -- A ako DR0 proširimo, ('0' & DR0), ima tri bita, "011".
         
         when "000" => result <= '0' & (DR0 and DR1);
         when "001" => result <= not ('0' & (DR0 or DR1));
         when "010" => result <= DR0(0) & DR0(1) & DR0(1);
         when "011" => result <= ('0' & DR0) + ('0' & DR1);
         when "100" => result <= ('0' & DR0) + ('0' & DR1) + ("00" & C_in);
         when "101" => if (DR0 <= DR1) then result <= '1' & DR0; else result <= '0' & DR0; end if;
         when "110" => if (DR0 >= DR1) then result <= '1' & DR0; else result <= '0' & DR0; end if;
         when "111" => if (DR0  >   0) then result <= '1' & DR0; else result <= '0' & DR0; end if;
         when others => result <= "000";
      end case;
   end process;
   
   O_alu <= result(1 downto 0);
   C_out <= result(2);

end Behavioral;


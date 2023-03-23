library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity register_data is
   port (
      D_reg   : in  std_logic_vector(1 downto 0);
      O_reg   : out std_logic_vector(1 downto 0);
      WR, CLK : in  std_logic
   );
end register_data;

architecture Behavioral of register_data is

   signal reg_data : std_logic_vector(1 downto 0);
   
begin
   -- Write data to register
   write_register : process (CLK)
   begin
      if rising_edge(CLK) then
         if (WR = '1') then
            reg_data <= D_reg;
         end if;
      end if;
   end process;
   
   -- Output register value
   O_reg <= reg_data;

end Behavioral;


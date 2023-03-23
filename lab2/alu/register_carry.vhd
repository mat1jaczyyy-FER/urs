library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity register_carry is
   port (
      D_reg, CLK, WR : in  std_logic;
      O_reg          : out std_logic
   );
end register_carry;

architecture Behavioral of register_carry is

   signal reg_data : std_logic;

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


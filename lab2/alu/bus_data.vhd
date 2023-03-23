library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bus_data is
   port (
      INS : in  std_logic_vector(2 downto 0);
      INR0, INR1 : in std_logic_vector(1 downto 0);
      INC, WR, CLK : in  std_logic;
      O   : out std_logic_vector(1 downto 0);
      C   : out std_logic
   );
end bus_data;

architecture Behavioral of bus_data is
   signal DR0, DR1 : std_logic_vector(1 downto 0);
   signal OR0, OR1, O_ALU : std_logic_vector(1 downto 0);
   signal DC, OC, C_ALU : std_logic;
begin
   
   alu : entity work.alu(Behavioral) port map(INS => INS,
                                              DR0 => OR0,
                                              DR1 => OR1,
                                              O_alu => O_ALU,
                                              C_in => OC,
                                              C_out => C_ALU);
  
   -- MUX Data input for R0 
   DR0 <= INR0 when WR = '1' else O_ALU;
   
   r0 : entity work.register_data(Behavioral) port map(D_reg => DR0,
                                                       O_reg => OR0,
                                                       WR => '1',
                                                       CLK => CLK);
   
   -- MUX Data input for R1 
   DR1 <= INR1;
   
   r1 : entity work.register_data(Behavioral) port map(D_reg => DR1,
                                                       O_reg => OR1,
                                                       WR => '1',
                                                       CLK => CLK);
                                                       
   -- MUX Data input for Carry 
   DC <= INC when WR = '1' else C_ALU;
   
   carry : entity work.register_carry(Behavioral) port map(D_reg => DC,
                                                           O_reg => OC,
                                                           WR => '1',
                                                           CLK => CLK);
   
   O <= O_ALU;
   C <= C_ALU;

end Behavioral;


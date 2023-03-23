LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY zadatak3_tb IS
END zadatak3_tb;
 
ARCHITECTURE behavior OF zadatak3_tb IS 
    COMPONENT zadatak3
    PORT(
         SMJER : IN  std_logic;
         DISP : OUT  std_logic_vector(7 downto 0);
         CLK : IN  std_logic;
         ANODE : OUT  std_logic
        );
    END COMPONENT;
    
   signal SMJER : std_logic := '0';
   signal CLK : std_logic := '0';

   signal DISP : std_logic_vector(7 downto 0);
   signal ANODE : std_logic;

   constant CLK_period : time := 125 ns;
 
BEGIN
   uut: zadatak3 PORT MAP (
          SMJER => SMJER,
          DISP => DISP,
          CLK => CLK,
          ANODE => ANODE
        );

   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;

   stim_proc: process
   begin
        SMJER <= not '0';
        wait for CLK_period*12;
        
        SMJER <= not '1';
        wait for CLK_period*12;
        
        SMJER <= not '0';
        wait;
   end process;

END;

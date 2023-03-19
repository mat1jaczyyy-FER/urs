LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY zadatak2_tb IS
END zadatak2_tb;
 
ARCHITECTURE behavior OF zadatak2_tb IS 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT zadatak2
    PORT(
         SMJER : IN  std_logic;
         CLK : IN  std_logic;
         S : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal SMJER : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal S : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 125 ns;
 
BEGIN
	-- Instantiate the Unit Under Test (UUT)
   uut: zadatak2 PORT MAP (
          SMJER => SMJER,
          CLK => CLK,
          S => S
        );

   -- Clock process definitions
   CLK_process: process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 
   -- Stimulus process
   stim_proc: process
   begin
      wait for CLK_period*10;
      
      SMJER <= '1';
      
      wait for CLK_period*13;
      
      SMJER <= '0';

      wait;
   end process;

END;

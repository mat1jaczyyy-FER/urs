LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY counter3bit_tb IS
END counter3bit_tb;
 
ARCHITECTURE behavior OF counter3bit_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT counter3bit
    PORT(
         UD : IN  std_logic;
         CE : IN  std_logic;
         B : OUT  std_logic_vector(2 downto 0);
         RESET : IN  std_logic;
         CLK : IN  std_logic;
         ANODE : OUT  std_logic
        );
    END COMPONENT;

   --Inputs
   signal UD : std_logic := '0';
   signal CE : std_logic := '0';
   signal RESET : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal B : std_logic_vector(2 downto 0);
   signal ANODE : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 125 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: counter3bit PORT MAP (
          UD => UD,
          CE => CE,
          B => B,
          RESET => RESET,
          CLK => CLK,
          ANODE => ANODE
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
        RESET <= not '1';
        wait for 275 ns;
        
        RESET <= not '0';
        
        CE <= not '1';
        UD <= not '1';
        wait for CLK_period*5;
        
        CE <= not '0';
        wait for CLK_period*5;
        
        CE <= not '1';
        UD <= not '0';
        wait for CLK_period*7;
        
        wait;
   end process;

END;

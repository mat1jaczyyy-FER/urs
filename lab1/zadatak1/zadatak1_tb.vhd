LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY zadatak1_tb IS
END zadatak1_tb;
 
ARCHITECTURE behavior OF zadatak1_tb IS 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT zadatak1
    PORT(
         U : IN  std_logic;
         V : IN  std_logic;
         W : IN  std_logic;
         S : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    
   --Inputs
   signal U : std_logic := '0';
   signal V : std_logic := '0';
   signal W : std_logic := '0';

 	--Outputs
   signal S : std_logic_vector(7 downto 0);
   
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: zadatak1 PORT MAP (
          U => U,
          V => V,
          W => W,
          S => S
        );

   -- Stimulus process
   stim_proc: process
   begin
        U <= not '0';
        V <= not '0';
        W <= not '0';
        wait for 10 ns;
        
        W <= not '1';
        wait for 10 ns;
        
        V <= not '1';
        W <= not '0';
        wait for 10 ns;
        
        W <= not '1';
        wait for 10 ns;
        
        U <= not '1';
        V <= not '0';
        W <= not '0';
        wait for 10 ns;
        
        W <= not '1';
        wait for 10 ns;
        
        V <= not '1';
        W <= not '0';
        wait for 10 ns;
        
        W <= not '1';
        wait for 10 ns;
        
        wait;
   end process;

END;

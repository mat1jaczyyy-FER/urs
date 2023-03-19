LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY decoder_tb IS
END decoder_tb;
 
ARCHITECTURE behavior OF decoder_tb IS 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT decoder
    PORT(
         D : IN  std_logic_vector(2 downto 0);
         S : OUT  std_logic_vector(7 downto 0);
         TST : IN  std_logic;
         ANODA : OUT  std_logic
        );
    END COMPONENT;
    
   --Inputs
   signal D : std_logic_vector(2 downto 0) := (others => '0');
   signal TST : std_logic := '0';

 	--Outputs
   signal S : std_logic_vector(7 downto 0);
   signal ANODA : std_logic;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: decoder PORT MAP (
          D => D,
          S => S,
          TST => TST,
          ANODA => ANODA
        );

   -- Stimulus process
   stim_proc: process
   begin
        TST <= not '1';
        wait for 10 ns;
        
        TST <= not '0';
        D <= not "000";
        wait for 10 ns;
        
        D <= not "001";
        wait for 10 ns;
        
        D <= not "010";
        wait for 10 ns;
        
        D <= not "011";
        wait for 10 ns;
        
        D <= not "100";
        wait for 10 ns;
        
        D <= not "101";
        wait for 10 ns;
        
        D <= not "110";
        wait for 10 ns;
        
        D <= not "111";
        wait for 10 ns;
      
        wait;
   end process;

END;

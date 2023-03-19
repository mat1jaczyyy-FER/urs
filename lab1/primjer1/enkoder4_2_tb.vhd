LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY enkoder4_2_tb IS
END enkoder4_2_tb;
 
ARCHITECTURE behavior OF enkoder4_2_tb IS 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT enkoder4_2
    PORT(
         D : IN  std_logic_vector(3 downto 0);
         C : OUT  std_logic_vector(1 downto 0);
         DP : OUT  std_logic;
         ANODE : OUT  std_logic
        );
    END COMPONENT;

   --Inputs
   signal D : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal C : std_logic_vector(1 downto 0);
   signal DP : std_logic;
   signal ANODE : std_logic;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: enkoder4_2 PORT MAP (
          D => D,
          C => C,
          DP => DP,
          ANODE => ANODE
        );

   -- Stimulus process
   stim_proc: process
   begin
        D <= not "1000";
        wait for 10 ns;
        
        D <= not "0100";
        wait for 10 ns;
        
        D <= not "0010";
        wait for 10 ns;
        
        D <= not "0001";
        wait for 10 ns;
        
        D <= not "1001";
        wait for 10 ns;
        
        D <= not "1111";
        wait for 10 ns;
   
        wait;
   end process;
END;

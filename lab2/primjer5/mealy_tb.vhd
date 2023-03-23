-- mealy_tb.vhd
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY mealy_tb IS
END mealy_tb;
 
ARCHITECTURE behavior OF mealy_tb IS 
    COMPONENT mealy
    PORT(
         VRTI : IN  std_logic;
         INVERT : IN  std_logic;
         D : OUT  std_logic_vector(3 downto 0);
         RESET : IN  std_logic;
         CLK : IN  std_logic
        );
    END COMPONENT;
    
   signal VRTI : std_logic := '0';
   signal INVERT : std_logic := '0';
   signal RESET : std_logic := '0';
   signal CLK : std_logic := '0';

   signal D : std_logic_vector(3 downto 0);

   constant CLK_period : time := 125 ns;
 
BEGIN
   uut: mealy PORT MAP (
          VRTI => VRTI,
          INVERT => INVERT,
          D => D,
          RESET => RESET,
          CLK => CLK
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
        RESET <= not '0';
        INVERT <= not '0';
        VRTI <= not '1';
        wait for CLK_period*10;
        
        RESET <= not '1';
        wait for 275 ns;
        
        RESET <= not '0';
        VRTI <= not '0';
        wait for CLK_period*5;
        
        wait;
   end process;

END;

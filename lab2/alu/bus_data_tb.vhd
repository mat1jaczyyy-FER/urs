LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY bus_data_tb IS
END bus_data_tb;
 
ARCHITECTURE behavior OF bus_data_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT bus_data
    PORT(
         INS : IN  std_logic_vector(2 downto 0);
         INR0 : IN  std_logic_vector(1 downto 0);
         INR1 : IN  std_logic_vector(1 downto 0);
         INC : IN  std_logic;
         WR : IN  std_logic;
         CLK : IN  std_logic;
         O : OUT  std_logic_vector(1 downto 0);
         C : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   -- signal INS : std_logic_vector(2 downto 0) := (others => '0');
   signal INS : std_logic_vector(2 downto 0) := "UUU";
   signal INR0 : std_logic_vector(1 downto 0) := (others => '0');
   signal INR1 : std_logic_vector(1 downto 0) := (others => '0');
   signal INC : std_logic := '0';
   signal WR : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal O : std_logic_vector(1 downto 0);
   signal C : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 125 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: bus_data PORT MAP (
          INS => INS,
          INR0 => INR0,
          INR1 => INR1,
          INC => INC,
          WR => WR,
          CLK => CLK,
          O => O,
          C => C
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      WR <= '1';
      INR0 <= "01";
      INR1 <= "10";
      wait for CLK_period;
      WR <= '0';
      INS <= "000";
      wait for CLK_period;
      
      WR <= '1';
      INR0 <= "01";
      INR1 <= "10";
      wait for CLK_period;
      WR <= '0';
      INS <= "001";
      wait for CLK_period;
      
      WR <= '1';
      INR0 <= "11";
      wait for CLK_period;
      WR <= '0';
      INS <= "010";
      wait for CLK_period;
      
      WR <= '1';
      INR0 <= "11";
      INR1 <= "10";
      INC <= '0';
      wait for CLK_period;
      WR <= '0';
      INS <= "011";
      wait for CLK_period;
      
      WR <= '1';
      INR0 <= "11";
      INR1 <= "10";
      INC <= '1';
      wait for CLK_period;
      WR <= '0';
      INS <= "100";
      wait for CLK_period;
      
      WR <= '1';
      INR0 <= "00";
      INR1 <= "01";
      wait for CLK_period;
      WR <= '0';
      INS <= "101";
      wait for CLK_period;
      
      WR <= '1';
      INR0 <= "00";
      INR1 <= "01";
      wait for CLK_period;
      WR <= '0';
      INS <= "110";
      wait for CLK_period;
      
      WR <= '1';
      INR0 <= "00";
      INR1 <= "01";
      wait for CLK_period;
      WR <= '0';
      INS <= "111";
      wait for CLK_period;

      wait;
   end process;

END;

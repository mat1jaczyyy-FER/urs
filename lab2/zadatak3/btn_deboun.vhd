library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity btn_deboun is
	port(
		BTN    : in  std_logic;
		OUTPUT : out std_logic;
		CLK    : in  std_logic;
		RESET  : in  std_logic
	);

end btn_deboun;

architecture Behavioral of btn_deboun is

   -- Flip-flop enable
	signal CE: std_logic;

	-- D1 filp-flop output
	signal Q1, Q2, Q3, Q4, Q5: std_logic;
	
	-- SR flip-flop set/reset
	signal S, R: std_logic;
	
	-- Counter
	signal counter: std_logic_vector (17 downto 0);
   
   signal CNT_MOST_SIGNIFICANT: std_logic;
   
begin
   CNT_MOST_SIGNIFICANT <= counter(17);

   -- -----------------------------------------------------------
   --                          DEVICE
   -- -----------------------------------------------------------
   process(CLK)
   begin
      if rising_edge(CLK) then
         if (RESET = not '1') then
            Q1 <= '0';
         elsif (CE = '1') then
            Q1 <= BTN;
         end if;
      end if;
   end process;

   process(CLK)
   begin
      if rising_edge(CLK) then
         if (RESET = not '1') then
            Q2 <= '0';
         elsif (CE = '1') then
            Q2 <= Q1;
         end if;
      end if;
   end process;

   S <= (not BTN) and (not Q1) and (not Q2);
   R <= BTN and Q1 and Q2;

   process(CLK)
   begin
      if rising_edge(CLK) then
         if (RESET = not '1') then
            Q3 <= '0';
         elsif (R = '1') then
            Q3 <= '0';
         elsif (S = '1') then
            Q3 <= '1';
         else
            Q3 <= Q3;
         end if;
      end if;
   end process;

   OUTPUT <= Q3;
   
   -- -----------------------------------------------------------
   --                        COUNTER
   -- -----------------------------------------------------------
	process (CLK)
	begin
		if rising_edge(CLK) then
			if (RESET = not '1') then
			   counter <= (others => '0'); 
			else
    			counter <= counter + '1';
			end if;
		end if;
	end process;
   
   process(CLK)
   begin
      if rising_edge(CLK) then
         if (RESET = not '1') then
            Q4 <= '0';
         else
            Q4 <= CNT_MOST_SIGNIFICANT;
         end if;
      end if;
   end process;
   
   process(CLK)
   begin
      if rising_edge(CLK) then
         if (RESET = not '1') then
            Q5 <= '0';
         else
            Q5 <= (not CNT_MOST_SIGNIFICANT) and Q4;
         end if;
      end if;
   end process;
   
   CE <= Q5;
                                                         
end Behavioral;

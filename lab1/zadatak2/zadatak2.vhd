library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity zadatak2 is
    port (
        SMJER :  in std_logic;
        CLK   :  in std_logic;
        S     : out std_logic_vector (7 downto 0);
		  ANODE : out std_logic
    );
end zadatak2;

architecture Behavioral of zadatak2 is
    signal RUNNING: std_logic := '0';
    signal STATE: std_logic_vector (1 downto 0) := "00";
    signal SMJERBIT: std_logic_vector (7 downto 0);
begin
    
	 ANODE <= '0';
	 
    process (CLK)
    begin
        if (rising_edge(CLK)) then
            if (RUNNING = '0') then
                RUNNING <= '1';
            elsif (SMJER = not '1') then -- cw
                STATE <= (STATE + '1');
                SMJERBIT <= "00000000";
            elsif (SMJER = not '0') then -- ccw
                STATE <= (STATE - '1');
                SMJERBIT <= "00000001";
            end if;
        end if;
    end process;
    
    S <= not "00000000"               when RUNNING = '0' else
         not ("00000010" or SMJERBIT) when   STATE = "00" else
         not ("00100000" or SMJERBIT) when   STATE = "01" else
         not ("00010000" or SMJERBIT) when   STATE = "10" else
         not ("00001000" or SMJERBIT) when   STATE = "11";

end Behavioral;


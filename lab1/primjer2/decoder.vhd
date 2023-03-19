library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder is
    port (
        D     :  in std_logic_vector (2 downto 0);
        S     : out std_logic_vector (7 downto 0);
        TST   :  in std_logic;
        ANODA : out std_logic
    );
end decoder;

architecture Behavioral of decoder is

begin
    ANODA <= '0';
    
    process (D, TST)
    begin
           if (TST = not '1') then S <= not "11111111";
        elsif (D = not "000") then S <= not "11111100";
        elsif (D = not "001") then S <= not "01100000";
        elsif (D = not "010") then S <= not "11011010";
        elsif (D = not "011") then S <= not "11110010";
        elsif (D = not "100") then S <= not "01100110";
        elsif (D = not "101") then S <= not "10110110";
        elsif (D = not "110") then S <= not "10111110";
        elsif (D = not "111") then S <= not "11100000";
        end if;
    end process;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity zadatak1 is
    port (
        U, V, W:  in std_logic;
        S      : out std_logic_vector (7 downto 0);
        ANODE  : out std_logic
    );
end zadatak1;

architecture Behavioral of zadatak1 is  
begin
    ANODE <= '0';

    process (U, V, W)
    begin
        if (
            (U = not '0' and V = not '0' and W = not '0') or
            (U = not '1' and V = not '1' and W = not '0') or
            (U = not '1' and V = not '0' and W = not '1')
        ) then S <= not "11111100";
        elsif (
            (U = not '0' and V = not '0' and W = not '1') or
            (U = not '0' and V = not '1' and W = not '0') or
            (U = not '1' and V = not '1' and W = not '1')
        ) then S <= not "01100000";
        elsif (
            U = not '0' and V = not '1' and W = not '1'
        ) then S <= not "11011010";
        elsif (
            U = not '1' and V = not '0' and W = not '0'
        ) then S <= not "01100001";
        end if;
    end process;

end Behavioral;


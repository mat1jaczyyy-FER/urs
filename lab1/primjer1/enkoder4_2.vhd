library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity enkoder4_2 is
    port (
        D     :  in std_logic_vector (3 downto 0);
        C     : out std_logic_vector (1 downto 0);
        DP    : out std_logic;
        ANODE : out std_logic
    );
end enkoder4_2;

architecture Behavioral of enkoder4_2 is

begin
    ANODE <= '0';
    
    process (D)
    begin
        if (D = not "1000") then
            C <= not "00";
            DP <= not '0';
        elsif (D = not "0100") then
            C <= not "01";
            DP <= not '0';
        elsif (D = not "0010") then
            C <= not "10";
            DP <= not '0';
        elsif (D = not "0001") then
            C <= not "11";
            DP <= not '0';
        else
            C <= not "11";
            DP <= not '1';
        end if;    
    end process;

end Behavioral;

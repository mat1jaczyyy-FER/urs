library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter3bit is
    port (
        UD, CE :  in std_logic; -- UD => smjer, CE => count enable
        B      : out std_logic_vector (2 downto 0);
        RESET  :  in std_logic;
        CLK    :  in std_logic;
        ANODE  : out std_logic
    );
end counter3bit;

architecture Behavioral of counter3bit is
    signal CNT: std_logic_vector (2 downto 0);

begin
    ANODE <= '0';
    
    process (CLK)
    begin
        if rising_edge(CLK) then
            if (RESET = not '1') then
                CNT <= "000";
            elsif (CE = not '0') then
                CNT <= CNT;
            elsif (UD = not '1') then
                CNT <= CNT + '1';
            elsif (UD = not '0') then
                CNT <= CNT - '1';
            end if;
        end if;
    end process;

    B <= not CNT;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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
            CNT(2) <= (
                RESET and (
                    (not UD and not CE and (
                        (not CNT(2) and     CNT(1) and     CNT(0)) or
                        (    CNT(2) and not CNT(1) and not CNT(0)) or
                        (    CNT(2) and not CNT(1) and     CNT(0)) or
                        (    CNT(2) and     CNT(1) and not CNT(0))
                    )) or (UD and not CE and (
                        (not CNT(2) and not CNT(1) and not CNT(0)) or
                        (not CNT(2) and     CNT(1) and not CNT(0)) or
                        (    CNT(2) and     CNT(1) and not CNT(0)) or
                        (    CNT(2) and     CNT(1) and     CNT(0))
                    )) or (CE and CNT(2))
                )
            ) or not RESET;

            CNT(1) <= (
                RESET and (
                    (not UD and not CE and (
                        (not CNT(2) and not CNT(1) and     CNT(0)) or
                        (not CNT(2) and     CNT(1) and not CNT(0)) or
                        (    CNT(2) and not CNT(1) and     CNT(0)) or
                        (    CNT(2) and     CNT(1) and not CNT(0))
                    )) or (UD and not CE and (
                        (not CNT(2) and not CNT(1) and not CNT(0)) or
                        (not CNT(2) and     CNT(1) and     CNT(0)) or
                        (    CNT(2) and not CNT(1) and not CNT(0)) or
                        (    CNT(2) and     CNT(1) and     CNT(0))
                    )) or (CE and CNT(1))
                )
            ) or not RESET;

            CNT(0) <= (
                RESET and (
                    (not UD and not CE and (
                        (not CNT(2) and not CNT(1) and not CNT(0)) or
                        (not CNT(2) and     CNT(1) and not CNT(0)) or
                        (    CNT(2) and not CNT(1) and not CNT(0)) or
                        (    CNT(2) and     CNT(1) and not CNT(0))
                    )) or (UD and not CE and (
                        (not CNT(2) and not CNT(1) and not CNT(0)) or
                        (not CNT(2) and     CNT(1) and not CNT(0)) or
                        (    CNT(2) and not CNT(1) and not CNT(0)) or
                        (    CNT(2) and     CNT(1) and not CNT(0))
                    )) or (CE and CNT(0))
                )
            ) or not RESET;
        end if;
    end process;

    B <= not CNT;

end Behavioral;

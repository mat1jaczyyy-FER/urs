library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mealy is
    port (
        VRTI    :  in std_logic;
        INVERT  :  in std_logic;
        D       : out std_logic_vector(3 downto 0);
        RESET   :  in std_logic;
        CLK     :  in std_logic
    );
end mealy;

architecture Behavioral of mealy is
    type state_type is (INIT, LIJEVO, DOLJE, DESNO, OPETDOLJE, GORE);
    signal Dint      : std_logic_vector(3 downto 0) := not "0000";
    signal cur_state : state_type := INIT;
    signal nxt_state : state_type;
begin

    D <= Dint;
    output : process (CLK)
    begin
        if rising_edge(CLK) then
            if (cur_state = INIT) then
                if (INVERT = not '1') then
                    Dint <= "0000";
                else
                    Dint <= not "0000";
                end if;
            
            elsif (cur_state = LIJEVO) then
                if (INVERT = not '1') then
                    Dint <= "0010";
                else
                    Dint <= not "0010";
                end if;
            
            elsif (cur_state = DOLJE) then
                if (INVERT = not '1') then
                    Dint <= "0001";
                else
                    Dint <= not "0001";
                end if;
            
            elsif (cur_state = DESNO) then
                if (INVERT = not '1') then
                    Dint <= "0100";
                else
                    Dint <= not "0100";
                end if;
            
            elsif (cur_state = OPETDOLJE) then
                if (INVERT = not '1') then
                    Dint <= "0001";
                else
                    Dint <= not "0001";
                end if;
            
            elsif (cur_state = GORE) then
                if (INVERT = not '1') then
                    Dint <= "1000";
                else
                    Dint <= not "1000";
                end if;
            
            end if;
        end if;
    end process;
    
    transfer : process (cur_state, nxt_state, RESET, VRTI)
    begin
        if (RESET  = not '1') then
            nxt_state <= LIJEVO;
            
        elsif (cur_state = INIT) then
            nxt_state <= LIJEVO;
            
        elsif (cur_state = LIJEVO) then
            if (VRTI = not '1') then
                nxt_state <= GORE;
            else
                nxt_state <= DOLJE;
            end if;
            
        elsif (cur_state = DOLJE) then
            nxt_state <= DESNO;
            
        elsif (cur_state = DESNO) then
            nxt_state <= OPETDOLJE;
            
        elsif (cur_state = OPETDOLJE) then
            nxt_state <= LIJEVO;
            
        elsif (cur_state = GORE) then
            nxt_state <= DESNO;
        
        end if;
    end process;
    
    update : process (CLK)
    begin
        if rising_edge(CLK) then
            cur_state <= nxt_state;
        end if;
    end process;

end Behavioral;


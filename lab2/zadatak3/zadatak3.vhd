library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity zadatak3 is
    port (
        SMJER :  in std_logic;
        DISP  : out std_logic_vector(7 downto 0);
        BTN   :  in std_logic;
        CLK   :  in std_logic;
        ANODE : out std_logic
    );
end zadatak3;

architecture Behavioral of zadatak3 is
    type state_type is (INIT, A, B, GD, E, D, C, GU, F);
    signal Dint      : std_logic_vector(7 downto 0) := not "00000000";
    signal cur_state : state_type := INIT;
    signal nxt_state : state_type;
    signal btn_clk   : std_logic;
begin

    ANODE <= not '0';
    DISP <= Dint;
    
    output : process (CLK)
    begin
        if rising_edge(CLK) then
               if (cur_state = INIT) then Dint <= not "00000000";
            elsif (cur_state = A)    then Dint <= not "10000000";
            elsif (cur_state = B)    then Dint <= not "01000000";
            elsif (cur_state = GD)   then Dint <= not "00000010";
            elsif (cur_state = E)    then Dint <= not "00001000";
            elsif (cur_state = D)    then Dint <= not "00010000";
            elsif (cur_state = C)    then Dint <= not "00100000";
            elsif (cur_state = GU)   then Dint <= not "00000011";
            elsif (cur_state = F)    then Dint <= not "00000100";
            end if;
        end if;
    end process;

    transfer : process (cur_state, nxt_state, SMJER)
    begin
        if (SMJER = not '0') then
               if (cur_state = INIT) then nxt_state <= D;
            elsif (cur_state = A)    then nxt_state <= B;
            elsif (cur_state = B)    then nxt_state <= GD;
            elsif (cur_state = GD)   then nxt_state <= E;
            elsif (cur_state = E)    then nxt_state <= D;
            elsif (cur_state = D)    then nxt_state <= C;
            elsif (cur_state = C)    then nxt_state <= GU;
            elsif (cur_state = GU)   then nxt_state <= F;
            elsif (cur_state = F)    then nxt_state <= A;
            end if;
        else
               if (cur_state = INIT) then nxt_state <= D;
            elsif (cur_state = A)    then nxt_state <= F;
            elsif (cur_state = B)    then nxt_state <= A;
            elsif (cur_state = GD)   then nxt_state <= B;
            elsif (cur_state = E)    then nxt_state <= GD;
            elsif (cur_state = D)    then nxt_state <= E;
            elsif (cur_state = C)    then nxt_state <= D;
            elsif (cur_state = GU)   then nxt_state <= C;
            elsif (cur_state = F)    then nxt_state <= GU;
            end if;
        end if;
    end process;
    
    update : process (BTN_CLK)
    begin
        if rising_edge(BTN_CLK) then
            cur_state <= nxt_state;
        end if;
    end process;

    button_clock: entity work.btn_deboun(Behavioral) port map (
        BTN => BTN,
        OUTPUT => BTN_CLK,
        CLK => CLK,
        RESET => '1'
    );

end Behavioral;


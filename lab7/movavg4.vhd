-- Dominik Matijaca 0036524568

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity movavg4 is
    port (
        clk: in std_logic;
        rst: in std_logic;

        -- Adresna sabirnica
        port_id: in std_logic_vector(7 downto 0);

        -- Podatkovna sabirnica za pisanje u registar, spaja se na out_port od KCPSM6
        in_port:      in std_logic_vector(7 downto 0);
        write_strobe: in std_logic;

        -- Podatkovna sabirnica za čitanje iz registra, spaja se na in_port od KCPSM6
        out_port:    out std_logic_vector(7 downto 0);
        read_strobe:  in std_logic
    );
end entity;

architecture arch of movavg4 is
    -- Protočna struktura registara
    signal r0:  std_logic_vector(7 downto 0);
    signal r1:  std_logic_vector(7 downto 0);
    signal r2:  std_logic_vector(7 downto 0);
    signal r3:  std_logic_vector(7 downto 0);
    signal sum: std_logic_vector(9 downto 0);
    
    -- Konstante za adresnu sabirnicu
    constant ULAZ:  std_logic_vector(7 downto 0) := "00000000";
    constant IZLAZ: std_logic_vector(7 downto 0) := "00000001";
    constant RESET: std_logic_vector(7 downto 0) := "00000010";
begin
    -- Prihvati podatke na ulazu
    process (clk, rst)
    begin
        if (rising_edge(clk) and port_id = RESET) then
            r0 <= "UUUUUUUU";
            r1 <= "UUUUUUUU";
            r2 <= "UUUUUUUU";
            r3 <= "UUUUUUUU";
        
        elsif (rising_edge(clk) and port_id = ULAZ and write_strobe = '1') then
            r3 <= r2;
            r2 <= r1;
            r1 <= r0;
            r0 <= in_port;
        end if;
    end process;
    
    -- Izračunaj sumu/prosjek
    sum <= "0000000000" when r3 = "UUUUUUUU" else
           ("00" & r0) + ("00" & r1) + ("00" & r2) + ("00" & r3);

    -- Postavi podatke na izlaz
    process (clk, rst)
    begin
        if (rising_edge(clk) and port_id = IZLAZ and read_strobe = '1') then
            out_port <= sum(9 downto 2);
        else
            out_port <= "00000000";
        end if;
    end process;
end architecture arch;

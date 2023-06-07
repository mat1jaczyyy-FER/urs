library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity system_testbench is
end entity ; -- system_testbench

architecture simulate of system_testbench is

	type test_data_t is array (natural range <>) of std_logic_vector(7 downto 0);
	constant test_input_data : test_data_t := (
		x"ac", x"eb", x"ba", x"e5", x"78", x"91", x"2d", x"6b", x"82", x"bf", x"2e", x"c3", x"9e", x"4f", x"f4", x"cf", x"85", x"a2", x"ff", x"27", x"2c", x"80", x"57", x"15", x"3a", x"06", x"f2", x"36", x"05", x"c9", x"09", x"fb", x"c4", x"a6", x"a8", x"fb", x"19", x"a8", x"2c", x"41", x"1a", x"81", x"cf", x"a1", x"dd", x"b2", x"81", x"0d", x"b9", x"7a");

	constant test_output_data : test_data_t := (
		x"cd", x"c0", x"aa", x"86", x"68", x"6a", x"76", x"76", x"8c", x"93", x"77", x"a9", x"ac", x"a5", x"ba", x"bd", x"93", x"7d", x"74", x"4a", x"46", x"49", x"2b", x"51", x"5a", x"4c", x"7d", x"43", x"74", x"a4", x"9b", x"c3", x"c3", x"98", x"99", x"7a", x"4b", x"4b", x"42", x"6a", x"82", x"b3", x"bf", x"ac", x"87", x"7e", x"70");

	signal input_data_counter : integer := 0;
	signal output_data_counter : integer := 0;

-- Deklaracija KCPSM6 komponente
  component kcpsm6 
    generic(                 hwbuild : std_logic_vector(7 downto 0) := X"00";
                    interrupt_vector : std_logic_vector(11 downto 0) := X"3FF";
             scratch_pad_memory_size : integer := 64);
    port (                   address : out std_logic_vector(11 downto 0);
                         instruction : in std_logic_vector(17 downto 0);
                         bram_enable : out std_logic;
                             in_port : in std_logic_vector(7 downto 0);
                            out_port : out std_logic_vector(7 downto 0);
                             port_id : out std_logic_vector(7 downto 0);
                        write_strobe : out std_logic;
                      k_write_strobe : out std_logic;
                         read_strobe : out std_logic;
                           interrupt : in std_logic;
                       interrupt_ack : out std_logic;
                               sleep : in std_logic;
                               reset : in std_logic;
                                 clk : in std_logic);
  end component;

-- Deklaracija programske memorije
  component program                            
    generic(             C_FAMILY : string := "S6"; 
                C_RAM_SIZE_KWORDS : integer := 1;
             C_JTAG_LOADER_ENABLE : integer := 0);
    Port (      address : in std_logic_vector(11 downto 0);
            instruction : out std_logic_vector(17 downto 0);
                 enable : in std_logic;
                    rdl : out std_logic;                    
                    clk : in std_logic);
  end component;

-- Deklaracija movavg4
 component movavg4 is
	Port (
		            clk : in std_logic;
		            rst : in std_logic;
		        port_id : in std_logic_vector(7 downto 0);
		        in_port : in std_logic_vector(7 downto 0);
		   write_strobe : in std_logic;
		       out_port : out std_logic_vector(7 downto 0);
		    read_strobe : in std_logic
	) ;
end component;

-- Signali
signal             clk : std_logic;
signal           clk_n : std_logic;
signal         address : std_logic_vector(11 downto 0);
signal     instruction : std_logic_vector(17 downto 0);
signal     bram_enable : std_logic;
signal         in_port : std_logic_vector(7 downto 0);
signal        out_port : std_logic_vector(7 downto 0);
signal         port_id : std_logic_vector(7 downto 0);
signal    write_strobe : std_logic;
signal  k_write_strobe : std_logic;
signal     read_strobe : std_logic;
signal       interrupt : std_logic;
signal   interrupt_ack : std_logic;
signal    kcpsm6_sleep : std_logic;
signal    kcpsm6_reset : std_logic;

signal             rst : std_logic;
signal     ma4_in_port : std_logic_vector(7 downto 0);

signal    data_in_port : std_logic_vector(7 downto 0);

signal        avg_flag : boolean := false;
signal        min_flag : boolean := false;
signal        max_flag : boolean := false;

constant             T : time := 20 ns;

begin

-- Instanca KCPSM6 
	processor: kcpsm6
    generic map (                 hwbuild => X"00", 
                         interrupt_vector => X"3FF",
                  scratch_pad_memory_size => 64)
    port map(      address => address,
               instruction => instruction,
               bram_enable => bram_enable,
                   port_id => port_id,
              write_strobe => write_strobe,
            k_write_strobe => k_write_strobe,
                  out_port => out_port,
               read_strobe => read_strobe,
                   in_port => in_port,
                 interrupt => interrupt,
             interrupt_ack => interrupt_ack,
                     sleep => kcpsm6_sleep,
                     reset => kcpsm6_reset,
                       clk => clk);

	interrupt <= interrupt_ack;
    kcpsm6_sleep <= '0';

-- Instanca programske memorije
  	program_rom: program
    generic map(             C_FAMILY => "V6",
                    C_RAM_SIZE_KWORDS => 2,
                 C_JTAG_LOADER_ENABLE => 1)
    port map(      address => address,      
               instruction => instruction,
                    enable => bram_enable,
                       rdl => kcpsm6_reset,
                       clk => clk);

-- Instanca movavg4
    moving_average : movavg4
	port map (
	         clk => clk_n,
	         rst => rst,
	     port_id => port_id,
	     in_port => out_port,
	write_strobe => write_strobe,
	    out_port => ma4_in_port,
	 read_strobe => read_strobe);

-- Generiraj signal takta vođenja
    cont_clock : process
	begin
		clk <= '0';
		wait for T/2;
		clk <= '1';
		wait for T/2;
	end process; -- cont_clock

	clk_n <= not clk;

-- Inicijaliziraj movavg4
	rst <= '1', '0' after T/2;

-- Preusmjeri na movavg4
	with port_id select in_port <=
		ma4_in_port when x"00",
		ma4_in_port when x"01",
		ma4_in_port when x"02",
		data_in_port when others;

-- Simuliraj ulazne podatke
	data_input_ports: process(clk)
  	begin
	    if clk'event and clk = '1' then
	      case port_id(7 downto 0) is
	        when "00010000" =>    
	        	if (input_data_counter < 50) then
	        		data_in_port <= test_input_data(input_data_counter);
	        	else
	        		data_in_port <= x"00";
	        	end if;
	        when others =>    data_in_port <= "00000000";  
	      end case;
	    end if;
    end process data_input_ports;

-- Promjeni brojac ulaznih podataka nakon svakog citanja
    idc_inc : process(read_strobe)
    begin
	    if read_strobe'event and read_strobe = '0' then
	    	if (port_id(7 downto 0) = "00010000") then
	    		if (input_data_counter < 50) then
	    			input_data_counter <= input_data_counter + 1;
	    		end if;
	    	end if;
	    end if;
    end process idc_inc;

-- Provijeri izlazne podatke
    output_ports: process(clk)
  	begin
	    if clk'event and clk = '1' then
	      if write_strobe = '1' then
	      	case port_id(7 downto 0) is
		        when "00100000" =>
		        	if (output_data_counter < 47) then
		          		assert (out_port = test_output_data(output_data_counter)) 
		          			report "Test broj " & integer'image(output_data_counter) & " je otkrio gresku! Primljena vrijednost je d" 
		          			& integer'image(to_integer(unsigned(out_port))) & ". Ocekivana vrijednost je d" & integer'image(to_integer(unsigned(test_output_data(output_data_counter)))) & "!" severity FAILURE;
		          	end if;

		       	when "00110000" => -- avg
		        	assert (input_data_counter = 50) report "Poslali ste prosjecnu vrijednost svih ulaznih podataka prije nego sto ste ucitali sve podatke!" severity FAILURE;
		        	assert (output_data_counter = 47) report "Poslali ste prosjecnu vrijednost svih ulaznih podataka prije nego sto ste izracunali sve vrijednosti pomicnog prosjeka!" severity FAILURE;
		        	assert (out_port = x"84") report "Poslana srednja vrijednost: d" & integer'image(to_integer(unsigned(out_port))) & ", ocekivana srednja vrijednost je d132!" severity FAILURE;
		        	avg_flag <= true;

		    	when "01000000" => -- min
					assert (input_data_counter = 50) report "Poslali ste minimalnu vrijednost u ulaznom nizu podataka prije nego sto ste ucitali sve podatke!" severity FAILURE;
		        	assert (output_data_counter = 47) report "Poslali ste minimalnu vrijednost u ulaznom nizu podataka prije nego sto ste izracunali sve vrijednosti pomicnog prosjeka!" severity FAILURE;
		        	assert (out_port = x"05") report "Poslana minimalna vrijednost: d" & integer'image(to_integer(unsigned(out_port))) & ", ocekivana minimalna vrijednost je d5!" severity FAILURE;
		        	min_flag <= true;

		    	when "01010000" => -- max
					assert (input_data_counter = 50) report "Poslali ste maksimalnu vrijednost u ulaznom nizu podataka prije nego sto ste ucitali sve podatke!" severity FAILURE;
		        	assert (output_data_counter = 47) report "Poslali ste maksimalnu vrijednost u ulaznom nizu podataka prije nego sto ste izracunali sve vrijednosti pomicnog prosjeka!" severity FAILURE;
		        	assert (out_port = x"ff") report "Poslana maksimalna vrijednost: d" & integer'image(to_integer(unsigned(out_port))) & ", ocekivana maksimalna vrijednost je d255!" severity FAILURE;
		        	max_flag <= true;

		        when others =>

	        end case;
	      end if;

	      if (avg_flag = true and min_flag = true and max_flag = true) then
	      	report "Svi testovi su uspjesno zavrsili!" severity NOTE;
		    std.env.finish;
	      end if;
	    end if; 
  	end process output_ports;

-- Promijeni brojac izlaznih podataka nakon svakog pisanja
	odc_inc : process(write_strobe)
	begin
		if write_strobe'event and write_strobe = '0' then
			if (port_id(7 downto 0) = "00100000") then
	    		if (output_data_counter < 47) then
	    			output_data_counter <= output_data_counter + 1;
	    		end if;
			end if;
		end if;
	end process;
	
end architecture simulate;
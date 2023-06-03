library ieee;
use ieee.std_logic_1164.all;

entity testbench_movavg4 is
end entity ; -- testbench_movavg4

architecture simulate of testbench_movavg4 is

type test_vector is record
	port_id, in_port, out_port : std_logic_vector(7 downto 0);
	write_strobe, read_strobe : std_logic;
end record;

type test_vector_array is array (natural range <>) of test_vector;
constant test_vectors : test_vector_array := (
		-- port_id, in_port, out_port, write_strobe, read_strobe
		(x"00", x"02", "--------", '1', '0'),
		(x"01", x"00", x"00", '0', '1'),
		(x"00", x"04", "--------", '1', '0'),
		(x"01", x"00", x"00", '0', '1'),
		(x"00", x"06", "--------", '1', '0'),
		(x"01", x"00", x"00", '0', '1'),
		(x"00", x"08", "--------", '1', '0'),
		(x"01", x"00", x"05", '0', '1'),
		(x"00", x"0A", "--------", '1', '0'),
		(x"01", x"00", x"07", '0', '1'),
		(x"02", x"00", "--------", '1', '0'),
		(x"01", x"00", x"00", '0', '1'),
		(x"00", x"FF", "--------", '1', '0'),
		(x"00", x"FF", "--------", '1', '0'),
		(x"00", x"FF", "--------", '1', '0'),
		(x"00", x"FF", "--------", '1', '0'),
		(x"01", x"00", x"FF", '0', '1'),
		(x"00", x"00", "--------", '0', '0')
	);

constant T : time := 20 ns;

component movavg4 is
	port (
		clk : in std_logic;
		rst : in std_logic;
		port_id : in std_logic_vector(7 downto 0);
		in_port : in std_logic_vector(7 downto 0);
		write_strobe : in std_logic;
		out_port : out std_logic_vector(7 downto 0);
		read_strobe : in std_logic
	) ;
end component movavg4;

signal clk : std_logic;
signal rst : std_logic;
signal port_id : std_logic_vector(7 downto 0);
signal in_port : std_logic_vector(7 downto 0);
signal write_strobe : std_logic;
signal out_port : std_logic_vector(7 downto 0);
signal read_strobe : std_logic;

begin

-- Unit Under Test
UUT : movavg4
port map (
	clk => clk,
	rst => rst,
	port_id => port_id,
	in_port => in_port,
	write_strobe => write_strobe,
	out_port => out_port,
	read_strobe => read_strobe ) ;

-- Simuliraj signal takta vođenja
cont_clock : process
begin
	clk <= '0';
	wait for T/2;
	clk <= '1';
	wait for T/2;
end process; -- cont_clock

-- Inicijaliziraj sklop
rst <= '1', '0' after T/2;

stimulus : process
begin
	
	port_id <= x"00";
	write_strobe <= '0';
	read_strobe <= '0';
	in_port <= x"00";

	wait for T;

	-- Simulacijska petlja
	for i in test_vectors'range loop
		port_id <= test_vectors(i).port_id;
		in_port <= test_vectors(i).in_port;
		write_strobe <= test_vectors(i).write_strobe;
		read_strobe <= test_vectors(i).read_strobe;

		wait for T;

		if (test_vectors(i).port_id = x"01") then
			assert (out_port = test_vectors(i).out_port)
			report "test_vector " & integer'image(i) & " failed! "
			severity failure;
		end if;
	end loop ; -- test_loop
	
	wait;
end process; -- stimulus
	
end architecture simulate;
		
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator is
port (
	sel	: in std_logic;
	data_in1	: in std_logic_vector (31 downto 0);
	data_in2	: in std_logic_vector (31 downto 0);
	q		: out std_logic);
end entity;

architecture beh of comparator is

signal data_in1_sign, data_in2_sign : signed (31 downto 0);
signal data_in1_uns, data_in2_uns : unsigned (31 downto 0);
signal w_output: std_logic;
begin

data_in1_sign <= signed(data_in1);
data_in2_sign <= signed(data_in2);
data_in1_uns <= unsigned(data_in1);
data_in2_uns <= unsigned(data_in2);

process(sel,data_in1_sign,data_in2_sign,data_in1_uns, data_in2_uns)
begin
case sel is
	when '1' =>
		if (data_in1_sign >= data_in2_sign) then
			w_output <='1';
		else
			w_output <= '0';
		end if;
	when '0' =>
		if (data_in1_uns < data_in2_uns) then
			w_output <= '1';
		else
			w_output <= '0';
		end if;
	when others =>
		w_output <= '0';
end case;
end process;
q<=w_output;
end beh;

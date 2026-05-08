library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_comparator is
port (
    ctr_comp_op : in std_logic_vector(1 downto 0);       --indicates instruction being executed
    ctr_unsgnd  : in std_logic;                          --tells if values should be considered unsigned or signed (1 -> unsigned)
	data_in1	: in std_logic_vector (31 downto 0);     
	data_in2	: in std_logic_vector (31 downto 0);    
	q		    : out std_logic);                        
end entity;

architecture beh of alu_comparator is

signal data_in1_sign, data_in2_sign : signed (31 downto 0);
signal data_in1_uns, data_in2_uns : unsigned (31 downto 0);
signal w_output: std_logic;
begin

data_in1_sign <= signed(data_in1);
data_in2_sign <= signed(data_in2);
data_in1_uns <= unsigned(data_in1);
data_in2_uns <= unsigned(data_in2);

process(ctr_comp_op,data_in1_sign,data_in2_sign,data_in1_uns, data_in2_uns,ctr_unsgnd)
begin
case ctr_comp_op is
    when "00" =>                                --BEQ
        if(data_in1_sign = data_in2_sign) then
            w_output <= '1';
        else
            w_output <= '0';
        end if;
	when "01" =>                                --BNE
        if(data_in1_sign /= data_in2_sign) then
            w_output <= '1';
        else
            w_output <= '0';
        end if;
    when "10" =>                                --BLT / BLTU /SLT
            
        if ctr_unsgnd = '0' then                 --SLTIU
            if (data_in1_uns < data_in2_uns) then
                w_output <= '1';
            else
                w_output <= '0';
            end if;

        else 
            if (data_in1_sign < data_in2_sign) then
                w_output <= '1';
            else
                w_output <= '0';
            end if;
        end if;

    when "11" =>                                    --BGE / BGEU
        if ctr_unsgnd = '1' then
            if (data_in1_sign >= data_in2_sign) then
                w_output <='1';
            else
                w_output <= '0';
            end if;
        else
            if (data_in1_uns >= data_in2_uns) then
                w_output <= '1';
            else
                w_output <= '0';
            end if;
        end if;
	when others =>
		w_output <= '0';
end case;
end process;

q<=w_output;
end beh;

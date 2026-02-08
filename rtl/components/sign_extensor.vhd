library ieee;
use ieee.std_logic_1164.all;


entity sign_extensor is
    port(
        d_in         : in std_logic_vector(31 downto 0);
        ctr_size     : in std_logic_vector(1 downto 0);
        ctr_sign     : in std_logic;
        offset       : in std_logic_vector(1 downto 0);
        d_out        : out std_logic_vector (31 downto 0)
    );
end entity;

architecture beh of sign_extensor is

    begin   

dout_gen: process(d_in, ctr_size, ctr_sign, offset)
begin
    case ctr_size is
        when "00" =>                    --lb/lbu
            if( ctr_sign = '0') then
                if( offset = "00") then
                    d_out <= (31 downto 8 => '0') & d_in(7 downto 0);
                elsif( offset = "01") then
                    d_out <= (31 downto 8 => '0') & d_in(15 downto 8);
                elsif( offset = "10") then
                    d_out <= (31 downto 8 => '0') & d_in(23 downto 16);
                else
                    d_out <= (31 downto 8 => '0') & d_in(31 downto 24);
                end if;
            else
                if( offset = "00") then
                    d_out <= (31 downto 8 => d_in(7)) & d_in(7 downto 0);
                elsif( offset = "01") then
                    d_out <= (31 downto 8 => d_in(15)) & d_in(15 downto 8); 
                elsif( offset = "10") then
                    d_out <= (31 downto 8 => d_in(23)) & d_in(23 downto 16);
                else 
                    d_out <= (31 downto 8 => d_in(31)) & d_in(31 downto 24);
                end if;
            end if;

        when "01" =>                    --lh/lhu
            if( ctr_sign = '0') then
                if(offset = "00") then
                    d_out <= (31 downto 16 => '0') & d_in(15 downto 0);
                elsif( offset = "10") then
                    d_out <= (31 downto 16 => '0') & d_in(31 downto 16);
					 else 
							d_out <= d_in;
						  
                end if;
            else 
                if( offset = "00") then
                    d_out <= (31 downto 16 => d_in(15)) & d_in(15 downto 0);
                elsif( offset = "10") then
                    d_out <= (31 downto 16 => d_in(31)) & d_in(31 downto 16);
					 else
						  d_out <= d_in;
                end if;
            end if;

        when "10" =>                    --lw
            d_out <= d_in;
	when others =>
		d_out <= d_in;
    end case;
            end process;

end beh;
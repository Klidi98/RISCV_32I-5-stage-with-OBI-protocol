library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tx is
    generic (
       -- Clock 90MHz, Baud 115200 -> 90.000.000 / 115.200 = 781
        BAUD_DIVISOR : integer := 9375 
    );
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        din      : in  std_logic_vector(7 downto 0); 
        wr       : in  std_logic;                    
        busy     : out std_logic;                    
        tx_line  : out std_logic                     
    );
end uart_tx;

architecture behave of uart_tx is

    
    type state_type is (IDLE, START, DATA, STOP);
    signal state : state_type := IDLE;

   
    signal baud_counter : integer range 0 to BAUD_DIVISOR := 0;
    signal baud_tick    : std_logic := '0';

   
    signal shift_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal bit_count : integer range 0 to 7 := 0;
    signal tx_reg    : std_logic := '1'; -- alta a riposo (IDLE)

begin

    tx_line <= tx_reg;


    process(clk, rst)
    begin
        if rst = '1' then
            baud_counter <= 0;
            baud_tick <= '0';
        elsif rising_edge(clk) then
            if baud_counter = BAUD_DIVISOR - 1 then
                baud_counter <= 0;
                baud_tick <= '1';
            else
                baud_counter <= baud_counter + 1;
                baud_tick <= '0';
            end if;
        end if;
    end process;


    process(clk, rst)
    begin
        if rst = '1' then
            state <= IDLE;
            busy <= '0';
            tx_reg <= '1';
            bit_count <= 0;
        elsif rising_edge(clk) then
            case state is

                when IDLE =>
                    busy <= '0';
                    tx_reg <= '1';
                    if wr = '1' then
                        shift_reg <= din; -- Carica il dato
                        busy <= '1';      
                        state <= START;
                    end if;

                when START =>
							busy <= '1';
                    if baud_tick = '1' then
                        tx_reg <= '0'; -- Bit di START
                        state <= DATA;
                        bit_count <= 0;
								
                    end if;

                when DATA =>
							busy <= '1';
                    if baud_tick = '1' then
                        tx_reg <= shift_reg(bit_count); -- Invia bit i-esimo
                        if bit_count = 7 then
                            state <= STOP;
                        else
                            bit_count <= bit_count + 1;
                        end if;
                    end if;

                when STOP =>
							busy <= '1';
                    if baud_tick = '1' then
                        tx_reg <= '1'; -- Bit di STOP
                        state <= IDLE;
                    end if;

                when others =>
                    state <= IDLE;
            end case;
        end if;
    end process;

end behave;
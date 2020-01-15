----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.02.2019 15:26:07
-- Design Name: 
-- Module Name: uart - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart is
    port (
        clk         : in STD_LOGIC;
        rst         : in STD_LOGIC;
        uart_in     : in STD_LOGIC;
        word_rx     : out STD_LOGIC_VECTOR(9 downto 0);
        new_word_rx : out STD_LOGIC;
        uart_out    : out STD_LOGIC;
        word_tx     : in STD_LOGIC_VECTOR(7 downto 0);
        new_word_tx : in STD_LOGIC
    );
end uart;

architecture Behavioral of uart is
    -- SIGNALS
    type state_type is (IDLE, START_BIT, WAIT_CYCLES_FRONT, WAIT_CYCLES_BACK);
    type state_tx_type is (IDLE, WAIT_CYCLES_FRONT, WAIT_CYCLES_BACK);
    signal state        : state_type;
    signal state_tx     : state_tx_type;
    signal word_rx_uart : std_logic_vector(9 downto 0);
    signal word_tx_uart : std_logic_vector(9 downto 0);
begin
    word_rx <= word_rx_uart;

    -- RX PROTOCOL UART
    process (clk)
        variable bit_counter : integer := 0;
        variable ticks_count : integer := 0;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= IDLE;
                bit_counter := 0;
                ticks_count := 0;
                new_word_rx <= '0';
            else
                new_word_rx <= '0';
                case state is
                    when IDLE =>
                        state <= START_BIT;
                    when START_BIT =>
                        if uart_in = '0' then
                            state <= WAIT_CYCLES_FRONT;
                        end if;
                    when WAIT_CYCLES_FRONT =>
                        ticks_count := ticks_count + 1;
                        if ticks_count = 16 then
                            word_rx_uart(bit_counter) <= uart_in;
                            bit_counter := bit_counter + 1;
                            state <= WAIT_CYCLES_BACK;
                        end if;
                    when WAIT_CYCLES_BACK =>
                        ticks_count := ticks_count + 1;
                        if ticks_count = 32 then
                            ticks_count := 0;
                            state <= WAIT_CYCLES_FRONT;
                            if bit_counter = 10 then
                                new_word_rx <= '1';
                                bit_counter := 0;
                                state <= START_BIT;
                            end if;
                        end if;
                    when others =>
                        state <= IDLE;
                end case;
            end if;
        end if;
    end process;

    -- TX PROTOCOL UART
    process (clk)
        variable bit_counter : integer := 0;
        variable ticks_count : integer := 0;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state_tx <= IDLE;
                bit_counter := 0;
                ticks_count := 0;
                uart_out <= '1';
            else
                case state_tx is
                    when IDLE =>
                        uart_out <= '1';
                        if new_word_tx = '1' then
                            state_tx     <= WAIT_CYCLES_FRONT;
                            word_tx_uart <= '1' & word_tx & '0';
                        end if;
                    when WAIT_CYCLES_FRONT =>
                        ticks_count := ticks_count + 1;
                        if ticks_count = 16 then
                            uart_out <= word_tx_uart(bit_counter);
                            bit_counter := bit_counter + 1;
                            state_tx <= WAIT_CYCLES_BACK;
                        end if;
                    when WAIT_CYCLES_BACK =>
                        ticks_count := ticks_count + 1;
                        if ticks_count = 31 then
                            ticks_count := 0;
                            state_tx <= WAIT_CYCLES_FRONT;
                            if bit_counter = 10 then
                                bit_counter := 0;
                                state_tx <= IDLE;
                            end if;
                        end if;
                    when others =>
                        state_tx <= IDLE;
                end case;
            end if;
        end if;
    end process;

end Behavioral;
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.01.2019 12:00:57
-- Design Name: 
-- Module Name: top - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port (
        CLK100MHZ : in STD_LOGIC; 
        sw : in STD_LOGIC_VECTOR(3 downto 0);
        led : out STD_LOGIC_VECTOR(1 downto 0);
        uart_txd_in : in STD_LOGIC;
        uart_rxd_out : out STD_LOGIC
           );
end top;

architecture Behavioral of top is
-- COMPONENTS
    COMPONENT heartbeat is
        Port ( clk : in STD_LOGIC;
               led : out STD_LOGIC);
    END COMPONENT;
    COMPONENT uart is
		Port (  clk : in STD_LOGIC;
			    rst : in STD_LOGIC;
			    uart_in : in STD_LOGIC;
				word_rx : out STD_LOGIC_VECTOR(9 downto 0);
				new_word_rx : out STD_LOGIC;
				uart_out : out STD_LOGIC;
				word_tx : in STD_LOGIC_VECTOR(7 downto 0);
				new_word_tx : in STD_LOGIC);
    END COMPONENT;
    COMPONENT clock_gen is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               clk_uart : out STD_LOGIC);
    END COMPONENT;
-- SIGNALS
    signal word_rx : std_logic_vector(9 downto 0) := "00" & x"00";
    signal word_tx : std_logic_vector(7 downto 0) := x"00";
    signal uart_baudrate : std_logic := '0';
	signal new_word_rx : std_logic := '0';
	signal new_word_tx : std_logic := '0';
begin

    led(0) <= sw(0);
    
    heartbeat_inst : heartbeat 
    Port map ( 
        clk => CLK100MHZ,
        led => led(1)
        );
    
    clock_gen_inst : clock_gen 
    Port Map( 
        clk  => CLK100MHZ,
        rst => sw(1),
        clk_uart => uart_baudrate
        );
    
	process(uart_baudrate)
	begin
		if rising_edge(uart_baudrate) then
			new_word_tx <= new_word_rx;
			word_tx <= word_rx(8 downto 1);
		end if;
	end process;
	
    uart_inst : uart
    Port map(
        clk => uart_baudrate,
        rst => sw(1),
        uart_in => uart_txd_in,
        word_rx => word_rx,
        new_word_rx => new_word_rx,
        uart_out => uart_rxd_out,
        word_tx => word_tx,
        new_word_tx => new_word_tx
		
    );

end Behavioral;

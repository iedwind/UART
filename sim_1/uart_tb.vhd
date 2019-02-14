----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.02.2019 15:35:16
-- Design Name: 
-- Module Name: uart_tb - Behavioral
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

entity uart_tb is
--  Port ( );
end uart_tb;

architecture Behavioral of uart_tb is
-- CONSTANTS
constant clk100Mhz_period : time := 10 ns;
constant clk115_period : time := 8.68 us;
    -- COMPONENTS
    COMPONENT clock_gen is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk_uart : out STD_LOGIC);
    END COMPONENT;
    component uart is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               uart_in : in STD_LOGIC;
               word_rx : out STD_LOGIC_VECTOR(9 downto 0);
               new_word_rx : out STD_LOGIC;
               uart_out : out STD_LOGIC;
               word_tx : in STD_LOGIC_VECTOR(7 downto 0);
               new_word_tx : in STD_LOGIC);
    end component;
    -- SIGNALS
    signal rst : std_logic := '0';
    signal clk : std_logic := '0';
    signal clk_uart_sim : std_logic := '0';
    signal clk_uart : std_logic := '0';
    signal new_word : std_logic := '0';
    signal uart_in : std_logic := '1';
    signal uart_out : std_logic := '1';
    signal word_tx : std_logic_vector(9 downto 0) := '0'&x"AA"&'1';
    signal word : std_logic_vector(9 downto 0) := (others=> '0');
begin
    clk <= not clk after clk100Mhz_period/2;
    clk_uart_sim <= not clk_uart_sim after clk115_period/2;
    
    process(clk_uart_sim)
        variable bit_count : integer:= 0;
    begin
        if rising_edge(clk_uart_sim) then
            uart_in <= '1';
            if bit_count >= 0 and bit_count <= 9 then
                uart_in <= word_tx(9-bit_count);
            end if;
            if bit_count = 100 then
                bit_count := 0;
            end if;
            bit_count := bit_count + 1;          
        end if;
    end process;
    -- DUTs
    clock_gen_inst : clock_gen 
    Port Map( 
        clk  => clk,
        rst =>'0',
        clk_uart => clk_uart
        );
    uart_inst: uart
        Port Map(
            clk => clk_uart,
            rst => '0',
            uart_in => uart_in,
            word_rx => word,
            new_word_rx => new_word,
            uart_out => uart_out,
            word_tx => word(8 downto 1),
            new_word_tx => new_word
        );
end Behavioral;

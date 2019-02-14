----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.02.2019 19:37:38
-- Design Name: 
-- Module Name: clock_gen - Behavioral
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

entity clock_gen is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk_uart : out STD_LOGIC);
end clock_gen;

architecture Behavioral of clock_gen is
    signal uart_bitrate : std_logic := '0';
begin
    clk_uart <= uart_bitrate;
    -- GENERAR CLOCK 115200 KHz
    process(clk)
        variable count: integer := 0;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                uart_bitrate <= '0';
                count := 0;
            else              
                count := count + 1;
                if count = 14 then
                    uart_bitrate <= not uart_bitrate;
                    count := 0;
                end if;        
            end if;
        end if;
    end process;
end Behavioral;

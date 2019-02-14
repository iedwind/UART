----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.01.2019 15:26:37
-- Design Name: 
-- Module Name: heartbeat - Behavioral
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

entity heartbeat is
    Port ( clk : in STD_LOGIC;
           led : out STD_LOGIC);
end heartbeat;

architecture Behavioral of heartbeat is
    signal led_int : std_logic := '0';
begin
    
    led <= led_int;

    process(clk)
        variable counter : integer := 0;
    begin
        if rising_edge(clk) then
            counter := counter + 1;
            if(counter = 100000000) then
                led_int <= not led_int;
                counter := 0;
            end if;
        end if;    
    end process;
end Behavioral;

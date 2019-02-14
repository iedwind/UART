----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.01.2019 15:51:53
-- Design Name: 
-- Module Name: heartbeat_tb - Behavioral
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

entity heartbeat_tb is
--  Port ( );
end heartbeat_tb;

architecture Behavioral of heartbeat_tb is
-- COMPONENTS
COMPONENT heartbeat is
    Port ( clk : in STD_LOGIC;
           led : out STD_LOGIC);
END COMPONENT;
    signal CLK100MHZ : std_logic := '0';
    signal led : std_logic := '0';
    
    constant clk100Mhz_period : time := 10 ns;
begin
    CLK100MHZ <= not CLK100MHZ after clk100Mhz_period/2;
-- DUT
    heartbeat_inst : heartbeat 
    Port map ( 
        clk => CLK100MHZ,
        led => led
        );
        
end Behavioral;

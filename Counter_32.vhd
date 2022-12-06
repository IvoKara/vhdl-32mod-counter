----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:49:59 12/04/2022 
-- Design Name: 
-- Module Name:    Counter_32 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity ccc is
port (
	DIR: in std_logic;
	CLK_MODE: in std_logic;
	CLK_MANUAL: in std_logic;
	CLK_INTERNAL: in std_logic;
	CLR: in std_logic;
	Q: inout std_logic_vector (4 downto 0):= "00000"
);
end ccc;


architecture Behavioral of ccc is
	signal clock: std_logic := '0';
	signal count: std_logic_vector(4 downto 0) := "00000";
begin

	process(CLR, CLK_MANUAL, CLK_MODE, CLK_INTERNAL)
		constant modulus: integer := 100000000; -- because of 100MHz internal clock
		variable clockCount: natural range 0 to modulus-1 := 0;
	begin
		if (CLR = '1') then 
			clockCount := 0;
			clock <= '0';
		elsif(CLK_MODE = '1') then
			if(CLK_INTERNAL'event and CLK_INTERNAL = '1') then
				if clockCount=modulus-1 then
					clockCount := 0;
					clock <= '1';
				else 
					clockCount := clockCount + 1;
					clock <= '0';
				end if;
			end if;
		else
			clock <= CLK_MANUAL;
		end if;
	end process;
	
	process (CLR, clock, DIR)
	begin
		if (CLR = '1') then
			count <= (others=>'0');
		elsif (clock'event and clock = '1') then
			if (DIR = '1') then
				count <= count - '1';
			else
				count <= count + '1';
			end if;
		end if;
	end process;
	
	Q 	<= count;
	
end Behavioral;

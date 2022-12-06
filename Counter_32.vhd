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


entity Counter_32 is
generic(
	BITS: positive := 5; -- 5 bits for MOD-32
	POW_OF_2: positive := 3 -- 2^3 = 32
);
port (
	DIR: in std_logic; -- dircation: '1' upwards, '0' downwards - SW
	
	CLK_MODE: in std_logic; -- clock mode: '1' automatic, '0' manual - SW
	CLK_MANUAL: in std_logic; -- clock signal, fired by hand - BTN
	CLK_INTERNAL: in std_logic; -- 100Mhz generator from board
	
	CLR: in std_logic; -- async reset signal - BTN
	
	MOD_BIT_0: in std_logic; -- LSB for module number - SW 
	MOD_BIT_1: in std_logic; -- second bit for module number - SW
	MOD_BIT_2: in std_logic; -- third bit for module number - SW
	MOD_BIT_3: in std_logic; -- forth bit for module number - SW
	MOD_BIT_4: in std_logic; -- MSB for module number  - SW
	
	Q: inout std_logic_vector (BITS-1 downto 0):= (others => '0') -- output
);
end Counter_32;


architecture Behavioral of Counter_32 is
	signal clock: std_logic := '0';
	signal count: std_logic_vector(BITS-1 downto 0):= (others => '0');
	signal maxCount: std_logic_vector(BITS-1 downto 0):= (others => '1');
begin

	process(CLR, CLK_MANUAL, CLK_MODE, CLK_INTERNAL)
		constant clockModulus: integer := 100000000; -- because of 100MHz internal clock
		variable clockCount: natural range 0 to clockModulus-1 := 0;
	begin
		if (CLR = '1') then 
			clockCount := 0;
			clock <= '0';
		elsif(CLK_MODE = '1') then
			if(CLK_INTERNAL'event and CLK_INTERNAL = '1') then
				if (clockCount = clockModulus - 1) then
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
	
	process (MOD_BIT_0, MOD_BIT_1, MOD_BIT_2, MOD_BIT_3, MOD_BIT_4)
	begin
		maxCount <= MOD_BIT_4 & 
					MOD_BIT_3 & 
					MOD_BIT_2 & 
					MOD_BIT_1 & 
					MOD_BIT_0;
	end process;
	
	process (CLR, DIR, clock, maxCount)
	begin
		if (CLR = '1') then
			count <= (others => '0');
		elsif (clock'event and clock = '1') then
			if (DIR = '1') then
				if (count = "00000" or count > maxCount) then
					count <= maxCount;
				else
					count <= count - '1';
				end if;
			else
				if (count >= maxCount) then
					count <= (others => '0');
				else
					count <= count + '1';
				end if;
			end if;
		end if;
	end process;
	
	Q <= count;
	
end Behavioral;

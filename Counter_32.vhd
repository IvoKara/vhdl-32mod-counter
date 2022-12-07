----------------------------------------------------------------------------------
-- Engineer: Ivo Karaneshev
-- 
-- Create Date:    19:49:59 12/04/2022 
-- Module Name:    Counter_32 - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Counter_32 is
generic(
	BITS: positive := 5 -- 5 bits for MOD-32
);
port (
	DIR: in std_logic; -- dircation: '0' upwards, '1' downwards - SW
	
	CLK_MODE: in std_logic; -- clock mode: '1' automatic, '0' manual - SW
	CLK_MANUAL: in std_logic; -- clock signal, fired by hand - BTN
	CLK_INTERNAL: in std_logic; -- 100Mhz generator from board
	
	CLR: in std_logic; -- async reset signal - BTN
	
	MAX_COUNT: in std_logic_vector (BITS-1 downto 0); -- vector module number - 5xSW 
	
	Q: inout std_logic_vector (BITS-1 downto 0):= (others => '0') -- output
);
end Counter_32;


architecture Behavioral of Counter_32 is
	signal clock: std_logic := '0'; -- this module's clock
	signal count: std_logic_vector(BITS-1 downto 0):= (others => '0');
begin

	process(CLR, CLK_MANUAL, CLK_MODE, CLK_INTERNAL)
		constant clockModulus: integer := 100000000; -- because of 100MHz internal clock
		variable clockCount: natural range 0 to clockModulus-1 := 0; -- used to generate clock with period 1 sec
	begin
		if (CLR = '1') then -- on async reset
			clockCount := 0;
			clock <= '0';
		elsif(CLK_MODE = '1') then -- if mode is automatic
			if(CLK_INTERNAL'event and CLK_INTERNAL = '1') then -- check for rising edge of the internal clock
				if (clockCount = clockModulus - 1) then -- if 1 sec has passed
					clockCount := 0;
					clock <= '1'; -- generate rising edge of the module's clock
				else 
					clockCount := clockCount + 1;
					clock <= '0'; -- generate lowering edge of the module's clock
				end if;
			end if;
		else
			clock <= CLK_MANUAL; -- manual clock by BTN
		end if;
	end process;
	
	process (clock, CLR, DIR, MAX_COUNT)
	begin
		if (CLR = '1') then
			 -- reset count value on async reset signal
			count <= (others => '0');
		elsif (clock'event and clock = '1') then -- if rising adge of module's counter
			if (DIR = '1') then -- if direction is downwards
				if (count = "00000" or count > MAX_COUNT) then
					-- if the current counting value is equal to 0 (minimum counting value)
					-- the count value will be set to be equal to the maximum value
					-- or if the current counting value is greater than the maximum
					-- i.e. the count value is 10 but the maximum value has been changed to 5
					-- then the count value is going to be 5
					count <= MAX_COUNT;
				else
					count <= count - '1';
				end if;
			else  -- if direction is upwards
				if (count > MAX_COUNT) then 
					-- if the current counting value is greater maximum
					-- i.e. it will count up from 0 to MAX_COUNT 
					-- even if the count value is greater than the maximum value that was recently changed
					-- the count value is going to be resetted
					count <= (others => '0');
				else
					count <= count + '1';
				end if;
			end if;
		end if;
	end process;
	
	Q <= count; -- output the current count value
	
end Behavioral;
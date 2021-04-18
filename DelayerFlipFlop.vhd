----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:31:41 07/17/2020 
-- Design Name: 
-- Module Name:    DelayerFlipFlop - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DelayerFlipFlop is
    Port ( d : in  STD_LOGIC_VECTOR (25 downto 0);
           q : out  STD_LOGIC_VECTOR (25 downto 0);
           clk : in  STD_LOGIC;
           en : in  STD_LOGIC);
end DelayerFlipFlop;

architecture Behavioral of DelayerFlipFlop is
signal temp : std_logic_vector (25 downto 0) := (others => '0');
begin
	process (clk)
	begin
	if rising_edge(clk) then
		if (en = '1') then
			temp <= d;
		end if;
	end if;
	end process;
	
	q <= temp;
end Behavioral;


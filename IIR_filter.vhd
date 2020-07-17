----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    03:37:46 07/17/2020 
-- Design Name: 
-- Module Name:    IIR_filter - Behavioral 
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
--use ieee.std_logic_arith.all;
--use IEEE.Std_logic_signed.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IIR_filter is
	 Generic ( input_width : integer := 8;
				  coef_width : integer := 9);
    Port ( din : in  SIGNED (input_width-1 downto 0);
           dout : out  SIGNED ((input_width+coef_width+4)-1 downto 0);
           clk : in  STD_LOGIC;
           en : in  STD_LOGIC;
           reset : in  STD_LOGIC);
end IIR_filter;

architecture Behavioral of IIR_filter is 

type Accumulator_type is array (0 to 10) of signed ((input_width+coef_width+4)-1 downto 0);
signal accumulator : Accumulator_type := (others=>(others=>'0'));

type register_out_type is array (1 to 10) of signed ((input_width+coef_width+4)-1 downto 0);
signal register_out : register_out_type := (others=>(others=>'0'));

type a_coefficients is array (1 to 10) of integer;
signal a_coef : a_coefficients := ((-9), (-42), (-109), (-185),
											  (-216), (-174), (-96), (-35),
											  (-8), (-1));
type b_coefficients is array (0 to 10) of integer;
signal b_coef : b_coefficients := ((1), (10),(45), (120),
											  (210), (252), (210), (120), 
											  (45), (10), (1));

Component DelayerFlipFlop
	Generic ( size : integer := 20);
   Port ( d : in  SIGNED (size-1 downto 0);
          q : out  SIGNED (size-1 downto 0);
          clk : in  STD_LOGIC;
          en : in  STD_LOGIC);
end Component;

begin
--	generate_units: for i in 1 to 10 generate
--		DFF_u : DelayerFlipFlop generic map (size => (input_width+coef_width+4))
--				port map (d => accumulator(11-i),
--							 q => register_out(11-i),
--							 clk => clk,
--							 en => en);
--	end generate;
	
	process (clk)
	begin
	if en = '1' then
		if rising_edge(clk) then
			if reset = '1' then
				accumulator <= (others=>(others=>'0'));
			else
				accumulator(0) <= to_signed(b_coef(0), coef_width) * din + accumulator(1);
				accumulator(1) <= to_signed(b_coef(1), coef_width) * din + to_signed(a_coef(1), coef_width) * accumulator(0) + accumulator(2);
				accumulator(2) <= to_signed(b_coef(2), coef_width) * din + to_signed(a_coef(2), coef_width) * accumulator(0) + accumulator(3);
				accumulator(3) <= to_signed(b_coef(3), coef_width) * din + to_signed(a_coef(3), coef_width) * accumulator(0) + accumulator(4);
				accumulator(4) <= to_signed(b_coef(4), coef_width) * din + to_signed(a_coef(4), coef_width) * accumulator(0) + accumulator(5);
				accumulator(5) <= to_signed(b_coef(5), coef_width) * din + to_signed(a_coef(5), coef_width) * accumulator(0) + accumulator(6);
				accumulator(6) <= to_signed(b_coef(6), coef_width) * din + to_signed(a_coef(6), coef_width) * accumulator(0) + accumulator(7);
				accumulator(7) <= to_signed(b_coef(7), coef_width) * din + to_signed(a_coef(7), coef_width) * accumulator(0) + accumulator(8);
				accumulator(8) <= to_signed(b_coef(8), coef_width) * din + to_signed(a_coef(8), coef_width) * accumulator(0) + accumulator(9);
				accumulator(9) <= to_signed(b_coef(9), coef_width) * din + to_signed(a_coef(9), coef_width) * accumulator(0) + accumulator(10);
				accumulator(10) <= to_signed(b_coef(10), coef_width) * din + to_signed(a_coef(10), coef_width) * accumulator(0);
			end if;
		end if;
	end if;
	end process;
	
	dout <= accumulator(0);
	
	
	
	
	

end Behavioral;


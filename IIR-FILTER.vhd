----------------------------------------------------------------------------------
-- Module Name:    IIR_filter - Behavioral 
-- Project Name:   fpga_final
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.Std_logic_signed.all;

entity IIR_filter is
    Port ( din : in  STD_LOGIC_VECTOR (9 downto 0);
           dout : out  STD_LOGIC_VECTOR (25 downto 0);
           clk : in  STD_LOGIC;
           en : in  STD_LOGIC;
           reset : in  STD_LOGIC);
end IIR_filter;

architecture Behavioral of IIR_filter is

type Accumulator_type is array (0 to 10) of std_logic_vector (25 downto 0);
signal accumulator : Accumulator_type := (others=>(others=>'0'));

type register_out_type is array (0 to 10) of std_logic_vector (25 downto 0);
signal register_out : register_out_type := (others=>(others=>'0'));

type a_coefficients is array (1 to 10) of std_logic_vector (11 downto 0);
type b_coefficients is array (0 to 10) of std_logic_vector (11 downto 0);

signal acc0 : std_logic_vector (25 downto 0) := (others=>'0');

type b_multipliers is array (0 to 10) of std_logic_vector (21 downto 0);
type a_multipliers is array (1 to 10) of std_logic_vector (21 downto 0);

signal a_mul : a_multipliers := (others=>(others=>'0'));
signal b_mul : b_multipliers := (others=>(others=>'0'));

signal a_coef : a_coefficients := (std_logic_vector(to_signed(1000, 12)),
											  std_logic_vector(to_signed(-996, 12)),
											  std_logic_vector(to_signed(1759, 12)),
											  std_logic_vector(to_signed(-1112, 12)),
											  std_logic_vector(to_signed(847, 12)),
											  std_logic_vector(to_signed(-347, 12)),
											  std_logic_vector(to_signed(144, 12)),
											  std_logic_vector(to_signed(-33, 12)),
											  std_logic_vector(to_signed(6, 12)),
											  std_logic_vector(to_signed(0, 12)));
											  
signal b_coef : b_coefficients := (std_logic_vector(to_signed(1, 12)),
											  std_logic_vector(to_signed(12, 12)),
											  std_logic_vector(to_signed(56, 12)),
											  std_logic_vector(to_signed(151, 12)),
											  std_logic_vector(to_signed(265, 12)),
											  std_logic_vector(to_signed(118, 12)),
											  std_logic_vector(to_signed(265, 12)),
											  std_logic_vector(to_signed(151, 12)),
											  std_logic_vector(to_signed(56, 12)),
											  std_logic_vector(to_signed(12, 12)),
											  std_logic_vector(to_signed(1, 12)));

Component DelayerFlipFlop
   Port ( d : in  STD_LOGIC_VECTOR (25 downto 0);
          q : out  STD_LOGIC_VECTOR (25 downto 0);
          clk : in  STD_LOGIC;
          en : in  STD_LOGIC);
end Component;

Component Multiplier
   Port ( in_1 : in  STD_LOGIC_VECTOR (9 downto 0);
          in_2 : in  STD_LOGIC_VECTOR (11 downto 0);
          output : out  STD_LOGIC_VECTOR (21 downto 0);
          en : in  STD_LOGIC);
end Component;

begin
	generate_register_units: for i in 0 to 10 generate
		REG_u : DelayerFlipFlop
				port map (d => accumulator(i),
							 q => register_out(i),
							 clk => clk,
							 en => en);
	end generate;
	
	generate_b_multiplier_units: for i in 0 to 10 generate
		MUL_B_u : Multiplier
				port map (in_2 => b_coef(i),
							 in_1 => din,
							 output => b_mul(i),
							 en => en);
	end generate;

	generate_a_multiplier_units: for j in 1 to 10 generate
		MUL_A_u : Multiplier
				port map (in_2 => a_coef(j),
							 in_1 => acc0 (9 downto 0),
							 output => a_mul(j),
							 en => en);
	end generate;


	acc0 <= b_mul(0) + register_out(1);
	accumulator(10) <= b_mul(10) + a_mul(10) + register_out(0);
	accumulator(9) <= b_mul(9) + a_mul(9) + register_out(10);
	accumulator(8) <= b_mul(8) + a_mul(8) + register_out(9);
	accumulator(7) <= b_mul(7) + a_mul(7) + register_out(8);
	accumulator(6) <= b_mul(6) + a_mul(6) + register_out(7);
	accumulator(5) <= b_mul(5) + a_mul(5) + register_out(6);
	accumulator(4) <= b_mul(4) + a_mul(4) + register_out(5);
	accumulator(3) <= b_mul(3) + a_mul(3) + register_out(4);
	accumulator(2) <= b_mul(2) + a_mul(2) + register_out(3);
	accumulator(1) <= b_mul(1) + a_mul(1) + register_out(2);
	
	dout <= acc0;
	
end Behavioral;


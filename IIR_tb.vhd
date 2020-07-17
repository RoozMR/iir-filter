--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:30:04 07/17/2020
-- Design Name:   
-- Module Name:   C:/ise projects/fpga_final/IIR_tb.vhd
-- Project Name:  fpga_final
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: IIR_filter
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
Use STD.TEXTIO.all;

ENTITY IIR_tb IS
END IIR_tb;
 
ARCHITECTURE behavior OF IIR_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT IIR_filter
    Generic ( input_width : integer := 8;
				  coef_width : integer := 9);
	 PORT(
         din : IN  signed(input_width-1 downto 0);
         dout : OUT  signed((input_width+coef_width+4)-1 downto 0);
         clk : IN  std_logic;
         en : IN  std_logic;
         reset : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal din : signed(9 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal en : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal dout : signed(22 downto 0);
	
	signal output_ready : std_logic := '0';
	file my_input : TEXT open READ_MODE is "input.txt";  
	file my_output : TEXT open WRITE_MODE is "output.txt";
	
   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: IIR_filter GENERIC MAP (input_width => 10, coef_width => 9) PORT MAP (
          din => din,
          dout => dout,
          clk => clk,
          en => en,
          reset => reset
        );

   -- Clock definitions
	clk <= not(clk) after clk_period/2;
 
	read_process: process(clk)  
	variable input_line : LINE;  
	variable input: integer;  
	begin  
		if reset ='1' then  
			din <= (others=> '0');  
			output_ready <= '0';  
		elsif rising_edge(clk) then                      
			readline(my_input, input_line);  
			read(input_line,input);  
			din <= to_signed(input, 9);  
			output_ready <= '1';  
		end if;  
	end process;
	
	write_process: process(clk)  
	variable output_line : LINE;
	begin  
		if falling_edge(clk) then  
			if output_ready ='1' then  
				write(output_line, to_integer(dout));  
				writeline(my_output,output_line);  
			end if;
		end if;
	end process;
 
   -- Stimulus process
   stim_proc: process
   begin		
      en <= '1';
		
      wait;
   end process;

END;

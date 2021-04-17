--------------------------------------------------------------------------------
-- Module Name:   IIR_tb.vhd
-- Project Name:  fpga_final
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
Use STD.TEXTIO.all;

ENTITY IIR_tb IS
END IIR_tb;
 
ARCHITECTURE behavior OF IIR_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT) 
    COMPONENT IIR_filter
	 PORT(
         din : IN  STD_LOGIC_VECTOR(9 downto 0);
         dout : OUT  STD_LOGIC_VECTOR(25 downto 0);
         clk : IN  std_logic;
         en : IN  std_logic;
         reset : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal din : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal en : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal dout : STD_LOGIC_VECTOR(25 downto 0);
	
	signal output_ready : std_logic := '0';
	file my_input : TEXT open READ_MODE is "input.txt";  
	file my_output : TEXT open WRITE_MODE is "output.txt";
	
   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: IIR_filter
	PORT MAP (
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
			din <= std_logic_vector(to_signed(input, 10));  
			output_ready <= '1';  
		end if;  
	end process;
	
	write_process: process(clk)  
	variable output_line : LINE;
	begin  
		if rising_edge(clk) then  
			if output_ready ='1' then  
				write(output_line, to_integer(signed(dout)));  
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

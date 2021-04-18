----------------------------------------------------------------------------------
-- Module Name:    Multiplier - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.Std_logic_signed.all;

entity Multiplier is
    Port ( in_1 : in  STD_LOGIC_VECTOR (9 downto 0);
           in_2 : in  STD_LOGIC_VECTOR (11 downto 0);
           output : out  STD_LOGIC_VECTOR (21 downto 0);
           en : in  STD_LOGIC);
end Multiplier;

architecture Behavioral of Multiplier is
signal result : std_logic_vector (21 downto 0) := (others => '0');
begin
result <= in_1 * in_2;

output <= result when en = '1' else (others => '0');

end Behavioral;


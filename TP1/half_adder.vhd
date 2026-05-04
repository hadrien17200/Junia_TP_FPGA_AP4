library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- DESCRIPTION DES ENTREES/SORTIES DE L'ENTITY
entity half_adder is
	port (
		A : in std_logic;
		B : in std_logic;
        S : out std_logic;
        C : out std_logic
	);
end half_adder;

-- DESCRIPTION COMPORTEMENTALE DE L'ENTITY
architecture behavioral of half_adder is

begin
    
    S <= A xor B; -- La somme est obtenue par un OU exclusif
    C <= A and B; -- La retenue est obtenue par un ET  
end behavioral;
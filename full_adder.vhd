library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- DESCRIPTION DES ENTREES/SORTIES DE L'ENTITY
entity full_adder is
	port (
		A : in std_logic;
		B : in std_logic;
        Cin : in std_logic;
        S : out std_logic;
        Cout : out std_logic
	);
end full_adder;

-- DESCRIPTION COMPORTEMENTALE DE L'ENTITY
architecture behavioral of full_adder is

signal R_ab : std_logic;
signal R_ABC : std_logic;
signal S_ab : std_logic;


begin
    C <= R_ab OR R_ABC; -- La retenue finale est obtenue par un OU des deux retenues intermédiaires

   instance_half_adder1 : entity work.priority.half_adder port map(
    A => A,
    B => B,
    C => R_ab,
    S => S_ab

   );
   instance_half_adder2 : entity work.priority.half_adder port map(
    A => R_ab,
    B => Cin,
    S => S,
    Cout => R_ABC
   );
   
end behavioral;
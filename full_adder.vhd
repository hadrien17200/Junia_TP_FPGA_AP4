library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- DESCRIPTION DES ENTREES/SORTIES DE L'ENTITY
entity full_adder is
    port (
        A    : in  std_logic;
        B    : in  std_logic;
        Cin  : in  std_logic;
        S    : out std_logic;
        Cout : out std_logic
    );
end full_adder;

-- DESCRIPTION COMPORTEMENTALE DE L'ENTITY
architecture behavioral of full_adder is
    
    --Un demi-additionneur additionne 2 bits. Pour additionner 3 bits (A, B, et une retenue entrante Cin), on en chaîne deux :

    --Half Adder 1 additionne A et B → donne une somme intermédiaire et une retenue intermédiaire
    --Half Adder 2 additionne la somme intermédiaire avec Cin → donne la somme finale et une deuxième retenue intermédiaire
    --Une porte OR combine les deux retenues intermédiaires → donne la retenue finale Cout
    
    signal R_ab  : std_logic;
    signal R_ABC : std_logic;
    signal S_ab  : std_logic;
begin
    Cout <= R_ab OR R_ABC;

    instance_half_adder1 : entity work.half_adder port map(
        A => A,
        B => B,
        S => S_ab,
        C => R_ab
    );

    instance_half_adder2 : entity work.half_adder port map(
        A => S_ab,
        B => Cin,
        S => S,
        C => R_ABC
    );

end architecture;
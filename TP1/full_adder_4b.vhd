library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Additionneur à retenue propagée 4 bits :
-- Principe : Un additionneur à retenue propagée est construit en chaînant N additionneurs complets (Full Adder) en série.
-- Chaque Full Adder calcule un bit de la somme et propage sa retenue sortante (Cout) vers l'entrée (Cin) du suivant.
-- Limitation : la retenue doit se propager en série à travers tous les étages, donc plus le vecteur est grand, plus c'est lent.

-- DESCRIPTION DES ENTREES/SORTIES DE L'ENTITY
entity full_adder_4b is
    port (
        A    : in  std_logic_vector(3 downto 0);  
        B    : in  std_logic_vector(3 downto 0);  
        Cin  : in  std_logic;                     
        S    : out std_logic_vector(3 downto 0);  
        Cout : out std_logic                      
    );
end full_adder_4b;

-- DESCRIPTION COMPORTEMENTALE DE L'ENTITY
architecture behavioral of full_adder_4b is

    -- Retenues intermédiaires entre les additionneurs complets
    signal C : std_logic_vector(3 downto 1);

begin

    -- Étage 0 : bit le moins significatif (LSB)
    -- Reçoit la retenue initiale Cin (souvent '0')
    FA0 : entity work.full_adder port map(
        A    => A(0),   
        B    => B(0),   
        Cin  => Cin,    
        S    => S(0),   
        Cout => C(1)    
    );

    -- Étage 1 : reçoit la retenue propagée de FA0
    FA1 : entity work.full_adder port map(
        A    => A(1),   
        B    => B(1),   
        Cin  => C(1),   
        S    => S(1),   
        Cout => C(2)    
    );

    -- Étage 2 : reçoit la retenue propagée de FA1
    FA2 : entity work.full_adder port map(
        A    => A(2),   
        B    => B(2),   
        Cin  => C(2),   
        S    => S(2),   
        Cout => C(3)    
    );

    -- Étage 3 : bit le plus significatif (MSB)
    -- Sa retenue sortante est le Cout final du vecteur
    FA3 : entity work.full_adder port map(
        A    => A(3),   
        B    => B(3),   
        Cin  => C(3),   
        S    => S(3),   
        Cout => Cout    
    );

end architecture;
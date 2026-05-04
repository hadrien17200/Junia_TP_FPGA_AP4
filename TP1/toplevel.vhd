library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity toplevel is
    port (
        HEX3 : out std_logic_vector(6 downto 0);
        HEX2 : out std_logic_vector(6 downto 0);
        HEX0 : out std_logic_vector(6 downto 0);
        SW   : in  std_logic_vector(9 downto 0)
    );
end entity;

architecture behavioral of toplevel is

    -- Signaux internes pour connecter SW à l'additionneur
    signal A   : std_logic_vector(3 downto 0);
    signal B   : std_logic_vector(3 downto 0);
    signal Cin : std_logic;
    signal S   : std_logic_vector(3 downto 0);
    signal Cout: std_logic;

begin

    -- Mapping des switches vers les entrées de l'additionneur
    A   <= SW(3 downto 0);   
    B   <= SW(7 downto 4);   
    Cin <= SW(8);             

    -- Instanciation de l'additionneur 4 bits
    adder : entity work.adder_4bit port map(
        A    => A,
        B    => B,
        Cin  => Cin,
        S    => S,
        Cout => Cout
    );

    -- Transcodeur pour A → HEX2
    transcoder_a : entity work.transcodeur_7seg port map(
        BIN => A,
        SEG => HEX2
    );

    -- Transcodeur pour B → HEX0
    transcoder_b : entity work.transcodeur_7seg port map(
        BIN => B,
        SEG => HEX0
    );

    -- Transcodeur pour S (résultat) → HEX3
    transcoder_s : entity work.transcodeur_7seg port map(
        BIN => S,
        SEG => HEX3
    );

end architecture;
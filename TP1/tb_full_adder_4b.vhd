library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- DECLARATION D'UNE ENTITE
entity tb_full_adder_4b is
end tb_full_adder_4b;

architecture tb of tb_full_adder_4b is

    -- Déclaration des signaux de test
    signal A    : std_logic_vector(3 downto 0);
    signal B    : std_logic_vector(3 downto 0);
    signal Cin  : std_logic;
    signal S    : std_logic_vector(3 downto 0);
    signal Cout : std_logic;

begin

    -- Instanciation de l'entité testée, récupérée dans la librairie work
    -- On appelle cette instance UUT (Unit Under Test)
    UUT : entity work.full_adder_4b port map (
        A    => A,
        B    => B,
        Cin  => Cin,
        S    => S,
        Cout => Cout
    );

    -- Description des stimuli
    stimuli1 : process
    begin

        -- CAS 1 : 0 + 0 + 0 = 0, Cout = 0
        -- Résultat attendu : S = "0000", Cout = '0'
        A   <= "0000"; B <= "0000"; Cin <= '0';
        wait for 20 ns;

        -- CAS 2 : 1 + 1 + 0 = 2, Cout = 0
        -- Résultat attendu : S = "0010", Cout = '0'
        A   <= "0001"; B <= "0001"; Cin <= '0';
        wait for 20 ns;

        -- CAS 3 : 5 + 3 + 0 = 8, Cout = 0
        -- Résultat attendu : S = "1000", Cout = '0'
        A   <= "0101"; B <= "0011"; Cin <= '0';
        wait for 20 ns;

        -- CAS 4 : 5 + 3 + 1 = 9, test propagation Cin
        -- Résultat attendu : S = "1001", Cout = '0'
        A   <= "0101"; B <= "0011"; Cin <= '1';
        wait for 20 ns;

        -- CAS 5 : 15 + 1 + 0 = 16, overflow
        -- Résultat attendu : S = "0000", Cout = '1'
        A   <= "1111"; B <= "0001"; Cin <= '0';
        wait for 20 ns;

        -- CAS 6 : 15 + 15 + 1 = 31, overflow maximum
        -- Résultat attendu : S = "1111", Cout = '1'
        A   <= "1111"; B <= "1111"; Cin <= '1';
        wait for 20 ns;

        wait; -- Wait indefinitely
    end process;

end tb;
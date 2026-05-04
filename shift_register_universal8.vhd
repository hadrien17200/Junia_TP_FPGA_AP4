library ieee;
use ieee.std_logic_1164.all;

-- Registre universel 8 bits

entity shift_register_universal8 is
    port (
        -- Entrees serie
        SSR  : in  std_logic;                     
        SSL  : in  std_logic;                     
        -- Entree parallele
        Pi   : in  std_logic_vector(7 downto 0);  
        -- Selection de mode
        SEL  : in  std_logic_vector(2 downto 0);  
        -- Horloge et asynchrones
        CLK  : in  std_logic;
        SETn : in  std_logic;                     
        RSTn : in  std_logic;                     
        -- Sorties serie
        SOR  : out std_logic;                     
        SOL  : out std_logic;                     
        -- Sortie parallele
        Qo   : out std_logic_vector(7 downto 0)   
    );
end shift_register_universal8;

architecture behavioral of shift_register_universal8 is
    signal Q_int : std_logic_vector(7 downto 0) := (others => '0');
begin

    process (CLK, SETn, RSTn)
    begin
        -- Priorite 1 : Preset asynchrone
        if (SETn = '0') then
            Q_int <= (others => '1');

        -- Priorite 2 : Reset asynchrone
        elsif (RSTn = '0') then
            Q_int <= (others => '0');

        -- Priorite 3 : Fonctionnement synchrone
        elsif rising_edge(CLK) then
            case SEL is

                -- X00 : Hold - Memorisation
                when "000" | "100" =>
                    Q_int <= Q_int;

                -- X11 : Parallel load - Chargement parallele
                when "011" | "111" =>
                    Q_int <= Pi;

                -- 001 : Shift right - Decalage droite
                -- SSR entre par la gauche (Q7), Q0 sort par SOR
                when "001" =>
                    Q_int <= SSR & Q_int(7 downto 1);

                -- 010 : Shift left - Decalage gauche
                -- SSL entre par la droite (Q0), Q7 sort par SOL
                when "010" =>
                    Q_int <= Q_int(6 downto 0) & SSL;

                -- 101 : Rotate right - Rotation droite
                -- Q0 revient en Q7
                when "101" =>
                    Q_int <= Q_int(0) & Q_int(7 downto 1);

                -- 110 : Rotate left - Rotation gauche
                -- Q7 revient en Q0
                when "110" =>
                    Q_int <= Q_int(6 downto 0) & Q_int(7);

                -- Cas non definis : memorisation par defaut
                when others =>
                    Q_int <= Q_int;

            end case;
        end if;
    end process;

    -- Sorties paralleles
    Qo  <= Q_int;

    -- Sorties serie (bit qui sort avant le decalage)
    SOR <= Q_int(0);  
    SOL <= Q_int(7);  

end behavioral;
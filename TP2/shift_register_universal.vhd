library ieee;
use ieee.std_logic_1164.all;

-- Registre universel N bits (generique)
--
-- Generic :
--   SIZE : taille du registre en bits (defaut 8)
--
-- Table des modes (SEL) :
--
--   +-------+--------+--------------------------------------------------+
--   | SEL   | Mode   | Description                                      |
--   +-------+--------+--------------------------------------------------+
--   | X00   | Hold   | Memorisation (Q conserve sa valeur)              |
--   +-------+--------+--------------------------------------------------+
--   | X11   | Load   | Chargement parallele (Q <= Pi)                   |
--   +-------+--------+--------------------------------------------------+
--   | 001   | SHR    | Decalage droite  (SSR -> Q(N-1)..Q(0) -> SOR)   |
--   +-------+--------+--------------------------------------------------+
--   | 010   | SHL    | Decalage gauche  (SSL -> Q(0)..Q(N-1) -> SOL)   |
--   +-------+--------+--------------------------------------------------+
--   | 101   | ROTR   | Rotation droite  (Q(0) -> Q(N-1))               |
--   +-------+--------+--------------------------------------------------+
--   | 110   | ROTL   | Rotation gauche  (Q(N-1) -> Q(0))               |
--   +-------+--------+--------------------------------------------------+
--
-- Entrees asynchrones (prioritaires sur CLK) :
--   SETn=0 => Q <= (others => '1')   (preset)
--   RSTn=0 => Q <= (others => '0')   (reset)

entity shift_register_universal is
    generic (
        SIZE : integer := 8  
    );
    port (
        -- Entrees serie
        SSR  : in  std_logic;                         
        SSL  : in  std_logic;                          
        -- Entree parallele
        Pi   : in  std_logic_vector(SIZE-1 downto 0); 
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
        Qo   : out std_logic_vector(SIZE-1 downto 0)  
    );
end entity shift_register_universal;

architecture behavioral of shift_register_universal is
    signal Q_int : std_logic_vector(SIZE-1 downto 0) := (others => '0');
begin

    process(CLK, SETn, RSTn)
    begin
        -- Priorite 1 : Preset asynchrone
        if SETn = '0' then
            Q_int <= (others => '1');

        -- Priorite 2 : Reset asynchrone
        elsif RSTn = '0' then
            Q_int <= (others => '0');

        -- Priorite 3 : Fonctionnement synchrone
        elsif rising_edge(CLK) then
            case SEL is
                when "000" | "100" =>
                    Q_int <= Q_int;

                when "011" | "111" =>
                    Q_int <= Pi;

                when "001" =>
                    Q_int <= SSR & Q_int(SIZE-1 downto 1);

                when "010" =>
                    Q_int <= Q_int(SIZE-2 downto 0) & SSL;

                when "101" =>
                    Q_int <= Q_int(0) & Q_int(SIZE-1 downto 1);

                when "110" =>
                    Q_int <= Q_int(SIZE-2 downto 0) & Q_int(SIZE-1);

                -- Cas non definis : memorisation par defaut
                when others =>
                    Q_int <= Q_int;
            end case;
        end if;
    end process;

    -- Sorties paralleles
    Qo  <= Q_int;

    -- Sorties serie 
    SOR <= Q_int(0);       
    SOL <= Q_int(SIZE-1);  

end behavioral;
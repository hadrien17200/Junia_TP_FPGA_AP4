library ieee;
use ieee.std_logic_1164.all;

-- Testbench for flipflop_JKrs
--
-- Test plan :
--
--   +-------+------+------+---+---+-------------------------------------------+
--   | Phase | SETn | RSTn | J | K | Action attendue                           |
--   +-------+------+------+---+---+-------------------------------------------+
--   |   1   |  0   |  1   | X | X | Preset  asynchrone    => Q=1, Qn=0        |
--   +-------+------+------+---+---+-------------------------------------------+
--   |   2   |  1   |  0   | X | X | Reset   asynchrone    => Q=0, Qn=1        |
--   +-------+------+------+---+---+-------------------------------------------+
--   |   3   |  1   |  1   | 0 | 0 | Memoire (apres reset) => Q=0, Qn=1        |
--   +-------+------+------+---+---+-------------------------------------------+
--   |   4   |  1   |  1   | 1 | 0 | Set synchrone         => Q=1, Qn=0        |
--   +-------+------+------+---+---+-------------------------------------------+
--   |   5   |  1   |  1   | 0 | 0 | Memoire (apres set)   => Q=1, Qn=0        |
--   +-------+------+------+---+---+-------------------------------------------+
--   |   6   |  1   |  1   | 0 | 1 | Reset  synchrone      => Q=0, Qn=1        |
--   +-------+------+------+---+---+-------------------------------------------+
--   |   7   |  1   |  1   | 1 | 1 | Toggle (Q etait 0)    => Q=1, Qn=0        |
--   +-------+------+------+---+---+-------------------------------------------+
--   |   8   |  1   |  1   | 1 | 1 | Toggle (Q etait 1)    => Q=0, Qn=1        |
--   +-------+------+------+---+---+-------------------------------------------+
--   |   9   |  0   |  1   | X | X | Preset pendant Toggle => Q=1, Qn=0 (async)|
--   +-------+------+------+---+---+-------------------------------------------+

entity tb_flipflop_JKrs is
-- Testbench : pas de port
end tb_flipflop_JKrs;

architecture behavioral of tb_flipflop_JKrs is

    -- Declaration du composant a tester
    component flipflop_JKrs
        port (
            J    : in  std_logic;
            K    : in  std_logic;
            CLK  : in  std_logic;
            SETn : in  std_logic;
            RSTn : in  std_logic;
            Q    : out std_logic;
            Qn   : out std_logic
        );
    end component;

    -- Signaux d'entree (on les pilote dans le testbench)
    signal J_tb    : std_logic := '0';
    signal K_tb    : std_logic := '0';
    signal CLK_tb  : std_logic := '0';
    signal SETn_tb : std_logic := '1';
    signal RSTn_tb : std_logic := '1';

    -- Signaux de sortie (on les observe)
    signal Q_tb    : std_logic;
    signal Qn_tb   : std_logic;

    -- Periode d'horloge
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instanciation du composant a tester (UUT = Unit Under Test)
    UUT : flipflop_JKrs
        port map (
            J    => J_tb,
            K    => K_tb,
            CLK  => CLK_tb,
            SETn => SETn_tb,
            RSTn => RSTn_tb,
            Q    => Q_tb,
            Qn   => Qn_tb
        );

    -- Generation de l'horloge (tourne indefiniment)
    clk_process : process
    begin
        CLK_tb <= '0';
        wait for CLK_PERIOD / 2;
        CLK_tb <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Application des stimuli
    stim_process : process
    begin

        -- -------------------------------------------------------
        -- Phase 1 : Preset asynchrone (SETn=0)
        -- Attendu : Q=1, Qn=0 immediatement, sans attendre CLK
        -- -------------------------------------------------------
        SETn_tb <= '0';
        RSTn_tb <= '1';
        J_tb    <= '0';
        K_tb    <= '0';
        wait for 15 ns;  -- on n'attend pas de front d'horloge

        -- -------------------------------------------------------
        -- Phase 2 : Reset asynchrone (RSTn=0)
        -- Attendu : Q=0, Qn=1 immediatement, sans attendre CLK
        -- -------------------------------------------------------
        SETn_tb <= '1';
        RSTn_tb <= '0';
        wait for 15 ns;

        -- Retour en mode normal
        RSTn_tb <= '1';
        wait until rising_edge(CLK_tb);
        wait for 2 ns;  -- petit delai apres le front pour stabilisation

        -- -------------------------------------------------------
        -- Phase 3 : Memoire (J=0, K=0) apres reset => Q reste 0
        -- -------------------------------------------------------
        J_tb <= '0';
        K_tb <= '0';
        wait until rising_edge(CLK_tb);
        wait for 2 ns;

        -- -------------------------------------------------------
        -- Phase 4 : Set synchrone (J=1, K=0) => Q=1
        -- -------------------------------------------------------
        J_tb <= '1';
        K_tb <= '0';
        wait until rising_edge(CLK_tb);
        wait for 2 ns;

        -- -------------------------------------------------------
        -- Phase 5 : Memoire (J=0, K=0) apres set => Q reste 1
        -- -------------------------------------------------------
        J_tb <= '0';
        K_tb <= '0';
        wait until rising_edge(CLK_tb);
        wait for 2 ns;

        -- -------------------------------------------------------
        -- Phase 6 : Reset synchrone (J=0, K=1) => Q=0
        -- -------------------------------------------------------
        J_tb <= '0';
        K_tb <= '1';
        wait until rising_edge(CLK_tb);
        wait for 2 ns;

        -- -------------------------------------------------------
        -- Phase 7 : Toggle (J=1, K=1), Q etait 0 => Q=1
        -- -------------------------------------------------------
        J_tb <= '1';
        K_tb <= '1';
        wait until rising_edge(CLK_tb);
        wait for 2 ns;

        -- -------------------------------------------------------
        -- Phase 8 : Toggle (J=1, K=1), Q etait 1 => Q=0
        -- -------------------------------------------------------
        wait until rising_edge(CLK_tb);
        wait for 2 ns;

        -- -------------------------------------------------------
        -- Phase 9 : Preset asynchrone pendant un Toggle
        -- SETn=0 doit forcer Q=1 immediatement, sans attendre CLK
        -- -------------------------------------------------------
        SETn_tb <= '0';
        wait for 15 ns;
        SETn_tb <= '1';

        -- Fin de simulation
        wait for 20 ns;
        wait; -- stoppe le process

    end process;

end behavioral;
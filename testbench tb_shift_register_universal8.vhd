library ieee;
use ieee.std_logic_1164.all;

-- Testbench for shift_register_universal8
-- A lancer sous ModelSim UNIQUEMENT (pas synthetisable sous Quartus)
--
-- Test plan :
--
--   +--------+------+------+-------+-----+-----+-------------------------------+
--   | Phase  | SETn | RSTn |  SEL  |  Pi | Q   | Action attendue               |
--   +--------+------+------+-------+-----+-----+-------------------------------+
--   |   1    |  0   |  1   |  XXX  | XX  | FF  | Preset  asynchrone => Q=FF    |
--   +--------+------+------+-------+-----+-----+-------------------------------+
--   |   2    |  1   |  0   |  XXX  | XX  | 00  | Reset   asynchrone => Q=00    |
--   +--------+------+------+-------+-----+-----+-------------------------------+
--   |   3    |  1   |  1   |  011  | A5  | A5  | Parallel load      => Q=A5    |
--   +--------+------+------+-------+-----+-----+-------------------------------+
--   |   4    |  1   |  1   |  000  | XX  | A5  | Hold               => Q=A5    |
--   +--------+------+------+-------+-----+-----+-------------------------------+
--   |   5    |  1   |  1   |  001  | XX  | 52  | Shift right (SSR=0)=> Q=52    |
--   +--------+------+------+-------+-----+-----+-------------------------------+
--   |   6    |  1   |  1   |  001  | XX  | A9  | Shift right (SSR=1)=> Q=A9    |
--   +--------+------+------+-------+-----+-----+-------------------------------+
--   |   7    |  1   |  1   |  010  | XX  | 52  | Shift left  (SSL=0)=> Q=52    |
--   +--------+------+------+-------+-----+-----+-------------------------------+
--   |   8    |  1   |  1   |  010  | XX  | A5  | Shift left  (SSL=1)=> Q=A5    |
--   +--------+------+------+-------+-----+-----+-------------------------------+
--   |   9    |  1   |  1   |  101  | XX  | 52  | Rotate right       => Q=52    |
--   +--------+------+------+-------+-----+-----+-------------------------------+
--   |  10    |  1   |  1   |  110  | XX  | A5  | Rotate left        => Q=A5    |
--   +--------+------+------+-------+-----+-----+-------------------------------+
--   |  11    |  0   |  1   |  001  | XX  | FF  | Preset pendant SHR => Q=FF    |
--   +--------+------+------+-------+-----+-----+-------------------------------+

entity tb_shift_register_universal8 is
end tb_shift_register_universal8;

architecture behavioral of tb_shift_register_universal8 is

    component shift_register_universal8
        port (
            SSR  : in  std_logic;
            SSL  : in  std_logic;
            Pi   : in  std_logic_vector(7 downto 0);
            SEL  : in  std_logic_vector(2 downto 0);
            CLK  : in  std_logic;
            SETn : in  std_logic;
            RSTn : in  std_logic;
            SOR  : out std_logic;
            SOL  : out std_logic;
            Qo   : out std_logic_vector(7 downto 0)
        );
    end component;

    signal SSR_tb  : std_logic := '0';
    signal SSL_tb  : std_logic := '0';
    signal Pi_tb   : std_logic_vector(7 downto 0) := (others => '0');
    signal SEL_tb  : std_logic_vector(2 downto 0) := "000";
    signal CLK_tb  : std_logic := '0';
    signal SETn_tb : std_logic := '1';
    signal RSTn_tb : std_logic := '1';
    signal SOR_tb  : std_logic;
    signal SOL_tb  : std_logic;
    signal Qo_tb   : std_logic_vector(7 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    UUT : shift_register_universal8
        port map (
            SSR  => SSR_tb,
            SSL  => SSL_tb,
            Pi   => Pi_tb,
            SEL  => SEL_tb,
            CLK  => CLK_tb,
            SETn => SETn_tb,
            RSTn => RSTn_tb,
            SOR  => SOR_tb,
            SOL  => SOL_tb,
            Qo   => Qo_tb
        );

    -- Generation horloge
    clk_process : process
    begin
        CLK_tb <= '0'; wait for CLK_PERIOD / 2;
        CLK_tb <= '1'; wait for CLK_PERIOD / 2;
    end process;

    -- Stimuli
    stim_process : process
    begin

        -- -------------------------------------------------------
        -- Phase 1 : Preset asynchrone => Q=FF immediat
        -- -------------------------------------------------------
        SETn_tb <= '0'; RSTn_tb <= '1';
        SEL_tb  <= "000"; Pi_tb <= x"00";
        wait for 15 ns;

        -- -------------------------------------------------------
        -- Phase 2 : Reset asynchrone => Q=00 immediat
        -- -------------------------------------------------------
        SETn_tb <= '1'; RSTn_tb <= '0';
        wait for 15 ns;

        -- Retour mode normal
        RSTn_tb <= '1';
        wait until rising_edge(CLK_tb); wait for 2 ns;

        -- -------------------------------------------------------
        -- Phase 3 : Parallel load => Q=A5 (10100101)
        -- -------------------------------------------------------
        SEL_tb <= "011"; Pi_tb <= x"A5";
        wait until rising_edge(CLK_tb); wait for 2 ns;

        -- -------------------------------------------------------
        -- Phase 4 : Hold => Q reste A5
        -- -------------------------------------------------------
        SEL_tb <= "000";
        wait until rising_edge(CLK_tb); wait for 2 ns;

        -- -------------------------------------------------------
        -- Phase 5 : Shift right, SSR=0
        -- Q=A5 (10100101) => Q=52 (01010010), SOR=1
        -- -------------------------------------------------------
        SEL_tb <= "001"; SSR_tb <= '0';
        wait until rising_edge(CLK_tb); wait for 2 ns;

        -- -------------------------------------------------------
        -- Phase 6 : Shift right, SSR=1
        -- Q=52 (01010010) => Q=A9 (10101001), SOR=0
        -- -------------------------------------------------------
        SSR_tb <= '1';
        wait until rising_edge(CLK_tb); wait for 2 ns;

        -- -------------------------------------------------------
        -- Phase 7 : Shift left, SSL=0
        -- Q=A9 (10101001) => Q=52 (01010010), SOL=1
        -- -------------------------------------------------------
        SEL_tb <= "010"; SSL_tb <= '0';
        wait until rising_edge(CLK_tb); wait for 2 ns;

        -- -------------------------------------------------------
        -- Phase 8 : Shift left, SSL=1
        -- Q=52 (01010010) => Q=A5 (10100101), SOL=0
        -- -------------------------------------------------------
        SSL_tb <= '1';
        wait until rising_edge(CLK_tb); wait for 2 ns;

        -- -------------------------------------------------------
        -- Phase 9 : Rotate right
        -- Q=A5 (10100101) => Q=D2 (11010010), Q(0) revient en Q(7)
        -- -------------------------------------------------------
        SEL_tb <= "101";
        wait until rising_edge(CLK_tb); wait for 2 ns;

        -- -------------------------------------------------------
        -- Phase 10 : Rotate left
        -- Q=D2 (11010010) => Q=A5 (10100101), Q(7) revient en Q(0)
        -- -------------------------------------------------------
        SEL_tb <= "110";
        wait until rising_edge(CLK_tb); wait for 2 ns;

        -- -------------------------------------------------------
        -- Phase 11 : Preset asynchrone pendant un shift right
        -- SETn=0 doit forcer Q=FF immediatement, sans attendre CLK
        -- -------------------------------------------------------
        SEL_tb  <= "001"; SSR_tb <= '0';
        SETn_tb <= '0';
        wait for 15 ns;
        SETn_tb <= '1';

        -- Fin de simulation
        wait for CLK_PERIOD * 5;
        wait;

    end process;

end behavioral;
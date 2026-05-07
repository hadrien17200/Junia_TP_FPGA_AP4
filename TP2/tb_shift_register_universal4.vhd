library ieee;
use ieee.std_logic_1164.all;

-- Testbench shift_register_universal - SIZE=4
--
-- Test plan :
--
--   +--------+------+------+-------+------+-----+-------------------------------+
--   | Phase  | SETn | RSTn |  SEL  |  Pi  | Q   | Action attendue               |
--   +--------+------+------+-------+------+-----+-------------------------------+
--   |   1    |  0   |  1   |  XXX  |  XX  |  F  | Preset  asynchrone => Q=F     |
--   +--------+------+------+-------+------+-----+-------------------------------+
--   |   2    |  1   |  0   |  XXX  |  XX  |  0  | Reset   asynchrone => Q=0     |
--   +--------+------+------+-------+------+-----+-------------------------------+
--   |   3    |  1   |  1   |  011  |  A   |  A  | Parallel load      => Q=A     |
--   +--------+------+------+-------+------+-----+-------------------------------+
--   |   4    |  1   |  1   |  000  |  XX  |  A  | Hold               => Q=A     |
--   +--------+------+------+-------+------+-----+-------------------------------+
--   |   5    |  1   |  1   |  001  |  XX  |  5  | Shift right (SSR=0)=> Q=5     |
--   +--------+------+------+-------+------+-----+-------------------------------+
--   |   6    |  1   |  1   |  001  |  XX  |  A  | Shift right (SSR=1)=> Q=A     |
--   +--------+------+------+-------+------+-----+-------------------------------+
--   |   7    |  1   |  1   |  010  |  XX  |  5  | Shift left  (SSL=0)=> Q=5     |
--   +--------+------+------+-------+------+-----+-------------------------------+
--   |   8    |  1   |  1   |  010  |  XX  |  A  | Shift left  (SSL=1)=> Q=A     |
--   +--------+------+------+-------+------+-----+-------------------------------+
--   |   9    |  1   |  1   |  101  |  XX  |  5  | Rotate right       => Q=5     |
--   +--------+------+------+-------+------+-----+-------------------------------+
--   |  10    |  1   |  1   |  110  |  XX  |  A  | Rotate left        => Q=A     |
--   +--------+------+------+-------+------+-----+-------------------------------+
--   |  11    |  0   |  1   |  001  |  XX  |  F  | Preset pendant SHR => Q=F     |
--   +--------+------+------+-------+------+-----+-------------------------------+

entity tb_shift_register_universal4 is
end tb_shift_register_universal4;

architecture behavioral of tb_shift_register_universal4 is

    component shift_register_universal
        generic (SIZE : integer := 8);
        port (
            SSR  : in  std_logic;
            SSL  : in  std_logic;
            Pi   : in  std_logic_vector(SIZE-1 downto 0);
            SEL  : in  std_logic_vector(2 downto 0);
            CLK  : in  std_logic;
            SETn : in  std_logic;
            RSTn : in  std_logic;
            SOR  : out std_logic;
            SOL  : out std_logic;
            Qo   : out std_logic_vector(SIZE-1 downto 0)
        );
    end component;

    signal SSR_tb  : std_logic := '0';
    signal SSL_tb  : std_logic := '0';
    signal Pi_tb   : std_logic_vector(3 downto 0) := (others => '0');
    signal SEL_tb  : std_logic_vector(2 downto 0) := "000";
    signal CLK_tb  : std_logic := '0';
    signal SETn_tb : std_logic := '1';
    signal RSTn_tb : std_logic := '1';
    signal SOR_tb  : std_logic;
    signal SOL_tb  : std_logic;
    signal Qo_tb   : std_logic_vector(3 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instanciation avec SIZE=4
    UUT : shift_register_universal
        generic map (SIZE => 4)
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

    clk_process : process
    begin
        CLK_tb <= '0'; wait for CLK_PERIOD / 2;
        CLK_tb <= '1'; wait for CLK_PERIOD / 2;
    end process;

    stim_process : process
    begin
        SETn_tb <= '0'; RSTn_tb <= '1';
        SEL_tb  <= "000"; Pi_tb <= x"0";
        wait for 15 ns;

        SETn_tb <= '1'; RSTn_tb <= '0';
        wait for 15 ns;

        RSTn_tb <= '1';
        wait until rising_edge(CLK_tb); wait for 2 ns;

        SEL_tb <= "011"; Pi_tb <= x"A";
        wait until rising_edge(CLK_tb); wait for 2 ns;

        SEL_tb <= "000";
        wait until rising_edge(CLK_tb); wait for 2 ns;

        SEL_tb <= "001"; SSR_tb <= '0';
        wait until rising_edge(CLK_tb); wait for 2 ns;

        SSR_tb <= '1';
        wait until rising_edge(CLK_tb); wait for 2 ns;

        SEL_tb <= "010"; SSL_tb <= '0';
        wait until rising_edge(CLK_tb); wait for 2 ns;

        SSL_tb <= '1';
        wait until rising_edge(CLK_tb); wait for 2 ns;

        SEL_tb <= "101";
        wait until rising_edge(CLK_tb); wait for 2 ns;

        SEL_tb <= "110";
        wait until rising_edge(CLK_tb); wait for 2 ns;

        SEL_tb  <= "001"; SSR_tb <= '0';
        SETn_tb <= '0';
        wait for 15 ns;
        SETn_tb <= '1';

        wait for CLK_PERIOD * 5;
        wait;
    end process;

end behavioral;
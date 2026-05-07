library ieee;
use ieee.std_logic_1164.all;

-- Testbench shift_register_universal - SIZE=16
--
-- Test plan :
--
--   +--------+------+------+-------+--------+--------+-------------------------------+
--   | Phase  | SETn | RSTn |  SEL  |   Pi   |   Q    | Action attendue               |
--   +--------+------+------+-------+--------+--------+-------------------------------+
--   |   1    |  0   |  1   |  XXX  |  XXXX  |  FFFF  | Preset  asynchrone => Q=FFFF  |
--   +--------+------+------+-------+--------+--------+-------------------------------+
--   |   2    |  1   |  0   |  XXX  |  XXXX  |  0000  | Reset   asynchrone => Q=0000  |
--   +--------+------+------+-------+--------+--------+-------------------------------+
--   |   3    |  1   |  1   |  011  |  A5A5  |  A5A5  | Parallel load      => Q=A5A5  |
--   +--------+------+------+-------+--------+--------+-------------------------------+
--   |   4    |  1   |  1   |  000  |  XXXX  |  A5A5  | Hold               => Q=A5A5  |
--   +--------+------+------+-------+--------+--------+-------------------------------+
--   |   5    |  1   |  1   |  001  |  XXXX  |  52D2  | Shift right (SSR=0)=> Q=52D2  |
--   +--------+------+------+-------+--------+--------+-------------------------------+
--   |   6    |  1   |  1   |  001  |  XXXX  |  A969  | Shift right (SSR=1)=> Q=A969  |
--   +--------+------+------+-------+--------+--------+-------------------------------+
--   |   7    |  1   |  1   |  010  |  XXXX  |  52D2  | Shift left  (SSL=0)=> Q=52D2  |
--   +--------+------+------+-------+--------+--------+-------------------------------+
--   |   8    |  1   |  1   |  010  |  XXXX  |  A5A5  | Shift left  (SSL=1)=> Q=A5A5  |
--   +--------+------+------+-------+--------+--------+-------------------------------+
--   |   9    |  1   |  1   |  101  |  XXXX  |        | Rotate right                  |
--   +--------+------+------+-------+--------+--------+-------------------------------+
--   |  10    |  1   |  1   |  110  |  XXXX  |  A5A5  | Rotate left => retour A5A5    |
--   +--------+------+------+-------+--------+--------+-------------------------------+
--   |  11    |  0   |  1   |  001  |  XXXX  |  FFFF  | Preset pendant SHR => Q=FFFF  |
--   +--------+------+------+-------+--------+--------+-------------------------------+

entity tb_shift_register_universal16 is
end tb_shift_register_universal16;

architecture behavioral of tb_shift_register_universal16 is

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
    signal Pi_tb   : std_logic_vector(15 downto 0) := (others => '0');
    signal SEL_tb  : std_logic_vector(2 downto 0)  := "000";
    signal CLK_tb  : std_logic := '0';
    signal SETn_tb : std_logic := '1';
    signal RSTn_tb : std_logic := '1';
    signal SOR_tb  : std_logic;
    signal SOL_tb  : std_logic;
    signal Qo_tb   : std_logic_vector(15 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instanciation avec SIZE=16
    UUT : shift_register_universal
        generic map (SIZE => 16)
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
        SEL_tb  <= "000"; Pi_tb <= x"0000";
        wait for 15 ns;

        SETn_tb <= '1'; RSTn_tb <= '0';
        wait for 15 ns;

        RSTn_tb <= '1';
        wait until rising_edge(CLK_tb); wait for 2 ns;

        SEL_tb <= "011"; Pi_tb <= x"A5A5";
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
library ieee;
use ieee.std_logic_1164.all;

-- JK flip flop, partie asyncrone avec preset et reset asynchrones actifs bas
--
-- Symbol :              Characteristic table :
--
--                       Entrees asynchrones (prioritaires sur CLK) :
--   +---------+         +------+------++----+-----+
--   |         |         | SETn | RSTn || Q+ | Qn+ |
-- --J       Q+--        +------+------++----+-----+
--   |         |         |  0   |  1   ||  1 |  0  | (Preset  - actif bas)
-- ->CLK    Qn+--        +------+------++----+-----+
--   |         |         |  1   |  0   ||  0 |  1  | (Reset   - actif bas)
-- --K         |         +------+------++----+-----+
--   |         |         |  0   |  0   ||  / |  /  | (INTERDIT)
-- --SETn      |         +------+------++----+-----+
--   |         |         |  1   |  1   ||  fonctionnement JK normal (voir ci-dessous)
-- --RSTn      |         +------+------++----+-----+
--   +---------+
--                       Entrees synchrones (sur front montant CLK, si SETn=1 et RSTn=1) :
--
--                       +---+---++----+-----+
--                       | J | K || Q+ | Qn+ |
--                       +---+---++----+-----+
--                       | 0 | 0 ||  Q |  Qn | (Memoire)
--                       +---+---++----+-----+
--                       | 0 | 1 ||  0 |  1  | (Reset)
--                       +---+---++----+-----+
--                       | 1 | 0 ||  1 |  0  | (Set)
--                       +---+---++----+-----+
--                       | 1 | 1 || /Q | /Qn | (Toggle)
--                       +---+---++----+-----+
--
-- Equation caracteristique :
--   Q+(t+1) = J.(/Q) + (/K).Q  (quand SETn=1 et RSTn=1)

entity flipflop_JKrs is
    port (
        J    : in  std_logic;
        K    : in  std_logic;
        CLK  : in  std_logic;
        SETn : in  std_logic;  -- preset  asynchrone, actif bas
        RSTn : in  std_logic;  -- reset   asynchrone, actif bas
        Q    : out std_logic;
        Qn   : out std_logic
    );
end flipflop_JKrs;

architecture behavioral of flipflop_JKrs is
    signal Q_int : std_logic := '0';
begin

    -- SETn et RSTn sont dans la liste de sensibilite car asynchrones
    process (CLK, SETn, RSTn)
    begin
        -- Priorite 1 : preset asynchrone (actif bas)
        if (SETn = '0') then
            Q_int <= '1';

        -- Priorite 2 : reset asynchrone (actif bas)
        elsif (RSTn = '0') then
            Q_int <= '0';

        -- Priorite 3 : fonctionnement JK synchrone sur front montant
        elsif rising_edge(CLK) then
            if    (J = '0' and K = '0') then
                Q_int <= Q_int;      -- Memoire
            elsif (J = '0' and K = '1') then
                Q_int <= '0';        -- Reset
            elsif (J = '1' and K = '0') then
                Q_int <= '1';        -- Set
            elsif (J = '1' and K = '1') then
                Q_int <= not Q_int;  -- Toggle
            end if;
        end if;
    end process;

    -- Sorties
    Q  <= Q_int;
    Qn <= not Q_int;

end behavioral;
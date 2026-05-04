library ieee;
use ieee.std_logic_1164.all;

-- JK flip flop 

-- Symbol :              Characteristic table :
--
--   +---------+         +---+---++----+-----+
--   |         |         | J | K || Q+ | Qn+ |
-- --J       Q+--        +---+---++----+-----+
--   |         |         | 0 | 0 ||  Q |  Qn | (Memoire)
-- ->CLK    Qn+--        +---+---++----+-----+
--   |         |         | 0 | 1 ||  0 |  1  | (Reset)
-- --K         |         +---+---++----+-----+
--   |         |         | 1 | 0 ||  1 |  0  | (Set)
--   +---------+         +---+---++----+-----+
--                       | 1 | 1 || /Q | /Qn | (Toggle)
--                       +---+---++----+-----+
--
-- Equation caracteristique :
--   Q+(t+1) = J.(/Q) + (/K).Q

entity flipflop_JK is
    port (
        J   : in  std_logic;
        K   : in  std_logic;
        CLK : in  std_logic;
        Q   : out std_logic;
        Qn  : out std_logic
    );
end flipflop_JK;

architecture behavioral of flipflop_JK is
    signal Q_int : std_logic := '0';  -- signal interne (lecture/ecriture)
begin

    process (CLK)
    begin
        if rising_edge(CLK) then
            if    (J = '0' and K = '0') then
                Q_int <= Q_int;        -- Memoire
            elsif (J = '0' and K = '1') then
                Q_int <= '0';          -- Reset
            elsif (J = '1' and K = '0') then
                Q_int <= '1';          -- Set
            elsif (J = '1' and K = '1') then
                Q_int <= not Q_int;    -- Toggle
            end if;
        end if;
    end process;

    -- Sorties
    Q  <= Q_int;
    Qn <= not Q_int;

end behavioral;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Bistable : Machine de Moore a 4 etats
--
-- Diagramme d'etats :
--
--              X=1
--           +-------+
--           |       |
--           v  X=0  |
--   rst -> [A]--->[B]
--          Y=0   Y=1
--           ^       |
--        X=0|    X=0|
--           |       v
--          [D]<---[C]
--          Y=0  X=1 Y=1
--           |       ^
--           +-------+
--              X=1
--
-- Table de transitions :
--
--   +---------+-----+------------------+--------+
--   | Etat    |  X  | Etat futur       | Y      |
--   +---------+-----+------------------+--------+
--   | A (rst) |  0  | A (reste)        | 0      |
--   |         |  1  | B                | 0      |
--   +---------+-----+------------------+--------+
--   | B       |  0  | C                | 1      |
--   |         |  1  | B (reste)        | 1      |
--   +---------+-----+------------------+--------+
--   | C       |  0  | C (reste)        | 1      |
--   |         |  1  | D                | 1      |
--   +---------+-----+------------------+--------+
--   | D       |  0  | A                | 0      |
--   |         |  1  | D (reste)        | 0      |
--   +---------+-----+------------------+--------+

entity bistable is
    port (
        CLK : in  std_logic;
        RST : in  std_logic;
        X   : in  std_logic;
        Y   : out std_logic
    );
end entity bistable;

architecture behavioral of bistable is

    type state_type is (A, B, C, D);
    signal current_state : state_type;
    signal future_state  : state_type;

begin

    -- Process 1 : Registre d'etats (SEQUENTIEL)

    process(CLK, RST)
    begin
        if RST = '0' then
            current_state <= A;
        elsif rising_edge(CLK) then
            current_state <= future_state;
        end if;
    end process;

    -- Process 2 : Calcul de l'etat futur (COMBINATOIRE)
    process(current_state, X)
    begin
        case current_state is
            when A =>
                if    X = '1' then future_state <= B;
                else               future_state <= A;
                end if;
            when B =>
                if    X = '0' then future_state <= C;
                else               future_state <= B;
                end if;
            when C =>
                if    X = '1' then future_state <= D;
                else               future_state <= C;
                end if;
            when D =>
                if    X = '0' then future_state <= A;
                else               future_state <= D;
                end if;
            when others =>
                future_state <= A;
        end case;
    end process;

    -- Process 3 : Calcul des sorties (COMBINATOIRE)

    process(current_state)
    begin
        case current_state is
            when A => Y <= '0';
            when B => Y <= '1';
            when C => Y <= '1';
            when D => Y <= '0';
            when others => Y <= '0';
        end case;
    end process;

end behavioral;
library ieee;
use ieee.std_logic_1164.all;


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

    -- Process 1 : registre d'etat (sequentiel)
    process(CLK, RST)
    begin
        if RST = '0' then
            current_state <= A;
        elsif rising_edge(CLK) then
            current_state <= future_state;
        end if;
    end process;

    -- Process 2 : calcul de l'etat futur (combinatoire)
    process(current_state, X)
    begin
        case current_state is
            when A =>
                if X = '1' then future_state <= B;
                else             future_state <= A;
                end if;
            when B =>
                if X = '0' then future_state <= C;
                else             future_state <= B;
                end if;
            when C =>
                if X = '1' then future_state <= D;
                else             future_state <= C;
                end if;
            when D =>
                if X = '0' then future_state <= A;
                else             future_state <= D;
                end if;
            when others =>
                future_state <= A;
        end case;
    end process;

    -- Process 3 : calcul des sorties (combinatoire, Moore)
    process(current_state)
    begin
        case current_state is
            when A | D => Y <= '0';
            when B | C => Y <= '1';
        end case;
    end process;

end behavioral;
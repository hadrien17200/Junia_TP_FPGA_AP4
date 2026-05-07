library ieee;
use ieee.std_logic_1164.all;


entity chenillard is
    generic (
        SIZE : integer := 10  
    );
    port (
        CLK  : in  std_logic;
        RST  : in  std_logic;
        DIR  : in  std_logic;  
        CHEN : out std_logic_vector(SIZE-1 downto 0)
    );
end entity chenillard;

architecture behavioral of chenillard is
    signal state : integer range 0 to SIZE-1 := 0;
begin

    -- Compteur d'etat
    process(CLK, RST)
    begin
        if RST = '0' then
            state <= 0;
        elsif rising_edge(CLK) then
            if DIR = '0' then
                -- Defilement gauche
                if state = SIZE-1 then state <= 0;
                else                   state <= state + 1;
                end if;
            else
                -- Defilement droite
                if state = 0 then state <= SIZE-1;
                else               state <= state - 1;
                end if;
            end if;
        end if;
    end process;

    -- Generation du motif : 4 LEDs allumees a partir de state
    process(state)
        variable v : std_logic_vector(SIZE-1 downto 0);
    begin
        v := (others => '0');
        for i in 0 to 3 loop
            v((state + i) mod SIZE) := '1';
        end loop;
        CHEN <= v;
    end process;

end behavioral;
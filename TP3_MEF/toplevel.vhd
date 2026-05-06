library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Description 
entity toplevel is
    port (
        CLOCK_50_B5B : in  std_logic;
        KEY          : in  std_logic_vector(3 downto 0);
        LEDG         : out std_logic_vector(7 downto 0)
    );
end entity toplevel;

architecture behavioral of toplevel is

    -- Composant bistable 
    component bistable is
        port (
            CLK : in  std_logic;
            RST : in  std_logic;
            X   : in  std_logic;
            Y   : out std_logic
        );
    end component bistable;

    -- Signaux internes
    signal clk      : std_logic;
    signal rst      : std_logic;

    -- Synchroniseur 2 bascules pour KEY[0]
    signal sync1    : std_logic := '1';
    signal sync2    : std_logic := '1';

    -- Detection de front descendant (appui = 1->0)
    signal btn_prev  : std_logic := '1';
    signal btn_pulse : std_logic := '0';

    -- Sortie du bistable
    signal led_state : std_logic;

begin

    clk <= CLOCK_50_B5B;
    rst <= KEY(3);  -- actif bas

    -- Instanciation du bistable
    U_bistable : bistable
        port map (
            CLK => clk,
            RST => rst,
            X   => btn_pulse,
            Y   => led_state
        );

    -- Toutes les LEDs vertes pilotees par la meme sortie Y
    LEDG <= (others => led_state);

    process(clk, rst)
    begin
        if rst = '0' then
            sync1 <= '1';
            sync2 <= '1';
        elsif rising_edge(clk) then
            sync1 <= KEY(0);
            sync2 <= sync1;
        end if;
    end process;

    -- Detection de front descendant sur sync2
    -- Genere une impulsion d'exactement 1 cycle CLK

    process(clk, rst)
    begin
        if rst = '0' then
            btn_prev  <= '1';
            btn_pulse <= '0';
        elsif rising_edge(clk) then
            btn_prev  <= sync2;
            if btn_prev = '1' and sync2 = '0' then
                btn_pulse <= '1';
            else
                btn_pulse <= '0';
            end if;
        end if;
    end process;

end behavioral;

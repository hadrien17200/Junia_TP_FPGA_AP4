library ieee;
use ieee.std_logic_1164.all;


entity toplevel is
    port (
        CLOCK_50_B6A : in  std_logic;
        KEY          : in  std_logic_vector(3 downto 0);
        LEDG         : out std_logic_vector(9 downto 0);
        LEDR         : out std_logic_vector(9 downto 0)
    );
end entity toplevel;

architecture behavioral of toplevel is

    component bistable
        port (
            CLK : in  std_logic;
            RST : in  std_logic;
            X   : in  std_logic;
            Y   : out std_logic
        );
    end component;

    component clock_divider
        port (
            CLKin  : in  std_logic;
            RST    : in  std_logic;
            N      : in  std_logic_vector(4 downto 0);
            CLKout : out std_logic
        );
    end component;

    component chenillard
        generic (SIZE : integer := 10);
        port (
            CLK  : in  std_logic;
            RST  : in  std_logic;
            DIR  : in  std_logic;
            CHEN : out std_logic_vector(SIZE-1 downto 0)
        );
    end component;

    signal speed_sel  : std_logic;  
    signal dir_sel    : std_logic;  

    signal clk_slow   : std_logic;  
    signal clk_fast   : std_logic;  
    signal clk_chen   : std_logic;  

begin

    -- Bistable de vitesse : KEY[0] fait alterner entre lent et rapide
    bist_speed : bistable
        port map (
            CLK => CLOCK_50_B6A,
            RST => KEY(2),
            X   => not KEY(0),  
            Y   => speed_sel
        );

    -- Bistable de direction : KEY[1] fait alterner la direction
    bist_dir : bistable
        port map (
            CLK => CLOCK_50_B6A,
            RST => KEY(2),
            X   => not KEY(1),
            Y   => dir_sel
        );

    -- Diviseur lent : bit 22 => ~6 Hz
    div_slow : clock_divider
        port map (
            CLKin  => CLOCK_50_B6A,
            RST    => KEY(2),
            N      => "10110",
            CLKout => clk_slow
        );

    -- Diviseur rapide : bit 19 => ~25 Hz
    div_fast : clock_divider
        port map (
            CLKin  => CLOCK_50_B6A,
            RST    => KEY(2),
            N      => "10011",
            CLKout => clk_fast
        );

    -- Selection de la vitesse d'horloge pour le chenillard
    clk_chen <= clk_fast when speed_sel = '1' else clk_slow;

    -- Chenillard vert : direction choisie par dir_sel
    chen_green : chenillard
        generic map (SIZE => 10)
        port map (
            CLK  => clk_chen,
            RST  => KEY(2),
            DIR  => dir_sel,
            CHEN => LEDG
        );

    -- Chenillard rouge : direction opposee a LEDG
    chen_red : chenillard
        generic map (SIZE => 10)
        port map (
            CLK  => clk_chen,
            RST  => KEY(2),
            DIR  => not dir_sel,
            CHEN => LEDR
        );

end behavioral;
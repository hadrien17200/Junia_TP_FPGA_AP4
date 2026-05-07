library ieee;
use ieee.std_logic_1164.all;


entity toplevel is
    port (
        CLOCK_50_B6A : in  std_logic;
        KEY          : in  std_logic_vector(3 downto 0);
        LEDR         : out std_logic_vector(9 downto 0)
    );
end entity;

architecture behavioral of toplevel is

    -- Declaration des composants
    component clock_divider
        port (
            CLKin  : in  std_logic;
            RST    : in  std_logic;
            N      : in  std_logic_vector(4 downto 0);
            CLKout : out std_logic
        );
    end component;
    
    component chenillard
        port (
            CLK  : in  std_logic;
            RST  : in  std_logic;
            CHEN : out std_logic_vector(9 downto 0)
        );
    end component;

    -- Signal interne : horloge lente entre clock_divider et chenillard
    signal CLK_slow : std_logic;

begin

    -- Instanciation du diviseur d'horloge
    div : clock_divider
        port map (
            CLKin  => CLOCK_50_B6A,
            RST    => KEY(0),       
            N      => "10110",      
            CLKout => CLK_slow
        );

    -- Instanciation du chenillard
    chen : chenillard
        port map (
            CLK  => CLK_slow,
            RST  => KEY(0),         
            CHEN => LEDR
        );

end behavioral;
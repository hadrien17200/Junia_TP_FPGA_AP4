library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;  

-- Description :
entity clock_divider is
    port (
        CLKin  : in  std_logic;                    
        RST    : in  std_logic;
        N      : in  std_logic_vector(4 downto 0);  
        CLKout : out std_logic
    );
end entity clock_divider;

-- Implémentation :
architecture behavioral of clock_divider is
    signal counter : std_logic_vector(23 downto 0) := (others => '0');
begin  

    -- Compteur synchrone 24 bits avec reset actif bas
    process(CLKin, RST)
    begin
        if RST = '0' then                    
            counter <= (others => '0');
        elsif rising_edge(CLKin) then
            counter <= counter + 1;
        end if;
    end process;

    -- Multiplexage : on sort le bit N du compteur
    CLKout <= counter(conv_integer(N));      

end behavioral;
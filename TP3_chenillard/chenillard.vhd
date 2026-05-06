library ieee;
use ieee.std_logic_1164.all;

-- Chenillard 10 bits

-- Description :
entity chenillard is
    port (
        CLK  : in  std_logic;
        RST  : in  std_logic;
        CHEN : out std_logic_vector(9 downto 0)
    );
end entity chenillard;

-- Implementation :
architecture behavioral of chenillard is
    signal state : integer range 0 to 9 := 0;
begin

    -- Compteur d'etat synchrone
    process(CLK, RST)
    begin
        if RST = '0' then              
            state <= 0;
        elsif rising_edge(CLK) then
            if state = 9 then          
                state <= 0;
            else
                state <= state + 1;
            end if;
        end if;
    end process;

    -- multiplexage des etats :
    process(state)
    begin
        case state is
            when 0 => CHEN <= "0000001111";
            when 1 => CHEN <= "0000011110";
            when 2 => CHEN <= "0000111100";
            when 3 => CHEN <= "0001111000";
            when 4 => CHEN <= "0011110000";
            when 5 => CHEN <= "0111100000";
            when 6 => CHEN <= "1111000000";
            when 7 => CHEN <= "1110000001";
            when 8 => CHEN <= "1100000011";
            when 9 => CHEN <= "1000000111";
            when others => CHEN <= "0000001111";
        end case;
    end process;

end behavioral;
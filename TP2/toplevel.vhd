library ieee;
use ieee.std_logic_1164.all;

-- Toplevel : Registre universel 8 bits sur carte FPGA

entity toplevel is
    port (
        SW   : in  std_logic_vector(9 downto 0);
        KEY  : in  std_logic_vector(3 downto 0);
        LEDG : out std_logic_vector(7 downto 0)
    );
end entity toplevel;

architecture behavioral of toplevel is
    -- Déclaration du composant du registre universel 8 bits
    component shift_register_universal8
        port (
            SSR  : in  std_logic;
            SSL  : in  std_logic;
            Pi   : in  std_logic_vector(7 downto 0);
            SEL  : in  std_logic_vector(2 downto 0);
            CLK  : in  std_logic;
            SETn : in  std_logic;
            RSTn : in  std_logic;
            SOR  : out std_logic;
            SOL  : out std_logic;
            Qo   : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Signaux internes
    signal SOR_unused : std_logic;
    signal SOL_unused : std_logic;

begin
    -- Instanciation du registre universel 8 bits
    reg : shift_register_universal8
        port map (
            SSR  => SW(9),              
            SSL  => SW(8),              
            Pi   => (others => '0'),    
            SEL  => SW(2 downto 0),     
            CLK  => not KEY(0),         
            SETn => KEY(2),             
            RSTn => KEY(3),             
            SOR  => SOR_unused,         
            SOL  => SOL_unused,         
            Qo   => LEDG(7 downto 0)    
        );

end behavioral;
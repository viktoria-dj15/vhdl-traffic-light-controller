library ieee;
use ieee.std_logic_1164.all;

entity bcd_to_7seg is
    port (
        digit   : in  std_logic_vector(3 downto 0);
        display : out std_logic_vector(6 downto 0)
    );
end bcd_to_7seg;

architecture Behavioral of bcd_to_7seg is
begin

    -- Raspored bita je display(6 downto 0).
    -- Segment n svetli ako je display(n) = '1'.
    -- Pretpostavka za segmente: 0-gore, 1-gore desno, 2-dole desno,
    -- 3-dole, 4-dole levo, 5-gore levo, 6-sredina.
    process(digit)
    begin
        case digit is
            when "0000" => display <= "0111111"; -- 0
            when "0001" => display <= "0000110"; -- 1
            when "0010" => display <= "1011011"; -- 2
            when "0011" => display <= "1001111"; -- 3
            when "0100" => display <= "1100110"; -- 4
            when "0101" => display <= "1101101"; -- 5
            when "0110" => display <= "1111101"; -- 6
            when "0111" => display <= "0000111"; -- 7
            when "1000" => display <= "1111111"; -- 8
            when "1001" => display <= "1101111"; -- 9
            when others => display <= "0000000"; -- nije BCD cifra, displej ugasen
        end case;
    end process;

end Behavioral;

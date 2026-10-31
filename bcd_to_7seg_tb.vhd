library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_to_7seg_tb is
end bcd_to_7seg_tb;

architecture Test of bcd_to_7seg_tb is

    signal digit   : std_logic_vector(3 downto 0) := "0000";
    signal display : std_logic_vector(6 downto 0);

begin

    DUT : entity work.bcd_to_7seg
        port map (
            digit   => digit,
            display => display
        );

    STIMULUS : process
    begin
        for i in 0 to 15 loop
            digit <= std_logic_vector(to_unsigned(i, 4));
            wait for 20 ns;
        end loop;
        wait;
    end process;

end Test;

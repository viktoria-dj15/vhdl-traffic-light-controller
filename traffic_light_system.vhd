library ieee;
use ieee.std_logic_1164.all;

entity traffic_light_system is
    port (
        clk      : in  std_logic;
        reset    : in  std_logic;
        rc       : out std_logic;
        gc       : out std_logic;
        yc       : out std_logic;
        rp       : out std_logic;
        gp       : out std_logic;
        display0 : out std_logic_vector(6 downto 0); -- desetice
        display1 : out std_logic_vector(6 downto 0)  -- jedinice
    );
end traffic_light_system;

architecture Structural of traffic_light_system is

    signal time_d1_s : std_logic_vector(3 downto 0); -- jedinice
    signal time_d2_s : std_logic_vector(3 downto 0); -- desetice

begin

    TL_i : entity work.traffic_light
        port map (
            clk     => clk,
            reset   => reset,
            rc      => rc,
            gc      => gc,
            yc      => yc,
            rp      => rp,
            gp      => gp,
            time_d1 => time_d1_s,
            time_d2 => time_d2_s
        );

    BCD_TENS_i : entity work.bcd_to_7seg
        port map (
            digit   => time_d2_s,
            display => display1
        );

    BCD_UNITS_i : entity work.bcd_to_7seg
        port map (
            digit   => time_d1_s,
            display => display0
        );

end Structural;

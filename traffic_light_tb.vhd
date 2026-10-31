library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity traffic_light_tb is
end traffic_light_tb;

architecture Test of traffic_light_tb is

    signal clk     : std_logic := '0';
    signal reset   : std_logic := '0';
    signal rc      : std_logic;
    signal gc      : std_logic;
    signal yc      : std_logic;
    signal rp      : std_logic;
    signal gp      : std_logic;
    signal time_d1 : std_logic_vector(3 downto 0);
    signal time_d2 : std_logic_vector(3 downto 0);

    constant C_CLK_PERIOD : time := 125 ms; -- 8 Hz
    signal sim_done : boolean := false;

begin

    DUT : entity work.traffic_light
        port map (
            clk     => clk,
            reset   => reset,
            rc      => rc,
            gc      => gc,
            yc      => yc,
            rp      => rp,
            gp      => gp,
            time_d1 => time_d1,
            time_d2 => time_d2
        );

    CLK_GEN : process
    begin
        while sim_done = false loop
            clk <= '0';
            wait for C_CLK_PERIOD / 2;
            clk <= '1';
            wait for C_CLK_PERIOD / 2;
        end loop;
        wait;
    end process CLK_GEN;

    STIMULUS : process
    begin
        -- Reset je aktivan u logickoj jedinici.
        reset <= '1';
        wait for 3 * C_CLK_PERIOD;

        reset <= '0';
        wait for 40 sec;

        sim_done <= true;
        wait;
    end process STIMULUS;

end Test;

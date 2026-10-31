library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity traffic_light is
    port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        rc      : out std_logic; -- red for cars
        gc      : out std_logic; -- green for cars
        yc      : out std_logic; -- yellow for cars
        rp      : out std_logic; -- red for pedestrians
        gp      : out std_logic; -- green for pedestrians
        time_d1 : out std_logic_vector(3 downto 0); -- jedinice
        time_d2 : out std_logic_vector(3 downto 0)  -- desetice
    );
end traffic_light;

architecture Behavioral of traffic_light is

    type state_type is (
        redRed1,
        redGreen,
        redRed2,
        redYellowRed,
        greenRed,
        yellowRed
    );

    constant CLK_HZ : integer := 8;

    constant T_RED_RED_1      : integer := 2  * CLK_HZ; -- 2 s
    constant T_RED_GREEN      : integer := 9  * CLK_HZ; -- 9 s
    constant T_RED_RED_2      : integer := 2  * CLK_HZ; -- 2 s
    constant T_RED_YELLOW_RED : integer := 1  * CLK_HZ; -- 1 s
    constant T_GREEN_RED      : integer := 22 * CLK_HZ; -- 22 s
    constant T_YELLOW_RED     : integer := 1  * CLK_HZ; -- 1 s

    signal state   : state_type := redRed1;
    signal counter : integer range 0 to T_GREEN_RED := T_RED_RED_1;

begin

    -- Sekvencijalni deo: pamti stanje i odbrojava taktove.
    process(clk, reset)
    begin
        if reset = '1' then
            state   <= redRed1;
            counter <= T_RED_RED_1;

        elsif rising_edge(clk) then
            if counter = 1 then
                case state is
                    when redRed1 =>
                        state   <= redGreen;
                        counter <= T_RED_GREEN;

                    when redGreen =>
                        state   <= redRed2;
                        counter <= T_RED_RED_2;

                    when redRed2 =>
                        state   <= redYellowRed;
                        counter <= T_RED_YELLOW_RED;

                    when redYellowRed =>
                        state   <= greenRed;
                        counter <= T_GREEN_RED;

                    when greenRed =>
                        state   <= yellowRed;
                        counter <= T_YELLOW_RED;

                    when yellowRed =>
                        state   <= redRed1;
                        counter <= T_RED_RED_1;
                end case;
            else
                counter <= counter - 1;
            end if;
        end if;
    end process;

    -- Kombinacioni deo: svetla zavise samo od trenutnog stanja.
    process(state)
    begin
        rc <= '0';
        gc <= '0';
        yc <= '0';
        rp <= '0';
        gp <= '0';

        case state is
            when redRed1 =>
                rc <= '1';
                rp <= '1';

            when redGreen =>
                rc <= '1';
                gp <= '1';

            when redRed2 =>
                rc <= '1';
                rp <= '1';

            when redYellowRed =>
                rc <= '1';
                yc <= '1';
                rp <= '1';

            when greenRed =>
                gc <= '1';
                rp <= '1';

            when yellowRed =>
                yc <= '1';
                rp <= '1';
        end case;
    end process;

    -- Prikaz preostalog vremena samo u stanju greenRed.
    -- U svim ostalim stanjima saljemo 1111, sto bcd_to_7seg gasi displej.
    process(state, counter)
        variable sec_left : integer range 0 to 22;
        variable tens     : integer range 0 to 9;
        variable ones     : integer range 0 to 9;
    begin
        if state = greenRed then
            -- ceil(counter / 8): za 176..169 prikazuje 22,
            -- za 168..161 prikazuje 21, itd.
            sec_left := (counter + CLK_HZ - 1) / CLK_HZ;
            tens     := sec_left / 10;
            ones     := sec_left mod 10;

            time_d2 <= std_logic_vector(to_unsigned(tens, 4));
            time_d1 <= std_logic_vector(to_unsigned(ones, 4));
        else
            time_d2 <= "1111";
            time_d1 <= "1111";
        end if;
    end process;

end Behavioral;
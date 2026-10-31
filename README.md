# VHDL Traffic Light Controller

A traffic-light controller for vehicles and pedestrians, with a two-digit seven-segment countdown display. The project uses an 8 Hz clock and an active-high asynchronous reset.

## Project files

- `traffic_light.vhd`: six-state controller and countdown logic.
- `bcd_to_7seg.vhd`: active-high BCD-to-seven-segment decoder; inputs 10–15 blank the display.
- `traffic_light_system.vhd`: top-level integration of the controller and two decoders.
- `*_tb.vhd`: simulation testbenches for each module.
- `ode_domaci_izvestaj_0021_2024_0105_2024.docx.pdf`: original project report in Serbian.

## Traffic-light sequence

| State | Vehicle lights | Pedestrian lights | Duration |
| --- | --- | --- | --- |
| `redRed1` | Red | Red | 2 s |
| `redGreen` | Red | Green | 9 s |
| `redRed2` | Red | Red | 2 s |
| `redYellowRed` | Red and yellow | Red | 1 s |
| `greenRed` | Green | Red | 22 s |
| `yellowRed` | Yellow | Red | 1 s |

The cycle repeats every 37 seconds. The display shows remaining seconds during `greenRed` and is blank in other states. In the top-level port mapping, `display1` carries tens and `display0` carries units.

## Simulation

Compile the design files in this order: `bcd_to_7seg.vhd`, `traffic_light.vhd`, then `traffic_light_system.vhd`. Compile the relevant testbench after its design files.

The controller testbench runs for 40 seconds after reset. The system testbench runs continuously and writes `romFile.txt`; set a simulation stop time in your simulator. The supplied testbenches generate stimuli for waveform inspection and do not contain assertions.

The original VHDL sources and report are preserved as supplied. Simulation was not run during repository preparation.

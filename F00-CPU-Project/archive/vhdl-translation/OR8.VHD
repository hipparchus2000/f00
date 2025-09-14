-- ACTIVE-CAD-2-VHDL, 2.5.5.51, Mon Oct 04 00:10:41 1999

library IEEE;
use IEEE.std_logic_1164.all;
-- Simulation netlist only
-- synopsys translate_off
library UNISIM;
use UNISIM.vcomponents.all;
-- synopsys translate_on

entity OR8 is port (
	I0 : in STD_LOGIC;
	I1 : in STD_LOGIC;
	I2 : in STD_LOGIC;
	I3 : in STD_LOGIC;
	I4 : in STD_LOGIC;
	I5 : in STD_LOGIC;
	I6 : in STD_LOGIC;
	I7 : in STD_LOGIC;
	O : out STD_LOGIC
); end OR8;

architecture SCHEMATIC of OR8 is

--COMPONENTS

component OR4 port (
	I0 : in STD_LOGIC;
	I1 : in STD_LOGIC;
	I2 : in STD_LOGIC;
	I3 : in STD_LOGIC;
	O : out STD_LOGIC
); end component;

component OR3 port (
	I0 : in STD_LOGIC;
	I1 : in STD_LOGIC;
	I2 : in STD_LOGIC;
	O : out STD_LOGIC
); end component;

--SIGNALS

signal I13 : STD_LOGIC;
signal I47 : STD_LOGIC;


begin

--SIGNAL ASSIGNMENTS


--COMPONENT INSTANCES

X36_1I69 : OR4 port map(
	I0 => I4,
	I1 => I5,
	I2 => I6,
	I3 => I7,
	O => I47
);
X36_1I84 : OR3 port map(
	I0 => I1,
	I1 => I2,
	I2 => I3,
	O => I13
);
X36_1I85 : OR3 port map(
	I0 => I0,
	I1 => I13,
	I2 => I47,
	O => O
);

end SCHEMATIC;
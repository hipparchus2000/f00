-- ACTIVE-CAD-2-VHDL, 2.5.5.51, Mon Oct 18 23:53:02 1999

library IEEE;
use IEEE.std_logic_1164.all;
-- Simulation netlist only
-- synopsys translate_off
library UNISIM;
use UNISIM.vcomponents.all;
-- synopsys translate_on

entity M2_1 is port (
	D0 : in STD_LOGIC;
	D1 : in STD_LOGIC;
	O : out STD_LOGIC;
	S0 : in STD_LOGIC
); end M2_1;

architecture SCHEMATIC of M2_1 is

--COMPONENTS

component AND2B1 port (
	I0 : in STD_LOGIC;
	I1 : in STD_LOGIC;
	O : out STD_LOGIC
); end component;

component OR2 port (
	I0 : in STD_LOGIC;
	I1 : in STD_LOGIC;
	O : out STD_LOGIC
); end component;

component AND2 port (
	I0 : in STD_LOGIC;
	I1 : in STD_LOGIC;
	O : out STD_LOGIC
); end component;

--SIGNALS

signal M0 : STD_LOGIC;
signal M1 : STD_LOGIC;


begin

--SIGNAL ASSIGNMENTS


--COMPONENT INSTANCES

X36_1I7 : AND2B1 port map(
	I0 => S0,
	I1 => D0,
	O => M0
);
X36_1I8 : OR2 port map(
	I0 => M1,
	I1 => M0,
	O => O
);
X36_1I9 : AND2 port map(
	I0 => D1,
	I1 => S0,
	O => M1
);

end SCHEMATIC;
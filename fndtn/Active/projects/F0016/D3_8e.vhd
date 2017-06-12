-- ACTIVE-CAD-2-VHDL, 2.5.5.51, Mon Oct 18 23:52:12 1999

library IEEE;
use IEEE.std_logic_1164.all;
-- Simulation netlist only
-- synopsys translate_off
library UNISIM;
use UNISIM.vcomponents.all;
-- synopsys translate_on

entity D3_8E is port (
	A0 : in STD_LOGIC;
	A1 : in STD_LOGIC;
	A2 : in STD_LOGIC;
	D0 : out STD_LOGIC;
	D1 : out STD_LOGIC;
	D2 : out STD_LOGIC;
	D3 : out STD_LOGIC;
	D4 : out STD_LOGIC;
	D5 : out STD_LOGIC;
	D6 : out STD_LOGIC;
	D7 : out STD_LOGIC;
	E : in STD_LOGIC
); end D3_8E;

architecture SCHEMATIC of D3_8E is

--COMPONENTS

component AND4 port (
	I0 : in STD_LOGIC;
	I1 : in STD_LOGIC;
	I2 : in STD_LOGIC;
	I3 : in STD_LOGIC;
	O : out STD_LOGIC
); end component;

component AND4B1 port (
	I0 : in STD_LOGIC;
	I1 : in STD_LOGIC;
	I2 : in STD_LOGIC;
	I3 : in STD_LOGIC;
	O : out STD_LOGIC
); end component;

component AND4B2 port (
	I0 : in STD_LOGIC;
	I1 : in STD_LOGIC;
	I2 : in STD_LOGIC;
	I3 : in STD_LOGIC;
	O : out STD_LOGIC
); end component;

component AND4B3 port (
	I0 : in STD_LOGIC;
	I1 : in STD_LOGIC;
	I2 : in STD_LOGIC;
	I3 : in STD_LOGIC;
	O : out STD_LOGIC
); end component;

--SIGNALS



begin

--SIGNAL ASSIGNMENTS


--COMPONENT INSTANCES

X36_1I30 : AND4 port map(
	I0 => A2,
	I1 => A1,
	I2 => A0,
	I3 => E,
	O => D7
);
X36_1I31 : AND4B1 port map(
	I0 => A0,
	I1 => A2,
	I2 => A1,
	I3 => E,
	O => D6
);
X36_1I32 : AND4B1 port map(
	I0 => A1,
	I1 => A2,
	I2 => A0,
	I3 => E,
	O => D5
);
X36_1I33 : AND4B2 port map(
	I0 => A1,
	I1 => A0,
	I2 => A2,
	I3 => E,
	O => D4
);
X36_1I34 : AND4B1 port map(
	I0 => A2,
	I1 => A0,
	I2 => A1,
	I3 => E,
	O => D3
);
X36_1I35 : AND4B2 port map(
	I0 => A2,
	I1 => A0,
	I2 => A1,
	I3 => E,
	O => D2
);
X36_1I36 : AND4B2 port map(
	I0 => A2,
	I1 => A1,
	I2 => A0,
	I3 => E,
	O => D1
);
X36_1I37 : AND4B3 port map(
	I0 => A2,
	I1 => A1,
	I2 => A0,
	I3 => E,
	O => D0
);

end SCHEMATIC;
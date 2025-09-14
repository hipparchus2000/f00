-- ACTIVE-CAD-2-VHDL, 2.5.5.51, Mon Oct 04 00:10:55 1999

library IEEE;
use IEEE.std_logic_1164.all;
-- Simulation netlist only
-- synopsys translate_off
library UNISIM;
use UNISIM.vcomponents.all;
-- synopsys translate_on

entity BUFE is port (
	E : in STD_LOGIC;
	I : in STD_LOGIC;
	O : out STD_LOGIC
); end BUFE;

architecture SCHEMATIC of BUFE is

--COMPONENTS

component BUFT port (
	T : in STD_LOGIC;
	I : in STD_LOGIC;
	O : out STD_LOGIC
); end component;

component INV port (
	I : in STD_LOGIC;
	O : out STD_LOGIC
); end component;

--SIGNALS

signal T : STD_LOGIC;


begin

--SIGNAL ASSIGNMENTS


--COMPONENT INSTANCES

X36_1I10 : BUFT port map(
	T => T,
	I => I,
	O => O
);
X36_1I12 : INV port map(
	I => E,
	O => T
);

end SCHEMATIC;
-- ACTIVE-CAD-2-VHDL, 2.5.5.51, Mon Oct 18 23:52:13 1999

library IEEE;
use IEEE.std_logic_1164.all;
-- Simulation netlist only
-- synopsys translate_off
library UNISIM;
use UNISIM.vcomponents.all;
-- synopsys translate_on

entity BUFE8 is port (
	I : in STD_LOGIC_VECTOR (7 downto 0);
	O : out STD_LOGIC_VECTOR (7 downto 0);
	E : in STD_LOGIC
); end BUFE8;

architecture SCHEMATIC of BUFE8 is

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

X36_1I30 : BUFT port map(
	T => T,
	I => I(0),
	O => O(0)
);
X36_1I31 : BUFT port map(
	T => T,
	I => I(1),
	O => O(1)
);
X36_1I32 : BUFT port map(
	T => T,
	I => I(2),
	O => O(2)
);
X36_1I33 : BUFT port map(
	T => T,
	I => I(3),
	O => O(3)
);
X36_1I34 : BUFT port map(
	T => T,
	I => I(7),
	O => O(7)
);
X36_1I35 : BUFT port map(
	T => T,
	I => I(6),
	O => O(6)
);
X36_1I36 : BUFT port map(
	T => T,
	I => I(5),
	O => O(5)
);
X36_1I37 : BUFT port map(
	T => T,
	I => I(4),
	O => O(4)
);
X36_1I51 : INV port map(
	I => E,
	O => T
);

end SCHEMATIC;
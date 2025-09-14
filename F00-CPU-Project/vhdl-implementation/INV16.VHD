-- ACTIVE-CAD-2-VHDL, 2.5.5.51, Mon Oct 04 00:10:23 1999

library IEEE;
use IEEE.std_logic_1164.all;
-- Simulation netlist only
-- synopsys translate_off
library UNISIM;
use UNISIM.vcomponents.all;
-- synopsys translate_on

entity INV16 is port (
	I : in STD_LOGIC_VECTOR (15 downto 0);
	O : out STD_LOGIC_VECTOR (15 downto 0)
); end INV16;

architecture SCHEMATIC of INV16 is

--COMPONENTS

component INV port (
	I : in STD_LOGIC;
	O : out STD_LOGIC
); end component;

--SIGNALS



begin

--SIGNAL ASSIGNMENTS


--COMPONENT INSTANCES

X36_1I30 : INV port map(
	I => I(8),
	O => O(8)
);
X36_1I31 : INV port map(
	I => I(9),
	O => O(9)
);
X36_1I32 : INV port map(
	I => I(10),
	O => O(10)
);
X36_1I33 : INV port map(
	I => I(11),
	O => O(11)
);
X36_1I34 : INV port map(
	I => I(15),
	O => O(15)
);
X36_1I35 : INV port map(
	I => I(14),
	O => O(14)
);
X36_1I36 : INV port map(
	I => I(13),
	O => O(13)
);
X36_1I37 : INV port map(
	I => I(12),
	O => O(12)
);
X36_1I38 : INV port map(
	I => I(4),
	O => O(4)
);
X36_1I39 : INV port map(
	I => I(5),
	O => O(5)
);
X36_1I40 : INV port map(
	I => I(6),
	O => O(6)
);
X36_1I41 : INV port map(
	I => I(7),
	O => O(7)
);
X36_1I42 : INV port map(
	I => I(3),
	O => O(3)
);
X36_1I43 : INV port map(
	I => I(2),
	O => O(2)
);
X36_1I44 : INV port map(
	I => I(1),
	O => O(1)
);
X36_1I45 : INV port map(
	I => I(0),
	O => O(0)
);

end SCHEMATIC;
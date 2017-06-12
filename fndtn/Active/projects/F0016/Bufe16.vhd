-- ACTIVE-CAD-2-VHDL, 2.5.5.51, Mon Oct 18 23:52:50 1999

library IEEE;
use IEEE.std_logic_1164.all;
-- Simulation netlist only
-- synopsys translate_off
library UNISIM;
use UNISIM.vcomponents.all;
-- synopsys translate_on

entity BUFE16 is port (
	I : in STD_LOGIC_VECTOR (15 downto 0);
	O : out STD_LOGIC_VECTOR (15 downto 0);
	E : in STD_LOGIC
); end BUFE16;

architecture SCHEMATIC of BUFE16 is

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
	I => I(8),
	O => O(8)
);
X36_1I31 : BUFT port map(
	T => T,
	I => I(9),
	O => O(9)
);
X36_1I32 : BUFT port map(
	T => T,
	I => I(10),
	O => O(10)
);
X36_1I33 : BUFT port map(
	T => T,
	I => I(11),
	O => O(11)
);
X36_1I34 : BUFT port map(
	T => T,
	I => I(15),
	O => O(15)
);
X36_1I35 : BUFT port map(
	T => T,
	I => I(14),
	O => O(14)
);
X36_1I36 : BUFT port map(
	T => T,
	I => I(13),
	O => O(13)
);
X36_1I37 : BUFT port map(
	T => T,
	I => I(12),
	O => O(12)
);
X36_1I38 : BUFT port map(
	T => T,
	I => I(6),
	O => O(6)
);
X36_1I39 : BUFT port map(
	T => T,
	I => I(7),
	O => O(7)
);
X36_1I40 : BUFT port map(
	T => T,
	I => I(0),
	O => O(0)
);
X36_1I41 : BUFT port map(
	T => T,
	I => I(1),
	O => O(1)
);
X36_1I42 : BUFT port map(
	T => T,
	I => I(2),
	O => O(2)
);
X36_1I43 : BUFT port map(
	T => T,
	I => I(3),
	O => O(3)
);
X36_1I44 : BUFT port map(
	T => T,
	I => I(4),
	O => O(4)
);
X36_1I45 : BUFT port map(
	T => T,
	I => I(5),
	O => O(5)
);
X36_1I66 : INV port map(
	I => E,
	O => T
);

end SCHEMATIC;
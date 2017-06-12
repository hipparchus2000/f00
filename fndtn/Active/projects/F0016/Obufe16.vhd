-- ACTIVE-CAD-2-VHDL, 2.5.5.51, Mon Oct 18 23:52:47 1999

library IEEE;
use IEEE.std_logic_1164.all;
-- Simulation netlist only
-- synopsys translate_off
library UNISIM;
use UNISIM.vcomponents.all;
-- synopsys translate_on

entity OBUFE16 is port (
	I : in STD_LOGIC_VECTOR (15 downto 0);
	O : out STD_LOGIC_VECTOR (15 downto 0);
	E : in STD_LOGIC
); end OBUFE16;

architecture SCHEMATIC of OBUFE16 is

--COMPONENTS

component OBUFE port (
	E : in STD_LOGIC;
	I : in STD_LOGIC;
	O : out STD_LOGIC
); end component;

--SIGNALS



begin

--SIGNAL ASSIGNMENTS


--COMPONENT INSTANCES

X36_1I30 : OBUFE port map(
	E => E,
	I => I(8),
	O => O(8)
);
X36_1I31 : OBUFE port map(
	E => E,
	I => I(9),
	O => O(9)
);
X36_1I32 : OBUFE port map(
	E => E,
	I => I(10),
	O => O(10)
);
X36_1I33 : OBUFE port map(
	E => E,
	I => I(11),
	O => O(11)
);
X36_1I34 : OBUFE port map(
	E => E,
	I => I(15),
	O => O(15)
);
X36_1I35 : OBUFE port map(
	E => E,
	I => I(14),
	O => O(14)
);
X36_1I36 : OBUFE port map(
	E => E,
	I => I(13),
	O => O(13)
);
X36_1I37 : OBUFE port map(
	E => E,
	I => I(12),
	O => O(12)
);
X36_1I38 : OBUFE port map(
	E => E,
	I => I(6),
	O => O(6)
);
X36_1I39 : OBUFE port map(
	E => E,
	I => I(7),
	O => O(7)
);
X36_1I40 : OBUFE port map(
	E => E,
	I => I(0),
	O => O(0)
);
X36_1I41 : OBUFE port map(
	E => E,
	I => I(1),
	O => O(1)
);
X36_1I42 : OBUFE port map(
	E => E,
	I => I(2),
	O => O(2)
);
X36_1I43 : OBUFE port map(
	E => E,
	I => I(3),
	O => O(3)
);
X36_1I44 : OBUFE port map(
	E => E,
	I => I(4),
	O => O(4)
);
X36_1I45 : OBUFE port map(
	E => E,
	I => I(5),
	O => O(5)
);

end SCHEMATIC;
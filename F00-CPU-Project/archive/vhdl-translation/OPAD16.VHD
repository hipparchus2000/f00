-- ACTIVE-CAD-2-VHDL, 2.5.5.51, Mon Oct 04 00:13:52 1999

library IEEE;
use IEEE.std_logic_1164.all;
-- Simulation netlist only
-- synopsys translate_off
library UNISIM;
use UNISIM.vcomponents.all;
-- synopsys translate_on

entity OPAD16 is port (
	O : in STD_LOGIC_VECTOR (15 downto 0)
); end OPAD16;

architecture SCHEMATIC of OPAD16 is

--COMPONENTS

component OPAD port (
	OPAD : in STD_LOGIC
); end component;

--SIGNALS



begin

--SIGNAL ASSIGNMENTS


--COMPONENT INSTANCES

X36_1I66 : OPAD port map(
	OPAD => O(0)
);
X36_1I67 : OPAD port map(
	OPAD => O(1)
);
X36_1I68 : OPAD port map(
	OPAD => O(2)
);
X36_1I69 : OPAD port map(
	OPAD => O(3)
);
X36_1I70 : OPAD port map(
	OPAD => O(4)
);
X36_1I71 : OPAD port map(
	OPAD => O(5)
);
X36_1I72 : OPAD port map(
	OPAD => O(6)
);
X36_1I73 : OPAD port map(
	OPAD => O(7)
);
X36_1I74 : OPAD port map(
	OPAD => O(8)
);
X36_1I75 : OPAD port map(
	OPAD => O(9)
);
X36_1I76 : OPAD port map(
	OPAD => O(10)
);
X36_1I77 : OPAD port map(
	OPAD => O(11)
);
X36_1I78 : OPAD port map(
	OPAD => O(12)
);
X36_1I79 : OPAD port map(
	OPAD => O(13)
);
X36_1I80 : OPAD port map(
	OPAD => O(14)
);
X36_1I81 : OPAD port map(
	OPAD => O(15)
);

end SCHEMATIC;
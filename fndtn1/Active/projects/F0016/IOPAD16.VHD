-- ACTIVE-CAD-2-VHDL, 2.5.5.51, Mon Oct 04 00:12:57 1999

library IEEE;
use IEEE.std_logic_1164.all;
-- Simulation netlist only
-- synopsys translate_off
library UNISIM;
use UNISIM.vcomponents.all;
-- synopsys translate_on

entity IOPAD16 is port (
	IO : inout STD_LOGIC_VECTOR (15 downto 0)
); end IOPAD16;

architecture SCHEMATIC of IOPAD16 is

--COMPONENTS

component IOPAD port (
	IOPAD : inout STD_LOGIC
); end component;

--SIGNALS



begin

--SIGNAL ASSIGNMENTS


--COMPONENT INSTANCES

X36_1I30 : IOPAD port map(
	IOPAD => IO(8)
);
X36_1I31 : IOPAD port map(
	IOPAD => IO(9)
);
X36_1I32 : IOPAD port map(
	IOPAD => IO(10)
);
X36_1I33 : IOPAD port map(
	IOPAD => IO(11)
);
X36_1I34 : IOPAD port map(
	IOPAD => IO(15)
);
X36_1I35 : IOPAD port map(
	IOPAD => IO(14)
);
X36_1I36 : IOPAD port map(
	IOPAD => IO(13)
);
X36_1I37 : IOPAD port map(
	IOPAD => IO(12)
);
X36_1I38 : IOPAD port map(
	IOPAD => IO(4)
);
X36_1I39 : IOPAD port map(
	IOPAD => IO(5)
);
X36_1I40 : IOPAD port map(
	IOPAD => IO(6)
);
X36_1I41 : IOPAD port map(
	IOPAD => IO(7)
);
X36_1I42 : IOPAD port map(
	IOPAD => IO(3)
);
X36_1I43 : IOPAD port map(
	IOPAD => IO(2)
);
X36_1I44 : IOPAD port map(
	IOPAD => IO(1)
);
X36_1I45 : IOPAD port map(
	IOPAD => IO(0)
);

end SCHEMATIC;
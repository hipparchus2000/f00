-- ACTIVE-CAD-2-VHDL, 2.5.5.51, Mon Oct 18 23:52:14 1999

library IEEE;
use IEEE.std_logic_1164.all;
-- Simulation netlist only
-- synopsys translate_off
library UNISIM;
use UNISIM.vcomponents.all;
-- synopsys translate_on

entity RAM32X8S is port (
	D : in STD_LOGIC_VECTOR (7 downto 0);
	O : out STD_LOGIC_VECTOR (7 downto 0);
	A0 : in STD_LOGIC;
	A1 : in STD_LOGIC;
	A2 : in STD_LOGIC;
	A3 : in STD_LOGIC;
	A4 : in STD_LOGIC;
	WCLK : in STD_LOGIC;
	WE : in STD_LOGIC
); end RAM32X8S;

architecture SCHEMATIC of RAM32X8S is

--COMPONENTS

component RAM32X1S port (
	WE : in STD_LOGIC;
	D : in STD_LOGIC;
	WCLK : in STD_LOGIC;
	A0 : in STD_LOGIC;
	A1 : in STD_LOGIC;
	A2 : in STD_LOGIC;
	A3 : in STD_LOGIC;
	A4 : in STD_LOGIC;
	O : out STD_LOGIC
); end component;

--SIGNALS



begin

--SIGNAL ASSIGNMENTS


--COMPONENT INSTANCES

O0_COMP : RAM32X1S port map(
	WE => WE,
	D => D(0),
	WCLK => WCLK,
	A0 => A0,
	A1 => A1,
	A2 => A2,
	A3 => A3,
	A4 => A4,
	O => O(0)
);
O1_COMP : RAM32X1S port map(
	WE => WE,
	D => D(1),
	WCLK => WCLK,
	A0 => A0,
	A1 => A1,
	A2 => A2,
	A3 => A3,
	A4 => A4,
	O => O(1)
);
O2_COMP : RAM32X1S port map(
	WE => WE,
	D => D(2),
	WCLK => WCLK,
	A0 => A0,
	A1 => A1,
	A2 => A2,
	A3 => A3,
	A4 => A4,
	O => O(2)
);
O3_COMP : RAM32X1S port map(
	WE => WE,
	D => D(3),
	WCLK => WCLK,
	A0 => A0,
	A1 => A1,
	A2 => A2,
	A3 => A3,
	A4 => A4,
	O => O(3)
);
O4_COMP : RAM32X1S port map(
	WE => WE,
	D => D(4),
	WCLK => WCLK,
	A0 => A0,
	A1 => A1,
	A2 => A2,
	A3 => A3,
	A4 => A4,
	O => O(4)
);
O5_COMP : RAM32X1S port map(
	WE => WE,
	D => D(5),
	WCLK => WCLK,
	A0 => A0,
	A1 => A1,
	A2 => A2,
	A3 => A3,
	A4 => A4,
	O => O(5)
);
O6_COMP : RAM32X1S port map(
	WE => WE,
	D => D(6),
	WCLK => WCLK,
	A0 => A0,
	A1 => A1,
	A2 => A2,
	A3 => A3,
	A4 => A4,
	O => O(6)
);
O7_COMP : RAM32X1S port map(
	WE => WE,
	D => D(7),
	WCLK => WCLK,
	A0 => A0,
	A1 => A1,
	A2 => A2,
	A3 => A3,
	A4 => A4,
	O => O(7)
);

end SCHEMATIC;
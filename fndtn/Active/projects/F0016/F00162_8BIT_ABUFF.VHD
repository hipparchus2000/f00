-- ACTIVE-CAD-2-VHDL, 2.5.5.51, Mon Oct 18 23:53:06 1999

library IEEE;
use IEEE.std_logic_1164.all;
-- Simulation netlist only
-- synopsys translate_off
library UNISIM;
use UNISIM.vcomponents.all;
-- synopsys translate_on

entity F00162_8BIT_ABUFF is port (
	A : in STD_LOGIC_VECTOR (7 downto 0);
	O : out STD_LOGIC_VECTOR (7 downto 0);
	AENABLE : in STD_LOGIC
); end F00162_8BIT_ABUFF;

architecture SCHEMATIC of F00162_8BIT_ABUFF is

--COMPONENTS

component AND2 port (
	I0 : in STD_LOGIC;
	I1 : in STD_LOGIC;
	O : out STD_LOGIC
); end component;

--SIGNALS



begin

--SIGNAL ASSIGNMENTS


--COMPONENT INSTANCES

X36_I193 : AND2 port map(
	I0 => A(1),
	I1 => AENABLE,
	O => O(1)
);
X36_I194 : AND2 port map(
	I0 => A(2),
	I1 => AENABLE,
	O => O(2)
);
X36_I195 : AND2 port map(
	I0 => A(3),
	I1 => AENABLE,
	O => O(3)
);
X36_I196 : AND2 port map(
	I0 => A(4),
	I1 => AENABLE,
	O => O(4)
);
X36_I197 : AND2 port map(
	I0 => A(5),
	I1 => AENABLE,
	O => O(5)
);
X36_I198 : AND2 port map(
	I0 => A(6),
	I1 => AENABLE,
	O => O(6)
);
X36_I199 : AND2 port map(
	I0 => A(7),
	I1 => AENABLE,
	O => O(7)
);
X36_I200 : AND2 port map(
	I0 => A(0),
	I1 => AENABLE,
	O => O(0)
);

end SCHEMATIC;
-- ACTIVE-CAD-2-VHDL, 2.5.5.51, Mon Oct 18 23:52:59 1999

library IEEE;
use IEEE.std_logic_1164.all;
-- Simulation netlist only
-- synopsys translate_off
library UNISIM;
use UNISIM.vcomponents.all;
-- synopsys translate_on

entity F00162_16BIT_ABUFF is port (
	A : in STD_LOGIC_VECTOR (15 downto 0);
	O : out STD_LOGIC_VECTOR (15 downto 0);
	AENABLE : in STD_LOGIC
); end F00162_16BIT_ABUFF;

architecture SCHEMATIC of F00162_16BIT_ABUFF is

--COMPONENTS

component F00162_8BIT_ABUFF port (
	A : in STD_LOGIC_VECTOR (7 downto 0);
	O : out STD_LOGIC_VECTOR (7 downto 0);
	AENABLE : in STD_LOGIC
); end component;

--SIGNALS



begin

--SIGNAL ASSIGNMENTS


--COMPONENT INSTANCES

H5 : F00162_8BIT_ABUFF port map(
	A(7) => A(7),
	A(6) => A(6),
	A(5) => A(5),
	A(4) => A(4),
	A(3) => A(3),
	A(2) => A(2),
	A(1) => A(1),
	A(0) => A(0),
	O(7) => O(7),
	O(6) => O(6),
	O(5) => O(5),
	O(4) => O(4),
	O(3) => O(3),
	O(2) => O(2),
	O(1) => O(1),
	O(0) => O(0),
	AENABLE => AENABLE
);
H6 : F00162_8BIT_ABUFF port map(
	A(7) => A(15),
	A(6) => A(14),
	A(5) => A(13),
	A(4) => A(12),
	A(3) => A(11),
	A(2) => A(10),
	A(1) => A(9),
	A(0) => A(8),
	O(7) => O(15),
	O(6) => O(14),
	O(5) => O(13),
	O(4) => O(12),
	O(3) => O(11),
	O(2) => O(10),
	O(1) => O(9),
	O(0) => O(8),
	AENABLE => AENABLE
);

end SCHEMATIC;
-- ACTIVE-CAD-2-VHDL, 2.5.5.51, Mon Oct 18 23:53:00 1999

library IEEE;
use IEEE.std_logic_1164.all;
-- Simulation netlist only
-- synopsys translate_off
library UNISIM;
use UNISIM.vcomponents.all;
-- synopsys translate_on

entity F00165_16BITX5ORTO16 is port (
	A : in STD_LOGIC_VECTOR (15 downto 0);
	B : in STD_LOGIC_VECTOR (15 downto 0);
	C : in STD_LOGIC_VECTOR (15 downto 0);
	D : in STD_LOGIC_VECTOR (15 downto 0);
	E : in STD_LOGIC_VECTOR (15 downto 0);
	O : out STD_LOGIC_VECTOR (15 downto 0)
); end F00165_16BITX5ORTO16;

architecture SCHEMATIC of F00165_16BITX5ORTO16 is

--COMPONENTS

component OR5 port (
	I0 : in STD_LOGIC;
	I1 : in STD_LOGIC;
	I2 : in STD_LOGIC;
	I3 : in STD_LOGIC;
	I4 : in STD_LOGIC;
	O : out STD_LOGIC
); end component;

--SIGNALS



begin

--SIGNAL ASSIGNMENTS


--COMPONENT INSTANCES

X36_I199 : OR5 port map(
	I0 => E(15),
	I1 => D(15),
	I2 => C(15),
	I3 => B(15),
	I4 => A(15),
	O => O(15)
);
X36_I200 : OR5 port map(
	I0 => E(14),
	I1 => D(14),
	I2 => C(14),
	I3 => B(14),
	I4 => A(14),
	O => O(14)
);
X36_I201 : OR5 port map(
	I0 => E(13),
	I1 => D(13),
	I2 => C(13),
	I3 => B(13),
	I4 => A(13),
	O => O(13)
);
X36_I202 : OR5 port map(
	I0 => E(12),
	I1 => D(12),
	I2 => C(12),
	I3 => B(12),
	I4 => A(12),
	O => O(12)
);
X36_I203 : OR5 port map(
	I0 => E(11),
	I1 => D(11),
	I2 => C(11),
	I3 => B(11),
	I4 => A(11),
	O => O(11)
);
X36_I204 : OR5 port map(
	I0 => E(10),
	I1 => D(10),
	I2 => C(10),
	I3 => B(10),
	I4 => A(10),
	O => O(10)
);
X36_I205 : OR5 port map(
	I0 => E(9),
	I1 => D(9),
	I2 => C(9),
	I3 => B(9),
	I4 => A(9),
	O => O(9)
);
X36_I206 : OR5 port map(
	I0 => E(8),
	I1 => D(8),
	I2 => C(8),
	I3 => B(8),
	I4 => A(8),
	O => O(8)
);
X36_I207 : OR5 port map(
	I0 => E(7),
	I1 => D(7),
	I2 => C(7),
	I3 => B(7),
	I4 => A(7),
	O => O(7)
);
X36_I208 : OR5 port map(
	I0 => E(6),
	I1 => D(6),
	I2 => C(6),
	I3 => B(6),
	I4 => A(6),
	O => O(6)
);
X36_I209 : OR5 port map(
	I0 => E(5),
	I1 => D(5),
	I2 => C(5),
	I3 => B(5),
	I4 => A(5),
	O => O(5)
);
X36_I210 : OR5 port map(
	I0 => E(4),
	I1 => D(4),
	I2 => C(4),
	I3 => B(4),
	I4 => A(4),
	O => O(4)
);
X36_I211 : OR5 port map(
	I0 => E(3),
	I1 => D(3),
	I2 => C(3),
	I3 => B(3),
	I4 => A(3),
	O => O(3)
);
X36_I212 : OR5 port map(
	I0 => E(2),
	I1 => D(2),
	I2 => C(2),
	I3 => B(2),
	I4 => A(2),
	O => O(2)
);
X36_I213 : OR5 port map(
	I0 => E(1),
	I1 => D(1),
	I2 => C(1),
	I3 => B(1),
	I4 => A(1),
	O => O(1)
);
X36_I214 : OR5 port map(
	I0 => E(0),
	I1 => D(0),
	I2 => C(0),
	I3 => B(0),
	I4 => A(0),
	O => O(0)
);

end SCHEMATIC;
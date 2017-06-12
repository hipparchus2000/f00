-- ACTIVE-CAD-2-VHDL, 2.5.5.51, Mon Oct 18 23:52:16 1999

library IEEE;
use IEEE.std_logic_1164.all;
-- Simulation netlist only
-- synopsys translate_off
library UNISIM;
use UNISIM.vcomponents.all;
-- synopsys translate_on

entity F00162_8BIT_2CHANMUX is port (
	A : in STD_LOGIC_VECTOR (7 downto 0);
	B : in STD_LOGIC_VECTOR (7 downto 0);
	O : out STD_LOGIC_VECTOR (7 downto 0);
	A_NOT_B : in STD_LOGIC
); end F00162_8BIT_2CHANMUX;

architecture SCHEMATIC of F00162_8BIT_2CHANMUX is

--COMPONENTS

component AND2 port (
	I0 : in STD_LOGIC;
	I1 : in STD_LOGIC;
	O : out STD_LOGIC
); end component;

component INV port (
	I : in STD_LOGIC;
	O : out STD_LOGIC
); end component;

component OR2 port (
	I0 : in STD_LOGIC;
	I1 : in STD_LOGIC;
	O : out STD_LOGIC
); end component;

--SIGNALS

signal X36_NET00023_X95 : STD_LOGIC;
signal X36_NET00065_X95 : STD_LOGIC;
signal X36_NET00064_X95 : STD_LOGIC;
signal X36_NET00058_X95 : STD_LOGIC;
signal X36_NET00059_X95 : STD_LOGIC;
signal X36_NET00060_X95 : STD_LOGIC;
signal X36_NET00061_X95 : STD_LOGIC;
signal X36_NET00062_X95 : STD_LOGIC;
signal X36_NET00063_X95 : STD_LOGIC;
signal X36_NET00042_X95 : STD_LOGIC;
signal X36_NET00043_X95 : STD_LOGIC;
signal X36_NET00044_X95 : STD_LOGIC;
signal X36_NET00045_X95 : STD_LOGIC;
signal X36_NET00046_X95 : STD_LOGIC;
signal X36_NET00047_X95 : STD_LOGIC;
signal X36_NET00048_X95 : STD_LOGIC;
signal X36_NET00049_X95 : STD_LOGIC;


begin

--SIGNAL ASSIGNMENTS


--COMPONENT INSTANCES

X36_I193 : AND2 port map(
	I0 => A(1),
	I1 => A_NOT_B,
	O => X36_NET00043_X95
);
X36_I194 : AND2 port map(
	I0 => A(2),
	I1 => A_NOT_B,
	O => X36_NET00044_X95
);
X36_I195 : AND2 port map(
	I0 => A(3),
	I1 => A_NOT_B,
	O => X36_NET00045_X95
);
X36_I196 : AND2 port map(
	I0 => A(4),
	I1 => A_NOT_B,
	O => X36_NET00046_X95
);
X36_I197 : AND2 port map(
	I0 => A(5),
	I1 => A_NOT_B,
	O => X36_NET00047_X95
);
X36_I198 : AND2 port map(
	I0 => A(6),
	I1 => A_NOT_B,
	O => X36_NET00048_X95
);
X36_I199 : AND2 port map(
	I0 => A(7),
	I1 => A_NOT_B,
	O => X36_NET00049_X95
);
X36_I200 : AND2 port map(
	I0 => A(0),
	I1 => A_NOT_B,
	O => X36_NET00042_X95
);
X36_I201 : AND2 port map(
	I0 => B(1),
	I1 => X36_NET00023_X95,
	O => X36_NET00059_X95
);
X36_I202 : AND2 port map(
	I0 => B(2),
	I1 => X36_NET00023_X95,
	O => X36_NET00060_X95
);
X36_I203 : AND2 port map(
	I0 => B(3),
	I1 => X36_NET00023_X95,
	O => X36_NET00061_X95
);
X36_I204 : AND2 port map(
	I0 => B(4),
	I1 => X36_NET00023_X95,
	O => X36_NET00062_X95
);
X36_I205 : AND2 port map(
	I0 => B(5),
	I1 => X36_NET00023_X95,
	O => X36_NET00063_X95
);
X36_I206 : AND2 port map(
	I0 => B(6),
	I1 => X36_NET00023_X95,
	O => X36_NET00064_X95
);
X36_I207 : AND2 port map(
	I0 => B(7),
	I1 => X36_NET00023_X95,
	O => X36_NET00065_X95
);
X36_I208 : AND2 port map(
	I0 => B(0),
	I1 => X36_NET00023_X95,
	O => X36_NET00058_X95
);
X36_I209 : INV port map(
	I => A_NOT_B,
	O => X36_NET00023_X95
);
X36_I210 : OR2 port map(
	I0 => X36_NET00065_X95,
	I1 => X36_NET00049_X95,
	O => O(7)
);
X36_I211 : OR2 port map(
	I0 => X36_NET00064_X95,
	I1 => X36_NET00048_X95,
	O => O(6)
);
X36_I212 : OR2 port map(
	I0 => X36_NET00063_X95,
	I1 => X36_NET00047_X95,
	O => O(5)
);
X36_I213 : OR2 port map(
	I0 => X36_NET00062_X95,
	I1 => X36_NET00046_X95,
	O => O(4)
);
X36_I214 : OR2 port map(
	I0 => X36_NET00061_X95,
	I1 => X36_NET00045_X95,
	O => O(3)
);
X36_I215 : OR2 port map(
	I0 => X36_NET00060_X95,
	I1 => X36_NET00044_X95,
	O => O(2)
);
X36_I216 : OR2 port map(
	I0 => X36_NET00059_X95,
	I1 => X36_NET00043_X95,
	O => O(1)
);
X36_I217 : OR2 port map(
	I0 => X36_NET00058_X95,
	I1 => X36_NET00042_X95,
	O => O(0)
);

end SCHEMATIC;
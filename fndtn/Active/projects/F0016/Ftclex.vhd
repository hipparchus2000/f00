-- ACTIVE-CAD-2-VHDL, 2.5.5.51, Mon Oct 18 23:53:05 1999

library IEEE;
use IEEE.std_logic_1164.all;
-- Simulation netlist only
-- synopsys translate_off
library UNISIM;
use UNISIM.vcomponents.all;
-- synopsys translate_on

entity FTCLEX is port (
	C : in STD_LOGIC;
	CE : in STD_LOGIC;
	CLR : in STD_LOGIC;
	D : in STD_LOGIC;
	L : in STD_LOGIC;
	Q : out STD_LOGIC;
	T : in STD_LOGIC
); end FTCLEX;

architecture SCHEMATIC of FTCLEX is

--COMPONENTS

component M2_1 port (
	D0 : in STD_LOGIC;
	D1 : in STD_LOGIC;
	O : out STD_LOGIC;
	S0 : in STD_LOGIC
); end component;

component XOR2 port (
	I0 : in STD_LOGIC;
	I1 : in STD_LOGIC;
	O : out STD_LOGIC
); end component;

component FDCE port (
	D : in STD_LOGIC;
	C : in STD_LOGIC;
	CE : in STD_LOGIC;
	CLR : in STD_LOGIC;
	Q : out STD_LOGIC
); end component;

--SIGNALS

signal MD : STD_LOGIC;
signal TQ : STD_LOGIC;
signal Q_ASSIGN_I1 : STD_LOGIC;


begin

--SIGNAL ASSIGNMENTS

Q <= Q_ASSIGN_I1;

--COMPONENT INSTANCES

X36_1I30 : M2_1 port map(
	D0 => TQ,
	D1 => D,
	O => MD,
	S0 => L
);
X36_1I32 : XOR2 port map(
	I0 => T,
	I1 => Q_ASSIGN_I1,
	O => TQ
);
X36_1I35 : FDCE port map(
	D => MD,
	C => C,
	CE => CE,
	CLR => CLR,
	Q => Q_ASSIGN_I1
);

end SCHEMATIC;
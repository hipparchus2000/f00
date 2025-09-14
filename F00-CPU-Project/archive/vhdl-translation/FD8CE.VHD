-- ACTIVE-CAD-2-VHDL, 2.5.5.51, Mon Oct 04 00:13:59 1999

library IEEE;
use IEEE.std_logic_1164.all;
-- Simulation netlist only
-- synopsys translate_off
library UNISIM;
use UNISIM.vcomponents.all;
-- synopsys translate_on

entity FD8CE is port (
	D : in STD_LOGIC_VECTOR (7 downto 0);
	Q : out STD_LOGIC_VECTOR (7 downto 0);
	C : in STD_LOGIC;
	CE : in STD_LOGIC;
	CLR : in STD_LOGIC
); end FD8CE;

architecture SCHEMATIC of FD8CE is

--COMPONENTS

component FDCE port (
	D : in STD_LOGIC;
	C : in STD_LOGIC;
	CE : in STD_LOGIC;
	CLR : in STD_LOGIC;
	Q : out STD_LOGIC
); end component;

--SIGNALS



begin

--SIGNAL ASSIGNMENTS


--COMPONENT INSTANCES

Q0_COMP : FDCE port map(
	D => D(0),
	C => C,
	CE => CE,
	CLR => CLR,
	Q => Q(0)
);
Q1_COMP : FDCE port map(
	D => D(1),
	C => C,
	CE => CE,
	CLR => CLR,
	Q => Q(1)
);
Q2_COMP : FDCE port map(
	D => D(2),
	C => C,
	CE => CE,
	CLR => CLR,
	Q => Q(2)
);
Q3_COMP : FDCE port map(
	D => D(3),
	C => C,
	CE => CE,
	CLR => CLR,
	Q => Q(3)
);
Q4_COMP : FDCE port map(
	D => D(4),
	C => C,
	CE => CE,
	CLR => CLR,
	Q => Q(4)
);
Q5_COMP : FDCE port map(
	D => D(5),
	C => C,
	CE => CE,
	CLR => CLR,
	Q => Q(5)
);
Q6_COMP : FDCE port map(
	D => D(6),
	C => C,
	CE => CE,
	CLR => CLR,
	Q => Q(6)
);
Q7_COMP : FDCE port map(
	D => D(7),
	C => C,
	CE => CE,
	CLR => CLR,
	Q => Q(7)
);

end SCHEMATIC;
-- ACTIVE-CAD-2-VHDL, 2.5.5.51, Mon Oct 18 23:52:29 1999

library IEEE;
use IEEE.std_logic_1164.all;
-- Simulation netlist only
-- synopsys translate_off
library UNISIM;
use UNISIM.vcomponents.all;
-- synopsys translate_on

entity FD16CE is port (
	D : in STD_LOGIC_VECTOR (15 downto 0);
	Q : out STD_LOGIC_VECTOR (15 downto 0);
	C : in STD_LOGIC;
	CE : in STD_LOGIC;
	CLR : in STD_LOGIC
); end FD16CE;

architecture SCHEMATIC of FD16CE is

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
Q10_COMP : FDCE port map(
	D => D(10),
	C => C,
	CE => CE,
	CLR => CLR,
	Q => Q(10)
);
Q11_COMP : FDCE port map(
	D => D(11),
	C => C,
	CE => CE,
	CLR => CLR,
	Q => Q(11)
);
Q12_COMP : FDCE port map(
	D => D(12),
	C => C,
	CE => CE,
	CLR => CLR,
	Q => Q(12)
);
Q13_COMP : FDCE port map(
	D => D(13),
	C => C,
	CE => CE,
	CLR => CLR,
	Q => Q(13)
);
Q14_COMP : FDCE port map(
	D => D(14),
	C => C,
	CE => CE,
	CLR => CLR,
	Q => Q(14)
);
Q15_COMP : FDCE port map(
	D => D(15),
	C => C,
	CE => CE,
	CLR => CLR,
	Q => Q(15)
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
Q8_COMP : FDCE port map(
	D => D(8),
	C => C,
	CE => CE,
	CLR => CLR,
	Q => Q(8)
);
Q9_COMP : FDCE port map(
	D => D(9),
	C => C,
	CE => CE,
	CLR => CLR,
	Q => Q(9)
);

end SCHEMATIC;
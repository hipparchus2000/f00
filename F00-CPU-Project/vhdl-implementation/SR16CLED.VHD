-- ACTIVE-CAD-2-VHDL, 2.5.5.51, Mon Oct 04 00:14:11 1999

library IEEE;
use IEEE.std_logic_1164.all;
-- Simulation netlist only
-- synopsys translate_off
library UNISIM;
use UNISIM.vcomponents.all;
-- synopsys translate_on

entity SR16CLED is port (
	D : in STD_LOGIC_VECTOR (15 downto 0);
	Q : out STD_LOGIC_VECTOR (15 downto 0);
	C : in STD_LOGIC;
	CE : in STD_LOGIC;
	CLR : in STD_LOGIC;
	L : in STD_LOGIC;
	LEFT : in STD_LOGIC;
	SLI : in STD_LOGIC;
	SRI : in STD_LOGIC
); end SR16CLED;

architecture SCHEMATIC of SR16CLED is

--COMPONENTS

component OR2 port (
	I0 : in STD_LOGIC;
	I1 : in STD_LOGIC;
	O : out STD_LOGIC
); end component;

component M2_1 port (
	D0 : in STD_LOGIC;
	D1 : in STD_LOGIC;
	O : out STD_LOGIC;
	S0 : in STD_LOGIC
); end component;

component FDCE port (
	D : in STD_LOGIC;
	C : in STD_LOGIC;
	CE : in STD_LOGIC;
	CLR : in STD_LOGIC;
	Q : out STD_LOGIC
); end component;

--SIGNALS

signal L_LEFT : STD_LOGIC;
signal L_OR_CE : STD_LOGIC;
signal MDL0 : STD_LOGIC;
signal MDL1 : STD_LOGIC;
signal MDL10 : STD_LOGIC;
signal MDL11 : STD_LOGIC;
signal MDL12 : STD_LOGIC;
signal MDL13 : STD_LOGIC;
signal MDL14 : STD_LOGIC;
signal MDL15 : STD_LOGIC;
signal MDL2 : STD_LOGIC;
signal MDL3 : STD_LOGIC;
signal MDL4 : STD_LOGIC;
signal MDL5 : STD_LOGIC;
signal MDL6 : STD_LOGIC;
signal MDL7 : STD_LOGIC;
signal MDL8 : STD_LOGIC;
signal MDL9 : STD_LOGIC;
signal MDR0 : STD_LOGIC;
signal MDR1 : STD_LOGIC;
signal MDR10 : STD_LOGIC;
signal MDR11 : STD_LOGIC;
signal MDR12 : STD_LOGIC;
signal MDR13 : STD_LOGIC;
signal MDR14 : STD_LOGIC;
signal MDR15 : STD_LOGIC;
signal MDR2 : STD_LOGIC;
signal MDR3 : STD_LOGIC;
signal MDR4 : STD_LOGIC;
signal MDR5 : STD_LOGIC;
signal MDR6 : STD_LOGIC;
signal MDR7 : STD_LOGIC;
signal MDR8 : STD_LOGIC;
signal MDR9 : STD_LOGIC;
signal Q15_ASSIGN_D0 : STD_LOGIC;
signal Q14_ASSIGN_D0 : STD_LOGIC;
signal Q13_ASSIGN_D0 : STD_LOGIC;
signal Q12_ASSIGN_D0 : STD_LOGIC;
signal Q11_ASSIGN_D0 : STD_LOGIC;
signal Q10_ASSIGN_D0 : STD_LOGIC;
signal Q9_ASSIGN_D0 : STD_LOGIC;
signal Q8_ASSIGN_D0 : STD_LOGIC;
signal Q7_ASSIGN_D0 : STD_LOGIC;
signal Q6_ASSIGN_D0 : STD_LOGIC;
signal Q5_ASSIGN_D0 : STD_LOGIC;
signal Q4_ASSIGN_D0 : STD_LOGIC;
signal Q3_ASSIGN_D0 : STD_LOGIC;
signal Q2_ASSIGN_D0 : STD_LOGIC;
signal Q1_ASSIGN_D0 : STD_LOGIC;
signal Q0_ASSIGN_D0 : STD_LOGIC;


begin

--SIGNAL ASSIGNMENTS

Q(15) <= Q15_ASSIGN_D0;
Q(14) <= Q14_ASSIGN_D0;
Q(13) <= Q13_ASSIGN_D0;
Q(12) <= Q12_ASSIGN_D0;
Q(11) <= Q11_ASSIGN_D0;
Q(10) <= Q10_ASSIGN_D0;
Q(9) <= Q9_ASSIGN_D0;
Q(8) <= Q8_ASSIGN_D0;
Q(7) <= Q7_ASSIGN_D0;
Q(6) <= Q6_ASSIGN_D0;
Q(5) <= Q5_ASSIGN_D0;
Q(4) <= Q4_ASSIGN_D0;
Q(3) <= Q3_ASSIGN_D0;
Q(2) <= Q2_ASSIGN_D0;
Q(1) <= Q1_ASSIGN_D0;
Q(0) <= Q0_ASSIGN_D0;

--COMPONENT INSTANCES

X36_1I145 : OR2 port map(
	I0 => L,
	I1 => CE,
	O => L_OR_CE
);
X36_1I161 : OR2 port map(
	I0 => LEFT,
	I1 => L,
	O => L_LEFT
);
MDL0_COMP : M2_1 port map(
	D0 => SLI,
	D1 => D(0),
	O => MDL0,
	S0 => L
);
MDL1_COMP : M2_1 port map(
	D0 => Q0_ASSIGN_D0,
	D1 => D(1),
	O => MDL1,
	S0 => L
);
MDL10_COMP : M2_1 port map(
	D0 => Q9_ASSIGN_D0,
	D1 => D(10),
	O => MDL10,
	S0 => L
);
MDL11_COMP : M2_1 port map(
	D0 => Q10_ASSIGN_D0,
	D1 => D(11),
	O => MDL11,
	S0 => L
);
MDL12_COMP : M2_1 port map(
	D0 => Q11_ASSIGN_D0,
	D1 => D(12),
	O => MDL12,
	S0 => L
);
MDL13_COMP : M2_1 port map(
	D0 => Q12_ASSIGN_D0,
	D1 => D(13),
	O => MDL13,
	S0 => L
);
MDL14_COMP : M2_1 port map(
	D0 => Q13_ASSIGN_D0,
	D1 => D(14),
	O => MDL14,
	S0 => L
);
MDL15_COMP : M2_1 port map(
	D0 => Q14_ASSIGN_D0,
	D1 => D(15),
	O => MDL15,
	S0 => L
);
MDL2_COMP : M2_1 port map(
	D0 => Q1_ASSIGN_D0,
	D1 => D(2),
	O => MDL2,
	S0 => L
);
MDL3_COMP : M2_1 port map(
	D0 => Q2_ASSIGN_D0,
	D1 => D(3),
	O => MDL3,
	S0 => L
);
MDL4_COMP : M2_1 port map(
	D0 => Q3_ASSIGN_D0,
	D1 => D(4),
	O => MDL4,
	S0 => L
);
MDL5_COMP : M2_1 port map(
	D0 => Q4_ASSIGN_D0,
	D1 => D(5),
	O => MDL5,
	S0 => L
);
MDL6_COMP : M2_1 port map(
	D0 => Q5_ASSIGN_D0,
	D1 => D(6),
	O => MDL6,
	S0 => L
);
MDL7_COMP : M2_1 port map(
	D0 => Q6_ASSIGN_D0,
	D1 => D(7),
	O => MDL7,
	S0 => L
);
MDL8_COMP : M2_1 port map(
	D0 => Q7_ASSIGN_D0,
	D1 => D(8),
	O => MDL8,
	S0 => L
);
MDL9_COMP : M2_1 port map(
	D0 => Q8_ASSIGN_D0,
	D1 => D(9),
	O => MDL9,
	S0 => L
);
MDR0_COMP : M2_1 port map(
	D0 => Q1_ASSIGN_D0,
	D1 => MDL0,
	O => MDR0,
	S0 => L_LEFT
);
MDR1_COMP : M2_1 port map(
	D0 => Q2_ASSIGN_D0,
	D1 => MDL1,
	O => MDR1,
	S0 => L_LEFT
);
MDR10_COMP : M2_1 port map(
	D0 => Q11_ASSIGN_D0,
	D1 => MDL10,
	O => MDR10,
	S0 => L_LEFT
);
MDR11_COMP : M2_1 port map(
	D0 => Q12_ASSIGN_D0,
	D1 => MDL11,
	O => MDR11,
	S0 => L_LEFT
);
MDR12_COMP : M2_1 port map(
	D0 => Q13_ASSIGN_D0,
	D1 => MDL12,
	O => MDR12,
	S0 => L_LEFT
);
MDR13_COMP : M2_1 port map(
	D0 => Q14_ASSIGN_D0,
	D1 => MDL13,
	O => MDR13,
	S0 => L_LEFT
);
MDR14_COMP : M2_1 port map(
	D0 => Q15_ASSIGN_D0,
	D1 => MDL14,
	O => MDR14,
	S0 => L_LEFT
);
MDR15_COMP : M2_1 port map(
	D0 => SRI,
	D1 => MDL15,
	O => MDR15,
	S0 => L_LEFT
);
MDR2_COMP : M2_1 port map(
	D0 => Q3_ASSIGN_D0,
	D1 => MDL2,
	O => MDR2,
	S0 => L_LEFT
);
MDR3_COMP : M2_1 port map(
	D0 => Q4_ASSIGN_D0,
	D1 => MDL3,
	O => MDR3,
	S0 => L_LEFT
);
MDR4_COMP : M2_1 port map(
	D0 => Q5_ASSIGN_D0,
	D1 => MDL4,
	O => MDR4,
	S0 => L_LEFT
);
MDR5_COMP : M2_1 port map(
	D0 => Q6_ASSIGN_D0,
	D1 => MDL5,
	O => MDR5,
	S0 => L_LEFT
);
MDR6_COMP : M2_1 port map(
	D0 => Q7_ASSIGN_D0,
	D1 => MDL6,
	O => MDR6,
	S0 => L_LEFT
);
MDR7_COMP : M2_1 port map(
	D0 => Q8_ASSIGN_D0,
	D1 => MDL7,
	O => MDR7,
	S0 => L_LEFT
);
MDR8_COMP : M2_1 port map(
	D0 => Q9_ASSIGN_D0,
	D1 => MDL8,
	O => MDR8,
	S0 => L_LEFT
);
MDR9_COMP : M2_1 port map(
	D0 => Q10_ASSIGN_D0,
	D1 => MDL9,
	O => MDR9,
	S0 => L_LEFT
);
Q0_COMP : FDCE port map(
	D => MDR0,
	C => C,
	CE => L_OR_CE,
	CLR => CLR,
	Q => Q0_ASSIGN_D0
);
Q1_COMP : FDCE port map(
	D => MDR1,
	C => C,
	CE => L_OR_CE,
	CLR => CLR,
	Q => Q1_ASSIGN_D0
);
Q10_COMP : FDCE port map(
	D => MDR10,
	C => C,
	CE => L_OR_CE,
	CLR => CLR,
	Q => Q10_ASSIGN_D0
);
Q11_COMP : FDCE port map(
	D => MDR11,
	C => C,
	CE => L_OR_CE,
	CLR => CLR,
	Q => Q11_ASSIGN_D0
);
Q12_COMP : FDCE port map(
	D => MDR12,
	C => C,
	CE => L_OR_CE,
	CLR => CLR,
	Q => Q12_ASSIGN_D0
);
Q13_COMP : FDCE port map(
	D => MDR13,
	C => C,
	CE => L_OR_CE,
	CLR => CLR,
	Q => Q13_ASSIGN_D0
);
Q14_COMP : FDCE port map(
	D => MDR14,
	C => C,
	CE => L_OR_CE,
	CLR => CLR,
	Q => Q14_ASSIGN_D0
);
Q15_COMP : FDCE port map(
	D => MDR15,
	C => C,
	CE => L_OR_CE,
	CLR => CLR,
	Q => Q15_ASSIGN_D0
);
Q2_COMP : FDCE port map(
	D => MDR2,
	C => C,
	CE => L_OR_CE,
	CLR => CLR,
	Q => Q2_ASSIGN_D0
);
Q3_COMP : FDCE port map(
	D => MDR3,
	C => C,
	CE => L_OR_CE,
	CLR => CLR,
	Q => Q3_ASSIGN_D0
);
Q4_COMP : FDCE port map(
	D => MDR4,
	C => C,
	CE => L_OR_CE,
	CLR => CLR,
	Q => Q4_ASSIGN_D0
);
Q5_COMP : FDCE port map(
	D => MDR5,
	C => C,
	CE => L_OR_CE,
	CLR => CLR,
	Q => Q5_ASSIGN_D0
);
Q6_COMP : FDCE port map(
	D => MDR6,
	C => C,
	CE => L_OR_CE,
	CLR => CLR,
	Q => Q6_ASSIGN_D0
);
Q7_COMP : FDCE port map(
	D => MDR7,
	C => C,
	CE => L_OR_CE,
	CLR => CLR,
	Q => Q7_ASSIGN_D0
);
Q8_COMP : FDCE port map(
	D => MDR8,
	C => C,
	CE => L_OR_CE,
	CLR => CLR,
	Q => Q8_ASSIGN_D0
);
Q9_COMP : FDCE port map(
	D => MDR9,
	C => C,
	CE => L_OR_CE,
	CLR => CLR,
	Q => Q9_ASSIGN_D0
);

end SCHEMATIC;
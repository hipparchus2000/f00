-- ACTIVE-CAD-2-VHDL, 2.5.5.51, Mon Oct 04 00:12:18 1999

library IEEE;
use IEEE.std_logic_1164.all;
-- Simulation netlist only
-- synopsys translate_off
library UNISIM;
use UNISIM.vcomponents.all;
-- synopsys translate_on

entity CB16CLE is port (
	D : in STD_LOGIC_VECTOR (15 downto 0);
	Q : out STD_LOGIC_VECTOR (15 downto 0);
	C : in STD_LOGIC;
	CE : in STD_LOGIC;
	CEO : out STD_LOGIC;
	CLR : in STD_LOGIC;
	L : in STD_LOGIC;
	TC : out STD_LOGIC
); end CB16CLE;

architecture SCHEMATIC of CB16CLE is

--COMPONENTS

component AND3 port (
	I0 : in STD_LOGIC;
	I1 : in STD_LOGIC;
	I2 : in STD_LOGIC;
	O : out STD_LOGIC
); end component;

component AND2 port (
	I0 : in STD_LOGIC;
	I1 : in STD_LOGIC;
	O : out STD_LOGIC
); end component;

component AND4 port (
	I0 : in STD_LOGIC;
	I1 : in STD_LOGIC;
	I2 : in STD_LOGIC;
	I3 : in STD_LOGIC;
	O : out STD_LOGIC
); end component;

component AND5 port (
	I0 : in STD_LOGIC;
	I1 : in STD_LOGIC;
	I2 : in STD_LOGIC;
	I3 : in STD_LOGIC;
	I4 : in STD_LOGIC;
	O : out STD_LOGIC
); end component;

component VCC port (
	P : out STD_LOGIC
); end component;

component OR2 port (
	I0 : in STD_LOGIC;
	I1 : in STD_LOGIC;
	O : out STD_LOGIC
); end component;

component FTCLEX port (
	C : in STD_LOGIC;
	CE : in STD_LOGIC;
	CLR : in STD_LOGIC;
	D : in STD_LOGIC;
	L : in STD_LOGIC;
	Q : out STD_LOGIC;
	T : in STD_LOGIC
); end component;

--SIGNALS

signal X36_NET00332_X95 : STD_LOGIC;
signal OR_CE_L : STD_LOGIC;
signal T10 : STD_LOGIC;
signal T11 : STD_LOGIC;
signal T12 : STD_LOGIC;
signal T13 : STD_LOGIC;
signal T14 : STD_LOGIC;
signal T15 : STD_LOGIC;
signal T2 : STD_LOGIC;
signal T3 : STD_LOGIC;
signal T4 : STD_LOGIC;
signal T5 : STD_LOGIC;
signal T6 : STD_LOGIC;
signal T7 : STD_LOGIC;
signal T8 : STD_LOGIC;
signal T9 : STD_LOGIC;
signal Q15_ASSIGN_I0 : STD_LOGIC;
signal TC_ASSIGN_I1 : STD_LOGIC;
signal Q14_ASSIGN_I1 : STD_LOGIC;
signal Q13_ASSIGN_I0 : STD_LOGIC;
signal Q12_ASSIGN_I0 : STD_LOGIC;
signal Q11_ASSIGN_I0 : STD_LOGIC;
signal Q10_ASSIGN_I0 : STD_LOGIC;
signal Q9_ASSIGN_I0 : STD_LOGIC;
signal Q8_ASSIGN_I0 : STD_LOGIC;
signal Q7_ASSIGN_I0 : STD_LOGIC;
signal Q6_ASSIGN_I0 : STD_LOGIC;
signal Q5_ASSIGN_I0 : STD_LOGIC;
signal Q4_ASSIGN_I0 : STD_LOGIC;
signal Q3_ASSIGN_I0 : STD_LOGIC;
signal Q2_ASSIGN_I0 : STD_LOGIC;
signal Q1_ASSIGN_I0 : STD_LOGIC;
signal Q0_ASSIGN_T : STD_LOGIC;


begin

--SIGNAL ASSIGNMENTS

Q(15) <= Q15_ASSIGN_I0;
TC <= TC_ASSIGN_I1;
Q(14) <= Q14_ASSIGN_I1;
Q(13) <= Q13_ASSIGN_I0;
Q(12) <= Q12_ASSIGN_I0;
Q(11) <= Q11_ASSIGN_I0;
Q(10) <= Q10_ASSIGN_I0;
Q(9) <= Q9_ASSIGN_I0;
Q(8) <= Q8_ASSIGN_I0;
Q(7) <= Q7_ASSIGN_I0;
Q(6) <= Q6_ASSIGN_I0;
Q(5) <= Q5_ASSIGN_I0;
Q(4) <= Q4_ASSIGN_I0;
Q(3) <= Q3_ASSIGN_I0;
Q(2) <= Q2_ASSIGN_I0;
Q(1) <= Q1_ASSIGN_I0;
Q(0) <= Q0_ASSIGN_T;

--COMPONENT INSTANCES

X36_1I13 : AND3 port map(
	I0 => Q5_ASSIGN_I0,
	I1 => Q4_ASSIGN_I0,
	I2 => T4,
	O => T6
);
X36_1I14 : AND2 port map(
	I0 => Q4_ASSIGN_I0,
	I1 => T4,
	O => T5
);
X36_1I15 : AND4 port map(
	I0 => Q6_ASSIGN_I0,
	I1 => Q5_ASSIGN_I0,
	I2 => Q4_ASSIGN_I0,
	I3 => T4,
	O => T7
);
X36_1I16 : AND5 port map(
	I0 => Q7_ASSIGN_I0,
	I1 => Q6_ASSIGN_I0,
	I2 => Q5_ASSIGN_I0,
	I3 => Q4_ASSIGN_I0,
	I4 => T4,
	O => T8
);
X36_1I17 : AND4 port map(
	I0 => Q3_ASSIGN_I0,
	I1 => Q2_ASSIGN_I0,
	I2 => Q1_ASSIGN_I0,
	I3 => Q0_ASSIGN_T,
	O => T4
);
X36_1I18 : AND3 port map(
	I0 => Q2_ASSIGN_I0,
	I1 => Q1_ASSIGN_I0,
	I2 => Q0_ASSIGN_T,
	O => T3
);
X36_1I19 : AND2 port map(
	I0 => Q1_ASSIGN_I0,
	I1 => Q0_ASSIGN_T,
	O => T2
);
X36_1I2 : AND5 port map(
	I0 => Q15_ASSIGN_I0,
	I1 => Q14_ASSIGN_I1,
	I2 => Q13_ASSIGN_I0,
	I3 => Q12_ASSIGN_I0,
	I4 => T12,
	O => TC_ASSIGN_I1
);
X36_1I31 : VCC port map(
	P => X36_NET00332_X95
);
X36_1I3 : AND4 port map(
	I0 => Q14_ASSIGN_I1,
	I1 => Q13_ASSIGN_I0,
	I2 => Q12_ASSIGN_I0,
	I3 => T12,
	O => T15
);
X36_1I4 : AND2 port map(
	I0 => Q12_ASSIGN_I0,
	I1 => T12,
	O => T13
);
X36_1I56 : AND2 port map(
	I0 => CE,
	I1 => TC_ASSIGN_I1,
	O => CEO
);
X36_1I5 : AND3 port map(
	I0 => Q13_ASSIGN_I0,
	I1 => Q12_ASSIGN_I0,
	I2 => T12,
	O => T14
);
X36_1I68 : OR2 port map(
	I0 => CE,
	I1 => L,
	O => OR_CE_L
);
X36_1I6 : AND3 port map(
	I0 => Q9_ASSIGN_I0,
	I1 => Q8_ASSIGN_I0,
	I2 => T8,
	O => T10
);
X36_1I7 : AND2 port map(
	I0 => Q8_ASSIGN_I0,
	I1 => T8,
	O => T9
);
X36_1I8 : AND4 port map(
	I0 => Q10_ASSIGN_I0,
	I1 => Q9_ASSIGN_I0,
	I2 => Q8_ASSIGN_I0,
	I3 => T8,
	O => T11
);
X36_1I9 : AND5 port map(
	I0 => Q11_ASSIGN_I0,
	I1 => Q10_ASSIGN_I0,
	I2 => Q9_ASSIGN_I0,
	I3 => Q8_ASSIGN_I0,
	I4 => T8,
	O => T12
);
Q0_COMP : FTCLEX port map(
	C => C,
	CE => OR_CE_L,
	CLR => CLR,
	D => D(0),
	L => L,
	Q => Q0_ASSIGN_T,
	T => X36_NET00332_X95
);
Q1_COMP : FTCLEX port map(
	C => C,
	CE => OR_CE_L,
	CLR => CLR,
	D => D(1),
	L => L,
	Q => Q1_ASSIGN_I0,
	T => Q0_ASSIGN_T
);
Q10_COMP : FTCLEX port map(
	C => C,
	CE => OR_CE_L,
	CLR => CLR,
	D => D(10),
	L => L,
	Q => Q10_ASSIGN_I0,
	T => T10
);
Q11_COMP : FTCLEX port map(
	C => C,
	CE => OR_CE_L,
	CLR => CLR,
	D => D(11),
	L => L,
	Q => Q11_ASSIGN_I0,
	T => T11
);
Q12_COMP : FTCLEX port map(
	C => C,
	CE => OR_CE_L,
	CLR => CLR,
	D => D(12),
	L => L,
	Q => Q12_ASSIGN_I0,
	T => T12
);
Q13_COMP : FTCLEX port map(
	C => C,
	CE => OR_CE_L,
	CLR => CLR,
	D => D(13),
	L => L,
	Q => Q13_ASSIGN_I0,
	T => T13
);
Q14_COMP : FTCLEX port map(
	C => C,
	CE => OR_CE_L,
	CLR => CLR,
	D => D(14),
	L => L,
	Q => Q14_ASSIGN_I1,
	T => T14
);
Q15_COMP : FTCLEX port map(
	C => C,
	CE => OR_CE_L,
	CLR => CLR,
	D => D(15),
	L => L,
	Q => Q15_ASSIGN_I0,
	T => T15
);
Q2_COMP : FTCLEX port map(
	C => C,
	CE => OR_CE_L,
	CLR => CLR,
	D => D(2),
	L => L,
	Q => Q2_ASSIGN_I0,
	T => T2
);
Q3_COMP : FTCLEX port map(
	C => C,
	CE => OR_CE_L,
	CLR => CLR,
	D => D(3),
	L => L,
	Q => Q3_ASSIGN_I0,
	T => T3
);
Q4_COMP : FTCLEX port map(
	C => C,
	CE => OR_CE_L,
	CLR => CLR,
	D => D(4),
	L => L,
	Q => Q4_ASSIGN_I0,
	T => T4
);
Q5_COMP : FTCLEX port map(
	C => C,
	CE => OR_CE_L,
	CLR => CLR,
	D => D(5),
	L => L,
	Q => Q5_ASSIGN_I0,
	T => T5
);
Q6_COMP : FTCLEX port map(
	C => C,
	CE => OR_CE_L,
	CLR => CLR,
	D => D(6),
	L => L,
	Q => Q6_ASSIGN_I0,
	T => T6
);
Q7_COMP : FTCLEX port map(
	C => C,
	CE => OR_CE_L,
	CLR => CLR,
	D => D(7),
	L => L,
	Q => Q7_ASSIGN_I0,
	T => T7
);
Q8_COMP : FTCLEX port map(
	C => C,
	CE => OR_CE_L,
	CLR => CLR,
	D => D(8),
	L => L,
	Q => Q8_ASSIGN_I0,
	T => T8
);
Q9_COMP : FTCLEX port map(
	C => C,
	CE => OR_CE_L,
	CLR => CLR,
	D => D(9),
	L => L,
	Q => Q9_ASSIGN_I0,
	T => T9
);

end SCHEMATIC;
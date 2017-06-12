-- ACTIVE-CAD-2-VHDL, 2.5.5.51, Mon Oct 18 23:52:32 1999

library IEEE;
use IEEE.std_logic_1164.all;
-- Simulation netlist only
-- synopsys translate_off
library UNISIM;
use UNISIM.vcomponents.all;
-- synopsys translate_on

entity F00165_5WAY16BITMUX is port (
	A : in STD_LOGIC_VECTOR (15 downto 0);
	B : in STD_LOGIC_VECTOR (15 downto 0);
	C : in STD_LOGIC_VECTOR (15 downto 0);
	D : in STD_LOGIC_VECTOR (15 downto 0);
	E : in STD_LOGIC_VECTOR (15 downto 0);
	O : out STD_LOGIC_VECTOR (15 downto 0);
	AENABLE_A : in STD_LOGIC;
	AENABLE_B : in STD_LOGIC;
	AENABLE_C : in STD_LOGIC;
	AENABLE_D : in STD_LOGIC;
	AENABLE_E : in STD_LOGIC
); end F00165_5WAY16BITMUX;

architecture SCHEMATIC of F00165_5WAY16BITMUX is

--COMPONENTS

component F00162_16BIT_ABUFF port (
	A : in STD_LOGIC_VECTOR (15 downto 0);
	O : out STD_LOGIC_VECTOR (15 downto 0);
	AENABLE : in STD_LOGIC
); end component;

component F00165_16BITX5ORTO16 port (
	A : in STD_LOGIC_VECTOR (15 downto 0);
	B : in STD_LOGIC_VECTOR (15 downto 0);
	C : in STD_LOGIC_VECTOR (15 downto 0);
	D : in STD_LOGIC_VECTOR (15 downto 0);
	E : in STD_LOGIC_VECTOR (15 downto 0);
	O : out STD_LOGIC_VECTOR (15 downto 0)
); end component;

--SIGNALS

signal NET00001 : STD_LOGIC;
signal NET00002 : STD_LOGIC;
signal NET00003 : STD_LOGIC;
signal NET00004 : STD_LOGIC;
signal NET00005 : STD_LOGIC;
signal NET00006 : STD_LOGIC;
signal NET00007 : STD_LOGIC;
signal NET00008 : STD_LOGIC;
signal NET00009 : STD_LOGIC;
signal NET00010 : STD_LOGIC;
signal NET00011 : STD_LOGIC;
signal NET00012 : STD_LOGIC;
signal NET00013 : STD_LOGIC;
signal NET00014 : STD_LOGIC;
signal NET00015 : STD_LOGIC;
signal NET00016 : STD_LOGIC;
signal NET00017 : STD_LOGIC;
signal NET00018 : STD_LOGIC;
signal NET00019 : STD_LOGIC;
signal NET00020 : STD_LOGIC;
signal NET00021 : STD_LOGIC;
signal NET00022 : STD_LOGIC;
signal NET00023 : STD_LOGIC;
signal NET00024 : STD_LOGIC;
signal NET00025 : STD_LOGIC;
signal NET00026 : STD_LOGIC;
signal NET00027 : STD_LOGIC;
signal NET00028 : STD_LOGIC;
signal NET00029 : STD_LOGIC;
signal NET00030 : STD_LOGIC;
signal NET00031 : STD_LOGIC;
signal NET00032 : STD_LOGIC;
signal NET00033 : STD_LOGIC;
signal NET00034 : STD_LOGIC;
signal NET00035 : STD_LOGIC;
signal NET00036 : STD_LOGIC;
signal NET00037 : STD_LOGIC;
signal NET00038 : STD_LOGIC;
signal NET00039 : STD_LOGIC;
signal NET00040 : STD_LOGIC;
signal NET00041 : STD_LOGIC;
signal NET00042 : STD_LOGIC;
signal NET00043 : STD_LOGIC;
signal NET00044 : STD_LOGIC;
signal NET00045 : STD_LOGIC;
signal NET00046 : STD_LOGIC;
signal NET00047 : STD_LOGIC;
signal NET00048 : STD_LOGIC;
signal NET00049 : STD_LOGIC;
signal NET00050 : STD_LOGIC;
signal NET00051 : STD_LOGIC;
signal NET00052 : STD_LOGIC;
signal NET00053 : STD_LOGIC;
signal NET00054 : STD_LOGIC;
signal NET00055 : STD_LOGIC;
signal NET00056 : STD_LOGIC;
signal NET00057 : STD_LOGIC;
signal NET00058 : STD_LOGIC;
signal NET00059 : STD_LOGIC;
signal NET00060 : STD_LOGIC;
signal NET00061 : STD_LOGIC;
signal NET00062 : STD_LOGIC;
signal NET00063 : STD_LOGIC;
signal NET00064 : STD_LOGIC;
signal NET00065 : STD_LOGIC;
signal NET00066 : STD_LOGIC;
signal NET00067 : STD_LOGIC;
signal NET00068 : STD_LOGIC;
signal NET00069 : STD_LOGIC;
signal NET00070 : STD_LOGIC;
signal NET00071 : STD_LOGIC;
signal NET00072 : STD_LOGIC;
signal NET00073 : STD_LOGIC;
signal NET00074 : STD_LOGIC;
signal NET00075 : STD_LOGIC;
signal NET00076 : STD_LOGIC;
signal NET00077 : STD_LOGIC;
signal NET00078 : STD_LOGIC;
signal NET00079 : STD_LOGIC;
signal NET00080 : STD_LOGIC;


begin

--SIGNAL ASSIGNMENTS


--COMPONENT INSTANCES

H7 : F00162_16BIT_ABUFF port map(
	A(15) => A(15),
	A(14) => A(14),
	A(13) => A(13),
	A(12) => A(12),
	A(11) => A(11),
	A(10) => A(10),
	A(9) => A(9),
	A(8) => A(8),
	A(7) => A(7),
	A(6) => A(6),
	A(5) => A(5),
	A(4) => A(4),
	A(3) => A(3),
	A(2) => A(2),
	A(1) => A(1),
	A(0) => A(0),
	O(15) => NET00001,
	O(14) => NET00002,
	O(13) => NET00003,
	O(12) => NET00004,
	O(11) => NET00005,
	O(10) => NET00006,
	O(9) => NET00007,
	O(8) => NET00008,
	O(7) => NET00009,
	O(6) => NET00010,
	O(5) => NET00011,
	O(4) => NET00012,
	O(3) => NET00013,
	O(2) => NET00014,
	O(1) => NET00015,
	O(0) => NET00016,
	AENABLE => AENABLE_A
);
H8 : F00162_16BIT_ABUFF port map(
	A(15) => B(15),
	A(14) => B(14),
	A(13) => B(13),
	A(12) => B(12),
	A(11) => B(11),
	A(10) => B(10),
	A(9) => B(9),
	A(8) => B(8),
	A(7) => B(7),
	A(6) => B(6),
	A(5) => B(5),
	A(4) => B(4),
	A(3) => B(3),
	A(2) => B(2),
	A(1) => B(1),
	A(0) => B(0),
	O(15) => NET00017,
	O(14) => NET00018,
	O(13) => NET00019,
	O(12) => NET00020,
	O(11) => NET00021,
	O(10) => NET00022,
	O(9) => NET00023,
	O(8) => NET00024,
	O(7) => NET00025,
	O(6) => NET00026,
	O(5) => NET00027,
	O(4) => NET00028,
	O(3) => NET00029,
	O(2) => NET00030,
	O(1) => NET00031,
	O(0) => NET00032,
	AENABLE => AENABLE_B
);
H9 : F00162_16BIT_ABUFF port map(
	A(15) => C(15),
	A(14) => C(14),
	A(13) => C(13),
	A(12) => C(12),
	A(11) => C(11),
	A(10) => C(10),
	A(9) => C(9),
	A(8) => C(8),
	A(7) => C(7),
	A(6) => C(6),
	A(5) => C(5),
	A(4) => C(4),
	A(3) => C(3),
	A(2) => C(2),
	A(1) => C(1),
	A(0) => C(0),
	O(15) => NET00033,
	O(14) => NET00034,
	O(13) => NET00035,
	O(12) => NET00036,
	O(11) => NET00037,
	O(10) => NET00038,
	O(9) => NET00039,
	O(8) => NET00040,
	O(7) => NET00041,
	O(6) => NET00042,
	O(5) => NET00043,
	O(4) => NET00044,
	O(3) => NET00045,
	O(2) => NET00046,
	O(1) => NET00047,
	O(0) => NET00048,
	AENABLE => AENABLE_C
);
H10 : F00162_16BIT_ABUFF port map(
	A(15) => D(15),
	A(14) => D(14),
	A(13) => D(13),
	A(12) => D(12),
	A(11) => D(11),
	A(10) => D(10),
	A(9) => D(9),
	A(8) => D(8),
	A(7) => D(7),
	A(6) => D(6),
	A(5) => D(5),
	A(4) => D(4),
	A(3) => D(3),
	A(2) => D(2),
	A(1) => D(1),
	A(0) => D(0),
	O(15) => NET00049,
	O(14) => NET00050,
	O(13) => NET00051,
	O(12) => NET00052,
	O(11) => NET00053,
	O(10) => NET00054,
	O(9) => NET00055,
	O(8) => NET00056,
	O(7) => NET00057,
	O(6) => NET00058,
	O(5) => NET00059,
	O(4) => NET00060,
	O(3) => NET00061,
	O(2) => NET00062,
	O(1) => NET00063,
	O(0) => NET00064,
	AENABLE => AENABLE_D
);
H11 : F00162_16BIT_ABUFF port map(
	A(15) => E(15),
	A(14) => E(14),
	A(13) => E(13),
	A(12) => E(12),
	A(11) => E(11),
	A(10) => E(10),
	A(9) => E(9),
	A(8) => E(8),
	A(7) => E(7),
	A(6) => E(6),
	A(5) => E(5),
	A(4) => E(4),
	A(3) => E(3),
	A(2) => E(2),
	A(1) => E(1),
	A(0) => E(0),
	O(15) => NET00065,
	O(14) => NET00066,
	O(13) => NET00067,
	O(12) => NET00068,
	O(11) => NET00069,
	O(10) => NET00070,
	O(9) => NET00071,
	O(8) => NET00072,
	O(7) => NET00073,
	O(6) => NET00074,
	O(5) => NET00075,
	O(4) => NET00076,
	O(3) => NET00077,
	O(2) => NET00078,
	O(1) => NET00079,
	O(0) => NET00080,
	AENABLE => AENABLE_E
);
H12 : F00165_16BITX5ORTO16 port map(
	A(15) => NET00065,
	A(14) => NET00066,
	A(13) => NET00067,
	A(12) => NET00068,
	A(11) => NET00069,
	A(10) => NET00070,
	A(9) => NET00071,
	A(8) => NET00072,
	A(7) => NET00073,
	A(6) => NET00074,
	A(5) => NET00075,
	A(4) => NET00076,
	A(3) => NET00077,
	A(2) => NET00078,
	A(1) => NET00079,
	A(0) => NET00080,
	B(15) => NET00049,
	B(14) => NET00050,
	B(13) => NET00051,
	B(12) => NET00052,
	B(11) => NET00053,
	B(10) => NET00054,
	B(9) => NET00055,
	B(8) => NET00056,
	B(7) => NET00057,
	B(6) => NET00058,
	B(5) => NET00059,
	B(4) => NET00060,
	B(3) => NET00061,
	B(2) => NET00062,
	B(1) => NET00063,
	B(0) => NET00064,
	C(15) => NET00033,
	C(14) => NET00034,
	C(13) => NET00035,
	C(12) => NET00036,
	C(11) => NET00037,
	C(10) => NET00038,
	C(9) => NET00039,
	C(8) => NET00040,
	C(7) => NET00041,
	C(6) => NET00042,
	C(5) => NET00043,
	C(4) => NET00044,
	C(3) => NET00045,
	C(2) => NET00046,
	C(1) => NET00047,
	C(0) => NET00048,
	D(15) => NET00017,
	D(14) => NET00018,
	D(13) => NET00019,
	D(12) => NET00020,
	D(11) => NET00021,
	D(10) => NET00022,
	D(9) => NET00023,
	D(8) => NET00024,
	D(7) => NET00025,
	D(6) => NET00026,
	D(5) => NET00027,
	D(4) => NET00028,
	D(3) => NET00029,
	D(2) => NET00030,
	D(1) => NET00031,
	D(0) => NET00032,
	E(15) => NET00001,
	E(14) => NET00002,
	E(13) => NET00003,
	E(12) => NET00004,
	E(11) => NET00005,
	E(10) => NET00006,
	E(9) => NET00007,
	E(8) => NET00008,
	E(7) => NET00009,
	E(6) => NET00010,
	E(5) => NET00011,
	E(4) => NET00012,
	E(3) => NET00013,
	E(2) => NET00014,
	E(1) => NET00015,
	E(0) => NET00016,
	O(15) => O(15),
	O(14) => O(14),
	O(13) => O(13),
	O(12) => O(12),
	O(11) => O(11),
	O(10) => O(10),
	O(9) => O(9),
	O(8) => O(8),
	O(7) => O(7),
	O(6) => O(6),
	O(5) => O(5),
	O(4) => O(4),
	O(3) => O(3),
	O(2) => O(2),
	O(1) => O(1),
	O(0) => O(0)
);

end SCHEMATIC;
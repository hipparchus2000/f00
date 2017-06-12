--
--  File: C:\fndtn\Active\projects\F0016\test.vhd
-- created: 10/09/99 01:19:43
--  from: 'C:\fndtn\Active\projects\F0016\test.ASF'
--  by fsm2hdl - version: 2.0.1.52
--
library IEEE;
use IEEE.std_logic_1164.all;

use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

library SYNOPSYS;
use SYNOPSYS.attributes.all;

entity test is 
  port (C: in STD_LOGIC;
        Clock: in STD_LOGIC;
        X: out STD_LOGIC;
        Y: out STD_LOGIC);
end;

architecture test_arch of test is


-- USER DEFINED ENCODED state machine: Sreg0
type Sreg0_type is (S1, S2, S3);
attribute enum_encoding : string;
attribute enum_encoding of Sreg0_type: type is
	"11110110100101010000 " &		-- S1
	"00011011000110100011 " &		-- S2
	"00000000000000000000";		-- S3

signal Sreg0: Sreg0_type;

begin
--concurrent signal assignments
--diagram ACTIONS;


Sreg0_machine: process (Clock)

begin

if Clock'event and Clock = '1' then
	case Sreg0 is
		when S1 =>
			if C=1 then
				Sreg0 <= S2;
			end if;
		when S2 =>
			Sreg0 <= S3;
			X=1;
		when S3 =>
			Sreg0 <= S1;
			X=0;
		when others =>
			null;
	end case;
end if;
end process;

end test_arch;

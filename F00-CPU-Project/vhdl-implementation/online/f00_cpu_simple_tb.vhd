-- F00 CPU Simple Testbench for EDA Playground
-- Copy this file to testbench.vhd in EDA Playground
-- Works with f00_cpu_simple.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity f00_cpu_simple_tb is
end entity f00_cpu_simple_tb;

architecture behavioral of f00_cpu_simple_tb is

    -- Component declaration
    component f00_cpu_simple
        port (
            clk         : in  std_logic;
            reset_n     : in  std_logic;
            debug_pc    : out std_logic_vector(15 downto 0);
            debug_state : out std_logic_vector(7 downto 0);
            debug_reg1  : out std_logic_vector(15 downto 0);
            debug_reg2  : out std_logic_vector(15 downto 0);
            debug_reg3  : out std_logic_vector(15 downto 0);
            debug_reg4  : out std_logic_vector(15 downto 0);
            debug_flags : out std_logic_vector(2 downto 0);
            debug_instr : out std_logic_vector(15 downto 0)
        );
    end component;

    -- Test signals
    signal clk         : std_logic := '0';
    signal reset_n     : std_logic := '0';
    signal debug_pc    : std_logic_vector(15 downto 0);
    signal debug_state : std_logic_vector(7 downto 0);
    signal debug_reg1  : std_logic_vector(15 downto 0);
    signal debug_reg2  : std_logic_vector(15 downto 0);
    signal debug_reg3  : std_logic_vector(15 downto 0);
    signal debug_reg4  : std_logic_vector(15 downto 0);
    signal debug_flags : std_logic_vector(2 downto 0);
    signal debug_instr : std_logic_vector(15 downto 0);

    -- Clock period
    constant CLK_PERIOD : time := 10 ns;

    -- Helper function to convert std_logic_vector to hex string
    function to_hstring(value : std_logic_vector) return string is
        variable hex_chars : string(1 to 16) := "0123456789ABCDEF";
        variable result : string(1 to value'length/4);
        variable temp : std_logic_vector(value'length-1 downto 0);
        variable nibble : integer;
    begin
        temp := value;
        for i in result'range loop
            nibble := to_integer(unsigned(temp(temp'high downto temp'high-3)));
            result(i) := hex_chars(nibble + 1);
            temp := temp(temp'high-4 downto 0) & "0000";
        end loop;
        return result;
    end function;

begin

    -- Clock generation
    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- CPU instantiation
    uut: f00_cpu_simple
        port map (
            clk         => clk,
            reset_n     => reset_n,
            debug_pc    => debug_pc,
            debug_state => debug_state,
            debug_reg1  => debug_reg1,
            debug_reg2  => debug_reg2,
            debug_reg3  => debug_reg3,
            debug_reg4  => debug_reg4,
            debug_flags => debug_flags,
            debug_instr => debug_instr
        );

    -- Test stimulus process
    stimulus: process
    begin
        -- Initial reset
        reset_n <= '0';
        wait for 100 ns;

        report "=== F00 CPU Comprehensive Test Started ===" severity note;
        report "Test Program Loaded:" severity note;
        report "  LOADIMM R9, 0x1234" severity note;
        report "  LOADIMM R10, 0x5678" severity note;
        report "  LOADIMM R11, 0xAAAA" severity note;
        report "  LOADIMM R12, 0x5555" severity note;
        report "  ADD R9,R10 -> R10 = 0x1234 + 0x5678 = 0x68AC" severity note;
        report "  SUB R9,R10 -> R10 = 0x1234 - 0x68AC" severity note;
        report "  AND R11,R12 -> R12 = 0xAAAA & 0x5555 = 0x0000" severity note;
        report "  OR R11,R12 -> R12 = 0xAAAA | 0x0000 = 0xAAAA" severity note;
        report "  XOR R11,R12 -> R12 = 0xAAAA ^ 0xAAAA = 0x0000" severity note;
        report "  NOT R11,R12 -> R12 = ~0xAAAA = 0x5555" severity note;
        report "  MOVE R10,R13 -> R13 = R10" severity note;

        -- Release reset
        reset_n <= '1';
        wait for 50 ns;

        -- Let CPU run through the comprehensive program
        wait for 2000 ns;

        report "=== Expected Final Results ===" severity note;
        report "  R9 should be 0x1234 (original value)" severity note;
        report "  R10 should be final arithmetic result" severity note;
        report "  R11 should be 0xAAAA (original value)" severity note;
        report "  R12 should be 0x5555 (after NOT operation)" severity note;

        -- Check final state (wait for additional clock cycles)
        wait for 500 ns;

        report "=== Final Register Values ===" severity note;
        report "R9 = 0x" & to_hstring(debug_reg1) severity note;
        report "R10 = 0x" & to_hstring(debug_reg2) severity note;
        report "R11 = 0x" & to_hstring(debug_reg3) severity note;
        report "R12 = 0x" & to_hstring(debug_reg4) severity note;

        if debug_reg1 = x"1234" then
            report "PASS: R9 = 0x1234 (correct)" severity note;
        else
            report "FAIL: R9 = 0x" & to_hstring(debug_reg1) & " (expected 0x1234)" severity error;
        end if;

        report "=== Test Complete ===" severity note;
        wait;
    end process;

    -- Monitor process - shows execution in real-time
    monitor: process(clk)
        variable prev_pc : std_logic_vector(15 downto 0) := x"FFFF";
        variable prev_state : std_logic_vector(7 downto 0) := x"FF";
    begin
        if rising_edge(clk) and reset_n = '1' then
            -- Report when PC or state changes
            if debug_pc /= prev_pc or debug_state /= prev_state then
                report "Cycle: PC=0x" & to_hstring(debug_pc) &
                       " State=0x" & to_hstring(debug_state) &
                       " Instr=0x" & to_hstring(debug_instr) &
                       " R9=0x" & to_hstring(debug_reg1) &
                       " R10=0x" & to_hstring(debug_reg2) &
                       " R11=0x" & to_hstring(debug_reg3) &
                       " R12=0x" & to_hstring(debug_reg4) &
                       " Flags=" & std_logic'image(debug_flags(2)) &
                                  std_logic'image(debug_flags(1)) &
                                  std_logic'image(debug_flags(0)) severity note;
                prev_pc := debug_pc;
                prev_state := debug_state;
            end if;
        end if;
    end process;

end architecture behavioral;
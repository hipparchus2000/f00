-- F00 CPU Online Testbench for EDA Playground
-- Simple testbench to verify basic CPU functionality
-- Copy both files to https://www.edaplayground.com

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity f00_cpu_online_tb is
end entity;

architecture behavioral of f00_cpu_online_tb is

    component f00_cpu_online
        port (
            clk         : in  std_logic;
            reset_n     : in  std_logic;
            debug_pc    : out std_logic_vector(15 downto 0);
            debug_state : out std_logic_vector(7 downto 0);
            debug_reg1  : out std_logic_vector(15 downto 0);
            debug_reg2  : out std_logic_vector(15 downto 0);
            debug_flags : out std_logic_vector(2 downto 0)
        );
    end component;

    signal clk         : std_logic := '0';
    signal reset_n     : std_logic := '0';
    signal debug_pc    : std_logic_vector(15 downto 0);
    signal debug_state : std_logic_vector(7 downto 0);
    signal debug_reg1  : std_logic_vector(15 downto 0);
    signal debug_reg2  : std_logic_vector(15 downto 0);
    signal debug_flags : std_logic_vector(2 downto 0);

    constant CLK_PERIOD : time := 10 ns;

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
    uut: f00_cpu_online
        port map (
            clk         => clk,
            reset_n     => reset_n,
            debug_pc    => debug_pc,
            debug_state => debug_state,
            debug_reg1  => debug_reg1,
            debug_reg2  => debug_reg2,
            debug_flags => debug_flags
        );

    -- Test stimulus
    stimulus: process
    begin
        -- Reset
        reset_n <= '0';
        wait for 50 ns;
        reset_n <= '1';
        wait for 20 ns;

        report "=== F00 CPU Online Test Started ===";
        report "Test Program:";
        report "  PC=0: LOADIMM R1, 0x1234";
        report "  PC=2: LOADIMM R2, 0x5678";
        report "  PC=4: ADD R1, R2";
        report "  PC=5: MOVE R2, R3";
        report "  PC=6: JUMPABS R20 (loop)";

        -- Run for several instructions
        wait for 500 ns;

        report "=== Expected Results ===";
        report "  R1 should contain 0x1234";
        report "  R2 should contain 0x68AC (0x1234 + 0x5678)";
        report "  R3 should contain 0x68AC (copy of R2)";
        report "  PC should loop between 0 and 6";

        wait for 1000 ns;

        report "=== Test Complete ===";
        wait;
    end process;

    -- Monitor process
    monitor: process(clk)
    begin
        if rising_edge(clk) then
            report "PC=" & to_hstring(debug_pc) &
                   " State=" & to_hstring(debug_state) &
                   " R1=" & to_hstring(debug_reg1) &
                   " R2=" & to_hstring(debug_reg2) &
                   " Flags=" & to_string(debug_flags);
        end if;
    end process;

end architecture;
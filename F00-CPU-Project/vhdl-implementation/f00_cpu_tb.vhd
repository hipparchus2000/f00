-- F00 CPU Testbench
-- Comprehensive test of F00 CPU with Xilinx IP cores
-- Tests basic instruction execution and functionality

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use STD.textio.all;
use IEEE.std_logic_textio.all;

entity f00_cpu_tb is
end entity f00_cpu_tb;

architecture behavioral of f00_cpu_tb is

    -- Component declaration for F00 CPU
    component f00_cpu_top
        port (
            CLK             : in  std_logic;
            RESET_N         : in  std_logic;
            IMEM_ADDR       : out std_logic_vector(15 downto 0);
            IMEM_DATA       : in  std_logic_vector(15 downto 0);
            IMEM_EN         : out std_logic;
            DMEM_ADDR       : out std_logic_vector(15 downto 0);
            DMEM_DATA_IN    : in  std_logic_vector(15 downto 0);
            DMEM_DATA_OUT   : out std_logic_vector(15 downto 0);
            DMEM_WE         : out std_logic;
            DMEM_EN         : out std_logic;
            IO_ADDR         : out std_logic_vector(15 downto 0);
            IO_DATA_IN      : in  std_logic_vector(15 downto 0);
            IO_DATA_OUT     : out std_logic_vector(15 downto 0);
            IO_WE           : out std_logic;
            IO_EN           : out std_logic;
            DEBUG_PC        : out std_logic_vector(15 downto 0);
            DEBUG_STATE     : out std_logic_vector(7 downto 0);
            DEBUG_FLAGS     : out std_logic_vector(3 downto 0)
        );
    end component;

    -- Test signals
    signal clk              : std_logic := '0';
    signal reset_n          : std_logic := '0';
    signal imem_addr        : std_logic_vector(15 downto 0);
    signal imem_data        : std_logic_vector(15 downto 0);
    signal imem_en          : std_logic;
    signal dmem_addr        : std_logic_vector(15 downto 0);
    signal dmem_data_in     : std_logic_vector(15 downto 0);
    signal dmem_data_out    : std_logic_vector(15 downto 0);
    signal dmem_we          : std_logic;
    signal dmem_en          : std_logic;
    signal io_addr          : std_logic_vector(15 downto 0);
    signal io_data_in       : std_logic_vector(15 downto 0);
    signal io_data_out      : std_logic_vector(15 downto 0);
    signal io_we            : std_logic;
    signal io_en            : std_logic;
    signal debug_pc         : std_logic_vector(15 downto 0);
    signal debug_state      : std_logic_vector(7 downto 0);
    signal debug_flags      : std_logic_vector(3 downto 0);

    -- Clock period
    constant CLK_PERIOD : time := 20 ns;  -- 50 MHz

    -- Test instruction memory (simple test program)
    type instruction_memory_t is array (0 to 255) of std_logic_vector(15 downto 0);
    signal instruction_memory : instruction_memory_t := (
        -- Test Program: Basic instruction test
        -- Address 0: LOADIMM R1, 0x1234
        0      => "0101000000010000",  -- LOADIMM R1, immediate follows
        1      => x"1234",             -- Immediate value 0x1234

        -- Address 2: LOADIMM R2, 0x5678
        2      => "0101000000100000",  -- LOADIMM R2, immediate follows
        3      => x"5678",             -- Immediate value 0x5678

        -- Address 4: ADD R1, R2 (R2 = R1 + R2)
        4      => "1000101100000100",  -- ADD R1, R2 (format=10, opcode=001011, R1=00001, R2=00010)

        -- Address 5: MOVE R2, R3 (R3 = R2)
        5      => "1000001000100011",  -- MOVE R2, R3 (format=10, opcode=000010, R2=00010, R3=00011)

        -- Address 6: STORE R3, R1 (Store R3 to address in R1)
        6      => "1000000100110001",  -- STORE R3, R1 (format=10, opcode=000001, R3=00011, R1=00001)

        -- Address 7: LOAD R1, R4 (Load from address in R1 to R4)
        7      => "1000000000010100",  -- LOAD R1, R4 (format=10, opcode=000000, R1=00001, R4=00100)

        -- Address 8: Infinite loop (JUMPABS R20 where R20=0)
        8      => "1000010110100000",  -- JUMPABS R20 (format=10, opcode=000101, R20=10100)

        others => x"0000"              -- NOP/undefined
    );

    -- Test data memory
    type data_memory_t is array (0 to 32767) of std_logic_vector(15 downto 0);
    signal data_memory : data_memory_t := (others => x"0000");

    -- UART output capture
    signal uart_output_char : character;
    signal uart_output_str  : string(1 to 256);
    signal uart_output_len  : integer := 0;

begin

    -- Clock generation
    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Instruction Memory simulation
    imem_process: process(imem_addr, imem_en)
    begin
        if imem_en = '1' then
            if unsigned(imem_addr) < instruction_memory'length then
                imem_data <= instruction_memory(to_integer(unsigned(imem_addr)));
            else
                imem_data <= x"0000";  -- Default to NOP
            end if;
        else
            imem_data <= x"0000";
        end if;
    end process;

    -- Data Memory simulation
    dmem_process: process(clk)
    begin
        if rising_edge(clk) then
            if dmem_en = '1' then
                if dmem_we = '1' then
                    -- Write to data memory
                    if unsigned(dmem_addr) < data_memory'length then
                        data_memory(to_integer(unsigned(dmem_addr))) <= dmem_data_out;
                    end if;
                else
                    -- Read from data memory
                    if unsigned(dmem_addr) < data_memory'length then
                        dmem_data_in <= data_memory(to_integer(unsigned(dmem_addr)));
                    else
                        dmem_data_in <= x"0000";
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- I/O (UART) simulation
    io_process: process(clk)
        variable char_val : integer;
    begin
        if rising_edge(clk) then
            if io_en = '1' and io_we = '1' then
                -- UART write (address 32767 = 0x7FFF)
                if unsigned(io_addr) = 32767 then
                    char_val := to_integer(unsigned(io_data_out(7 downto 0)));
                    if char_val >= 32 and char_val <= 126 then
                        uart_output_char <= character'val(char_val);
                        if uart_output_len < uart_output_str'length then
                            uart_output_len <= uart_output_len + 1;
                            uart_output_str(uart_output_len + 1) <= character'val(char_val);
                        end if;
                        report "UART Output: " & character'val(char_val) severity note;
                    end if;
                end if;
            end if;

            -- I/O read (return dummy data)
            io_data_in <= x"0000";
        end if;
    end process;

    -- CPU instantiation
    uut: f00_cpu_top
        port map (
            CLK             => clk,
            RESET_N         => reset_n,
            IMEM_ADDR       => imem_addr,
            IMEM_DATA       => imem_data,
            IMEM_EN         => imem_en,
            DMEM_ADDR       => dmem_addr,
            DMEM_DATA_IN    => dmem_data_in,
            DMEM_DATA_OUT   => dmem_data_out,
            DMEM_WE         => dmem_we,
            DMEM_EN         => dmem_en,
            IO_ADDR         => io_addr,
            IO_DATA_IN      => io_data_in,
            IO_DATA_OUT     => io_data_out,
            IO_WE           => io_we,
            IO_EN           => io_en,
            DEBUG_PC        => debug_pc,
            DEBUG_STATE     => debug_state,
            DEBUG_FLAGS     => debug_flags
        );

    -- Test stimulus
    stimulus: process
    begin
        -- Initial reset
        reset_n <= '0';
        wait for 100 ns;
        reset_n <= '1';
        wait for 50 ns;

        report "=== F00 CPU Test Started ===" severity note;
        report "Test program loaded:" severity note;
        report "  0: LOADIMM R1, 0x1234" severity note;
        report "  2: LOADIMM R2, 0x5678" severity note;
        report "  4: ADD R1, R2" severity note;
        report "  5: MOVE R2, R3" severity note;
        report "  6: STORE R3, R1" severity note;
        report "  7: LOAD R1, R4" severity note;
        report "  8: JUMPABS R20 (infinite loop)" severity note;

        -- Let CPU run for several cycles
        wait for 2000 ns;

        -- Check some expected results
        report "=== Test Results ===" severity note;
        report "Final PC: " & to_hstring(debug_pc) severity note;
        report "Final State: " & to_hstring(debug_state) severity note;
        report "Final Flags: " & to_string(debug_flags) severity note;

        -- Expected behavior:
        -- R1 should be loaded with 0x1234
        -- R2 should be loaded with 0x5678
        -- R2 = R1 + R2 = 0x1234 + 0x5678 = 0x68AC
        -- R3 = R2 = 0x68AC
        -- Memory[0x1234] should contain 0x68AC
        -- R4 should contain 0x68AC (loaded from memory[0x1234])

        report "Expected results:" severity note;
        report "  R1 = 0x1234" severity note;
        report "  R2 = 0x68AC (0x1234 + 0x5678)" severity note;
        report "  R3 = 0x68AC (copy of R2)" severity note;
        report "  R4 = 0x68AC (loaded from memory)" severity note;
        report "  Memory[0x1234] = 0x68AC" severity note;

        wait for 1000 ns;

        report "=== F00 CPU Test Complete ===" severity note;
        wait;
    end process;

    -- Monitor process for debug output
    monitor: process(clk)
    begin
        if rising_edge(clk) then
            -- Report state changes for debugging
            if debug_state /= x"00" and debug_state /= x"01" and debug_state /= x"02" and debug_state /= x"03" then
                report "CPU State: " & to_hstring(debug_state) &
                       ", PC: " & to_hstring(debug_pc) &
                       ", Flags: " & to_string(debug_flags) severity note;
            end if;
        end if;
    end process;

end architecture behavioral;
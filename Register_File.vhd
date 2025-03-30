LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY register_file IS
	PORT (
		reg_write, clk: IN std_logic;					-- Register write control signal and the clock
		read_reg1, read_reg2: IN std_logic_vector(4 DOWNTO 0);		-- 2 registers for read
		write_reg: IN std_logic_vector(4 DOWNTO 0);			-- 1 register for write
		write_data: IN std_logic_vector(31 DOWNTO 0);			-- data to be written to in reg_3
		read_data1, read_data2: OUT std_logic_vector(31 DOWNTO 0)	-- 2 data outputs for the 2 read registers
	);
END register_file;

ARCHITECTURE reg_file_behaviour OF register_file IS
	TYPE reg_array IS ARRAY (0 to 31) OF std_logic_vector(31 DOWNTO 0);	-- making the 32 registers each having 32 bits
	SIGNAL registers: reg_array:= (others => (others => '0'));		-- initilaizing the 32 registers to 32 bits 0f zeros

BEGIN
	write_process: PROCESS(clk)
	BEGIN
		IF rising_edge(clk) and reg_write = '1' THEN
			IF write_reg /= "00000" THEN 				-- We are excepting the write in reg 0 as it should always have zero value
				registers(to_integer(unsigned(write_reg))) <= write_data;
			END IF;
		END IF;
	END PROCESS;

	read_process: PROCESS(clk)
	BEGIN
		IF falling_edge(clk) THEN
			read_data1 <= registers(to_integer(unsigned(read_reg1)));
			read_data2 <= registers(to_integer(unsigned(read_reg2)));
		END IF;
	END PROCESS;

END reg_file_behaviour;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY register_file_testbench IS
END register_file_testbench;

ARCHITECTURE reg_file_tb OF register_file_testbench IS
	COMPONENT register_file IS
		PORT (
			reg_write, clk: IN std_logic;
			read_reg1, read_reg2: IN std_logic_vector(4 DOWNTO 0);
			write_reg: IN std_logic_vector(4 DOWNTO 0);
			write_data: IN std_logic_vector(31 DOWNTO 0);
			read_data1, read_data2: OUT std_logic_vector(31 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL clk: std_logic:= '0';
	SIGNAL reg_write: std_logic:= '0';
	SIGNAL read_reg1, read_reg2: std_logic_vector(4 DOWNTO 0):= (OTHERS => '0');
	SIGNAL write_reg: std_logic_vector(4 DOWNTO 0):= (OTHERS => '0');
	SIGNAL write_data: std_logic_vector(31 DOWNTO 0):= (OTHERS => '0');
	SIGNAL read_data1, read_data2: std_logic_vector(31 DOWNTO 0);

	CONSTANT clk_period : TIME := 10 ns;

BEGIN
	reg_file_test: register_file PORT MAP (reg_write, clk, read_reg1, read_reg2, write_reg, write_data, read_data1, read_data2);

	clk_process: PROCESS
    	BEGIN
		WHILE TRUE LOOP
        		clk <= '1';
        		WAIT FOR clk_period/2;
        		clk <= '0';
        		WAIT FOR clk_period/2;
		END LOOP;
	END PROCESS;

	test_proc: PROCESS
   	BEGIN
        	-- Test 1: Write to register 5 and read back
        	reg_write <= '1';
        	write_reg <= "00101";
        	write_data <= X"00000015";
        	WAIT FOR clk_period;
		reg_write <= '0';
		read_reg1 <= "00101";
		WAIT FOR clk_period;

		--Test 2: Write to register 0 and read back
		reg_write <= '1';
        	write_reg <= "00000";
        	write_data <= X"00012345";
        	WAIT FOR clk_period;
		reg_write <= '0';
		read_reg1 <= "00000";
		WAIT FOR clk_period;

		--Test 3: Read from register 5 while writing to register 10
		reg_write <= '1';
		write_reg <= "01010";
		write_data <= X"0000003F";
		read_reg1 <= "00101";
		WAIT FOR clk_period;
		reg_write <= '0';
		WAIT FOR clk_period;

		--Test 4: Write and read from register 7 in the same cycle
		reg_write <= '1';
		write_reg <= "00111";
		write_data <= X"00003333";
		read_reg1 <= "00111";
		WAIT FOR clk_period;
		reg_write <= '0';
		WAIT FOR clk_period;

		--Test 5: Read from both register 5 and register 10
		read_reg1 <= "00101";
		read_reg2 <= "01010";
		WAIT FOR clk_period;

		WAIT;
    	END PROCESS;

END reg_file_tb;
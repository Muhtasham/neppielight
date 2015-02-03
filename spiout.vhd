----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:43:14 02/02/2015 
-- Design Name: 
-- Module Name:    spiout - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity spiout is
    Port ( clk50 : in  STD_LOGIC;
           data : in std_logic_vector(0 to 24*10-1); -- MSB first
           MOSI : out  STD_LOGIC;
           SCK : out  STD_LOGIC);
end spiout;

architecture Behavioral of spiout is
signal sck_counter    : std_logic_vector(9 downto 0);
signal sck_s : std_logic;
signal sck_enable : std_logic := '1';
--signal data_reg    : std_logic_vector(7 downto 0) := "11110010";
signal wrcnt: std_logic_vector(9 downto 0) := (others => '0');

begin
process(clk50,sck_counter,sck_enable)
	begin
		if (rising_edge(clk50)) then
			sck_counter <= sck_counter + 1;
		end if;
 	   sck_s <= sck_counter(8);
	end process;
		
process(sck_s, sck_enable)
	begin
		-- Assert MOSI on the falling edge
		-- So it can be sampled by the WS2801 on the rising edge.
		if (falling_edge(sck_s)) then
			if wrcnt <= 239 then
				MOSI <= data(to_integer(unsigned(wrcnt)));			
				wrcnt <= (wrcnt + 1);			
				sck_enable <= '1'; -- this will let the clock go high on the next rising edge.
			elsif wrcnt = 240 then                
				MOSI <= '0';
				sck_enable <= '0';
				wrcnt <= (wrcnt + 1);
			elsif wrcnt = 300 then
				sck_enable <= '0';
				MOSI <= '0';
				wrcnt <= (others =>'0');
			else
				sck_enable <= '0';
				MOSI <= '0';
				wrcnt <= (wrcnt + 1);
			end if;				
		end if;
		
		--SCK <= sck_s;
		
		if sck_enable = '1' then
			SCK <= sck_s;
		else
			SCK <= '0';
		end if;	
		
	end process;
		
end Behavioral;


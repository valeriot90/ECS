-------------------------------------------------------------------------------
-- (Structural)
--
-- File name : tbcounter.vhd
-- Purpose   : Generatore di impulsi programmabile
--           :
-- Library   : IEEE
-- Author(s) : Valerio Tanferna
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity tbcounter is

end tbcounter;

architecture counter_test of tbcounter is

	component counter
	generic (N : INTEGER:=8);
 	port(   start 		: in  std_logic;			-- Segnale attivo alto, genera numero, ricevuto dal gen_pulse
	 	clock 		: in  std_logic;				
		reset 		: in std_logic;				-- Al reset interrompe l'incremento e genera un valore pari a 0
  	        sum            : out std_logic_vector (N-1 downto 0));	-- Segnale di output inviato al gen_pulse
	end component;

-------------------------------------------------------------------------------

   constant N       :  integer  := 8;       -- Bus Width
   constant MckPer  :  time     := 200 ns;  -- Master Clk period
   constant TestLen :  integer  := 500;      -- No. of Count (MckPer/2) for test	

---------------initial value----------------------
-- I N P U T     S I G N A L S

   signal   start  : std_logic := '0';		  			--clk initial value
   signal clock : std_logic :='0'; 
   signal reset : std_logic := '1';

-- O U T P U T     S I G N A L S

   signal   sum    : std_logic_vector (N-1 downto 0);

   signal clk_cycle : integer;						--number of clk's periods
   signal Testing: boolean := True;

	begin 
	i_counter: counter generic map(N=>8)
	port map(start, clock, reset, sum);

-------------------------------------------------------------------------------

   -- Generates clk

      clock     <= not clock after MckPer/2 when Testing else '0';

   -- Runs simulation for TestLen cycles;

   Test_Proc: process(clock)
      variable count: INTEGER:= 0;
   begin
     clk_cycle <= (count+1)/2;		

     case count is
	 when 2 => start<='1';	-- Avvio il counter per vedere come evolte l'uscita per vari cicli di clock
    	 when 8 => start<='0';
	 when 10 => start<='1';
    	 when 16 => start<='0';
 	 when 20 => start<='1';
    	 when 28 => start<='0';
    	 when 30 => start<='1';
    	 when 34 => start<='0';	
	 when (TestLen - 1) =>   Testing <= False;
         when others => null;
     end case;
     count:= count + 1;
   end process Test_Proc;
end counter_test;






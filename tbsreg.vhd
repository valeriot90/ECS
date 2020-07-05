-------------------------------------------------------------------------------
-- TestBench (sreg)
--
-- File name : tbsreg.vhd
-- Purpose   : Test per il registro
--           :
-- Library   : IEEE
-- Author(s) : Valerio Tanferna
-------------------------------------------------------------------------------
--
-- Ogni volta che il segnale Load diventa attivo basso memorizza
-- un nuovo adto in ingresso e lo inoltra allo slave	
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity tbsreg is

end tbsreg;

architecture sreg_test of tbsreg is

   component sreg

   generic (N : integer:=8);

   port(
	input : in std_logic_vector(N-1 downto 0);	-- bus dati in ingresso
	save : in std_logic;				-- attivo alto (per un ciclo di clock), memorizza il dato in ingresso
	clock : in std_logic;
	output : out std_logic_vector(N-1 downto 0));	-- bus dati di uscita
			
   end component;

-------------------------------------------------------------------------------

   constant N       :  integer  := 8;       -- Bus Width
   constant MckPer  :  time     := 200 ns;  -- Master Clk period
   constant TestLen :  integer  := 500;      -- No. of Count (MckPer/2) for test	

---------------initial value----------------------
-- I N P U T     S I G N A L S

   signal   save    : std_logic :='0';		-- inizializzato a 0, non memorizzo
   signal   input    : std_logic_VECTOR (N-1 downto 0):="00000001";	

-- O U T P U T     S I G N A L S

   signal   output    : std_logic_vector (N-1 downto 0);

   signal clock : std_logic :='0';
   signal clk_cycle : integer;						--number of clk's periods
   signal Testing: boolean := True;

begin

   i_sreg : sreg generic map(N=>8)
             port map(input, save, clock, output);

-------------------------------------------------------------------------------

   -- Generates clk

      clock     <= not clock after MckPer/2 when Testing else '0';

   -- Runs simulation for TestLen cycles;

   Test_Proc: process(clock)
      variable count: integer:= 0;
   begin
     clk_cycle <= (count+1)/2;		

     case count is
	when 2 => save<='1';		-- memorizza il dato
	when 4 => save <='0';
	when 5 => input<="00000000";	-- nuovo dato
	when 6 => save<='1';		-- memorizza il dato
	when 8 => save<='0';
	when 9 => input<="00010000";	-- nuovo dato
	when 10 => save<='1';		-- memorizza il dato 
	when 12 => save<='0';
	when 14 => input<="00011000";	-- nuovo dato
	when 16 => save<='1';		-- memorizza il dato
	when 18 => save<='0'; 
	when 19 => input<="00000011";	-- nuovo dato
	when 22 => save<='1';		-- memorizza il dato
	when 24 => save<='0';
	when 25 => input<="00000000";	-- nuovo dato
	when 26 => save<='1';		-- memorizza il dato
	when 28 => save<='0';

        when (TestLen - 1) =>   Testing <= False;
        when others => null;
     end case;
     count:= count + 1;
   end process Test_Proc;

END sreg_test;
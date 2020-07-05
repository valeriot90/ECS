-------------------------------------------------------------------------------
-- TestBench (creg)
--
-- File name : tbcreg.vhd
-- Purpose   : Test per il registro contatore
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

entity tbcreg is

end tbcreg;

architecture creg_test of tbcreg is

   component creg

   generic (N : integer:=8);
	port(
			input : in std_logic_vector(N-1 downto 0);	-- Segnale di ingresso incrementato, ricevuto dall'adder
			start : in std_logic;				-- Segnale start attivo alto
			clock : in std_logic;				-- Segnale di clock
			reset : in std_logic;				-- Segnale di reset, attivo basso, l'output generato sara' 0
			output : out std_logic_vector(N-1 downto 0);	-- Segnale di output mandato al generatore di impulsi, collegato all'uscita del counter
			somma : out std_logic_vector(N-1 downto 0) );	-- Segnale di output inviato all'adder per incrementarlo, collegato all'adder
   end component;

-------------------------------------------------------------------------------

   constant N       :  integer  := 8;       -- Bus Width
   constant MckPer  :  time     := 200 ns;  -- Master Clk period
   constant TestLen :  integer  := 500;      -- No. of Count (MckPer/2) for test	

---------------initial value----------------------
-- I N P U T     S I G N A L S

   signal   start    : std_logic :='0';
   signal   input    : std_logic_VECTOR (N-1 downto 0):="00000001";	

-- O U T P U T     S I G N A L S

   signal   output    : std_logic_vector (N-1 downto 0);
   signal   somma    : std_logic_vector (N-1 downto 0);

   signal   reset    : std_logic :='1';
   signal clock : std_logic :='0';
   signal clk_cycle : integer;						--number of clk's periods
   signal Testing: boolean := True;

begin

   i_creg : creg generic map(N=>8)
             port map(input, start, clock, reset, output, somma);

-------------------------------------------------------------------------------

   -- Generates clk

      clock     <= not clock after MckPer/2 when Testing else '0';

   -- Runs simulation for TestLen cycles;

   Test_Proc: process(clock)
      variable count: integer:= 0;
   begin
     clk_cycle <= (count+1)/2;		

     case count is
	when 2 => start<='1'; 		-- In uscita il valore di ingresso
	when 4 => start <='0';
	when 5 => input<="00000000"; 	-- Nuovo valore
	when 6 => start<='1';		-- In uscita il valore di ingresso
	when 8 => start<='0';
	when 9 => input<="00010000";	-- Nuovo valore
	when 10 => start<='1';		-- In uscita il valore di ingresso
	when 12 => start<='0';
	when 15 => input<="00011000";	-- Nuovo valore
	when 16 => start<='1';		-- In uscita il valore di ingresso
	when 18 => start<='0'; 
	when 19 => input<="00000011";	-- Nuovo valore
	when 22 => start<='1';		-- In uscita il valore di ingresso
	when 24 => start<='0';
	when 25 => input<="00000000";	-- Nuovo valore
	when 26 => start<='1';		-- In uscita il valore di ingresso
	when 28 => start<='0';

        when (TestLen - 1) =>   Testing <= False;
        when others => null;
     end case;
     count:= count + 1;
   end process Test_Proc;

end creg_test;
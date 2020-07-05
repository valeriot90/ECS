-------------------------------------------------------------------------------
-- TestBench (reg)
--
-- File name : tbreg.vhd
-- Purpose   : Test per il registro
--           :
-- Library   : IEEE
-- Author(s) : Valerio Tanferna
-------------------------------------------------------------------------------
--
-- Ogni volta che il segnale Load diventa attivo basso memorizza
-- un nuovo dato in ingresso e lo inoltra allo slave	
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity tbreg is

end tbreg;

architecture reg_test of tbreg is

   component reg

   generic (N : integer:=8);

   port( input      : in  std_logic_VECTOR (N-1 downto 0);		-- Bus dati in ingresso
	 Load       : in  std_logic;					-- Segnale di ingresso attivo basso: memorizza l'input
         reset      : in  std_logic; 					-- Segnale di reset, attivo basso 		 
	 output    : out  std_logic_vector (N-1 downto 0));		-- Bus dati per l'uscita


   end component;

-------------------------------------------------------------------------------

   constant N       :  integer  := 8;       -- Bus Width
   constant MckPer  :  time     := 200 ns;  -- Master Clk period
   constant TestLen :  integer  :=500;      -- No. of Count (MckPer/2) for test	

---------------initial value----------------------
-- I N P U T     S I G N A L S

   signal   Load  : std_logic := '1';		  			-- Inizializzo ad 1, non memorizza il dato
   signal   input    : std_logic_VECTOR (N-1 downto 0):="00000001";	-- Segnale dato in ingresso inizializzato ad 1
   signal   reset  : std_logic := '1';					-- reset attivo basso

-- O U T P U T     S I G N A L S

   signal   output    : std_logic_vector (N-1 downto 0);

   signal clock : std_logic :='0';
   signal clk_cycle : integer;						--number of clk's periods
   signal Testing: boolean := True;

begin

   i_reg : reg generic map(N=>8)
             port map(input, Load, reset, output);

-------------------------------------------------------------------------------

   -- Generates clk

      clock     <= not clock after MckPer/2 when Testing else '0';

   -- Runs simulation for TestLen cycles;

   Test_Proc: process(clock)
      variable count: integer:= 0;
   begin
     clk_cycle <= (count+1)/2;		

     case count is
	when 2 => reset<='0';  		-- resetto il circuito
	when 4 => reset <='1';
        when 5 => input <="11111111";	-- nuovo dato
	when 6 => Load <= '0';		-- memorizzo nel registro
	when 8 => Load <= '1';
	when 11 => input <="11000111";	-- nuovo dato
	when 12 => Load <= '0';		-- memorizzo nel registro
	when 14 => Load <= '1';
	when 20 => reset<='0'; 		-- resetto il circuito
	when 22 => reset<='1'; 
	when 26 => input <="11001111";	-- nuovo dato
	when 28 => Load <= '0';		-- memorizzo nel registro
	when 30 => Load <= '1';
        when (TestLen - 1) =>   Testing <= False;
        when others => null;
     end case;
     count:= count + 1;
   end process Test_Proc;

END reg_test;

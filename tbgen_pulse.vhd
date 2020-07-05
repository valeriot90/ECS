-------------------------------------------------------------------------------
-- TestBench (gen_pulse)
--
-- File name : tbgen_pulse.vhd
-- Purpose   : Test per il generatore di impulso
--           :
-- Library   : IEEE
-- Author(s) : Valerio Tanferna
-------------------------------------------------------------------------------
--
-- Genera l'impulso
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity tbgen_pulse is

end tbgen_pulse;

architecture gen_pulse_test of tbgen_pulse is

   component gen_pulse

   generic (N : integer:=8);
   port( L 		 : in  std_logic_vector(N-1 downto 0); -- Dato dal contatore Length
	 D		 : in  std_logic_vector(N-1 downto 0); -- Dato dal contatore Delay
	 WDelay		 : in  std_logic_vector(N-1 downto 0); -- Dato dal registro regD
	 WLength	 : in  std_logic_vector(N-1 downto 0); -- Dato dal registro regL
	 reset		 : in std_logic;
	 clock		 : in std_logic;
	 Dstart		 : out std_logic;			-- Attivo alto, per avviare il counter per il Delay
	 Lstart		 : out std_logic;			-- Attivo alto, per avviare il counter per il Length
	 Dsave		 : out std_logic;			-- Attivo alto, segnala al registro sreg di salvare il nuovo dato Delay
	 Lsave		 : out std_logic;			-- Attivo alto, segnala al registro sreg di salvare il nuovo dato Length
         wave            : out std_logic);			-- Segnale di uscita
   end component;

-------------------------------------------------------------------------------
   constant N       :  integer  := 8;         -- Bus Width
   constant MckPer  :  time     := 200 ns;    -- Master Clk period
   constant TestLen :  integer  := 500;      -- No. of Count (MckPer/2) for test	


---------------initial value---------------------------------------------------
-- I N P U T     S I G N A L S

   signal   D  		  : std_logic_vector(N-1 downto 0) := "00000000";	
   signal   L  		  : std_logic_vector(N-1 downto 0) := "00000000";	
   signal   WDelay  	  : std_logic_vector(N-1 downto 0) := "00000010";	
   signal   WLength	  : std_logic_vector(N-1 downto 0) := "00000011";	
   signal   clock 	  : std_logic :='0';
   signal   reset 	  : std_logic :='1'; -- reset attivo basso

-- O U T P U T     S I G N A L S

   signal Dstart	: std_logic;
   signal Lstart	: std_logic;
   signal Dsave		: std_logic;
   signal Lsave		: std_logic;
   signal wave  	: std_logic;

   signal clk_cycle 	: integer;			   --number of clk's periods
   signal Testing	: boolean := True;

begin

   i_gen_pulse : gen_pulse generic map(N=>8)
             port map(L, D, WDelay, WLength, reset, clock, Dstart, Lstart, Dsave, Lsave, wave);

-------------------------------------------------------------------------------

   -- Generates clk

      clock     <= not clock after MckPer/2 when Testing else '0';

   -- Runs simulation for TestLen cycles;

   Test_Proc: process(clock)
      variable count: integer:= 0;
   begin
     clk_cycle <= (count+1)/2;		

	-- Simulo contatori, WDelay = 2, WLength = 3
     case count is
	when 2 =>	  reset <= '0';		-- Resetta il circuito
	when 4   => 	  reset <= '1';
	when 5   => 	  D <= "00000000"; L <= "00000000";	-- Simulo ricezione dati dai contatori
        when 7  => 	  D <= "00000001"; L <= "00000000";
	when 9  => 	  D <= "00000010"; L <= "00000000";

	when 13   => 	  D <= "00000000"; L <= "00000001";	-- Cambio di stato
	when 15   => 	  D <= "00000000"; L <= "00000010";
	when 17   => 	  D <= "00000000"; L <= "00000011";
	when 19  => 	  D <= "00000001"; L <= "00000000";
	when 21  => 	  D <= "00000010"; L <= "00000000";
	
	when 25   => 	  D <= "00000000"; L <= "00000001";	-- Cambio stato
	when 27   => 	  D <= "00000000"; L <= "00000010";
	when 29   => 	  D <= "00000000"; L <= "00000011";

	when 31   => 	  D <= "00000001"; L <= "00000000";

        when (TestLen - 1) =>   Testing <= False;
        when others => null;
     end case;
     count:= count + 1;
   end process Test_Proc;

END gen_pulse_test;
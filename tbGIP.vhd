-------------------------------------------------------------------------------
-- TestBench (GIP)
--
-- File name : tbGIP.vhd
-- Purpose   : Test bench per il GIP
--           :
-- Library   : IEEE
-- Author(s) : Valerio Tanferna
-------------------------------------------------------------------------------
--
-- Il circuito principale, memorizza un nuovo dato su due registri differenti ogni
-- qual volta e' attivo basso uno dei due segnali di Load
-- Genera in uscita un segnale con duty cycle proporzionale ai valori memorizzati nei registri
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity tbGIP is

end tbGIP;

architecture GIP_test of tbGIP is

	component GIP

	generic (N : integer:=8);
	port(
		LoadDelay : in std_logic;	-- Segnale attivo basso, memorizza Delay dell'impulso
		LoadLength : in std_logic;	-- Segnale attivo basso, memorizza Length dell'impulso
		clock : in std_logic;		-- Clock 
		reset : in std_logic;		-- Segnale attivo basso, resetta il circuito
		Data : in std_logic_vector(N-1 downto 0);	-- Segnale per i dati

		pulse : out std_logic);		-- Segnale di uscita, l'impulso
	end component;

-------------------------------------------------------------------------------

    constant N       :  integer  := 8;       -- Bus Width
    constant MckPer  :  time     := 200 ns;  -- Master Clk period
    constant TestLen :  integer  := 500;     -- No. of Count (MckPer/2) for test	

---------------initial value---------------------------------------------------
-- I N P U T     S I G N A L S

	signal LoadDelay : std_logic := '1';		-- Inizializzo ad 1, non memorizza il dato
	signal LoadLength : std_logic := '1';		-- Inizializzo ad 1, non memorizza il dato
	signal clock : std_logic :='0'; 				-- clock iniziale a 1
	signal reset : std_logic :='1'; 				-- reset ad 1
	signal Data : std_logic_vector(N-1 downto 0) :="00000001";	-- Bus dati ad 1

-- O U T P U T     S I G N A L S

	signal   pulse    : std_logic;

  	signal clk_cycle : integer;			-- Numero di periodi di clock
    	signal Testing: boolean := True;

begin
	i_GIP: GIP generic map(N=>8)			
		port map(LoadDelay, LoadLength, clock, reset, Data, pulse);

-------------------------------------------------------------------------------

   -- Generates clk

      clock     <= not clock after MckPer/2 when Testing else '0';

   -- Runs simulation for TestLen cycles;

   Test_Proc: process(clock)
      variable count: integer:= 0;
   begin
     clk_cycle <= (count+1)/2;		

     case count is
 	 when 2 => reset<='0';			-- resetto il circuito
	 when 4 => reset <= '1';
    	 when 5 => Data <="00000011";		-- nuovo dato
    	 when 8 => LoadLength <='0';		-- lo memorizzo nel registro per la lunghezza
    	 when 10 => LoadLength <='1';
    	 when 11 => Data <="00000111";		-- nuovo dato
    	 when 12 => LoadDelay <='0';		-- lo memorizzo nel registro per il ritardo
    	 when 14 => LoadDelay <='1';
    	 when 37 => Data <="00000101";		-- nuovo dato
    	 when 38 => LoadDelay <='0';		-- lo memorizzo nel registro per il ritardo
    	 when 40 => LoadDelay <='1';	
    	 when 51 => Data <="00000010";		-- nuovo dato
    	 when 52 => LoadLength <='0';		-- lo memorizzo nel registro per la lunghezza
    	 when 54 => LoadLength <='1';	
	 when 70 => reset <= '0'; 		-- resetto il circuito
	 when 72 => reset <= '1';
	 when 81 => Data <="00000010";		-- nuovo dato
    	 when 82 => LoadLength <='0';		-- lo memorizzo nel registro per la lunghezza
    	 when 84 => LoadLength <='1';
    	 when 99 => Data <="00000001";		-- nuovo dato
    	 when 100 => LoadDelay <='0';		-- lo memorizzo nel registro per il ritardo
    	 when 102 => LoadDelay <='1';	
	 when (TestLen - 1) =>   Testing <= False;
         when others => null;
     end case;
     count:= count + 1;
   end process Test_Proc;

   end GIP_test;

















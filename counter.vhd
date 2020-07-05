-------------------------------------------------------------------------------
-- (Structural)
--
-- File name : counter.vhd
-- Purpose   : Generatore di impulsi programmabile
--           :
-- Library   : IEEE
-- Author(s) : Valerio Tanferna
-------------------------------------------------------------------------------
--
-- Finche' start e' attivo alto, genera un dato in uscita, partendo da 0
-- e lo incrementa per ogni ciclo di clock
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity counter is

   generic (N : INTEGER:=8);
   port( start 		: in  std_logic;			-- Segnale attivo alto, genera numero, ricevuto dal gen_pulse
	 clock 		: in  std_logic;				
	 reset 		: in std_logic;				-- Al reset interrompe l'incremento e genera un valore pari a 0
         sum            : out std_logic_vector (N-1 downto 0));	-- Segnale di output inviato al gen_pulse
end counter;

architecture structure of counter is
	component adder is		-- componente adder
	   generic (N : integer:=8);
	   port(
	         b          : in  std_logic_VECTOR (N-1 downto 0);	-- Segnale dato in ingresso da incrementare, proveniente dal registro creg
	         start	    : in  std_logic;				-- Segnale attivo alto, finche' e' alto, incrementa il valore ogni ciclo di clock
		 clock	    : in  std_logic;
	         s          : out std_logic_VECTOR (N-1 downto 0));	-- Segnale di uscita, il valore di ingresso e' incrementato
	end component;

	component creg is
	generic (N: integer:=8);
	port(
		input : in std_logic_vector(N-1 downto 0);
		start : in std_logic;
		clock : in std_logic;
		reset : in std_logic;
		output : out std_logic_vector(N-1 downto 0);
		somma : out std_logic_vector(N-1 downto 0));
	end component;

	--signal clock : std_logic;
	--signal start : std_logic;
	signal s : std_logic_vector(N-1 downto 0);
	signal b : std_logic_vector(N-1 downto 0);
	signal output : std_logic_vector(N-1 downto 0);

	begin
	i_creg: creg
	port map(input => s, start => start, clock => clock, reset => reset, output => sum, somma => b);

	i_adder: adder
	port map(b => b, start => start, clock => clock, s => s);
	
end structure;

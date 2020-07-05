-------------------------------------------------------------------------------
-- (Structural)
--
-- File name : GIP.vhd
-- Purpose   : Generatore di impulsi programmabile
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

entity GIP is
	generic (N: integer:=8);
		port(
			Data : in std_logic_vector(N-1 downto 0);	-- Dato in ingresso
			reset : in std_logic;				-- Segnale di reset
			clock : in std_logic;
			LoadLength : in std_logic;			-- Segnale per memorizzare il Length del segnale, attivo basso
			LoadDelay : in std_logic;			-- Segnale per memorizzare il Delay del segnale, attivo basso
			pulse : out std_logic);				-- Segnale di uscita
end GIP;			

architecture structural of GIP is

	component reg is
	generic (N : integer:=8);
	port(
		input : in std_logic_vector(N-1 downto 0);
		Load : in std_logic;
		reset : in std_logic;
		output : out std_logic_vector(N-1 downto 0));
	end component;

	component counter is
	generic (N : integer:=8);
	port( start 		: in  std_logic;
	      clock 		: in  std_logic;			-- incremento sempre di uno
	      reset 		: in  std_logic;
     	      sum               : out std_logic_vector (N-1 downto 0));	-- inizializzo a zero
	end component;

	component gen_pulse is
	generic (N : integer:=8);
  	port(    L 		 : in  std_logic_vector(N-1 downto 0); -- from counter D
		 D		 : in  std_logic_vector(N-1 downto 0); -- from counter L
		 WDelay		 : in  std_logic_vector(N-1 downto 0); -- from regD
		 WLength	 : in  std_logic_vector(N-1 downto 0); -- from regL
		 reset		 : in std_logic;
		 clock		 : in std_logic;
		 Dstart		 : out std_logic;	-- for start counter D
		 Lstart		 : out std_logic;	-- for start counter L
		 Dsave		 : out std_logic;
		 Lsave 		 : out std_logic;
  	         wave            : out std_logic);
	end component;

	component sreg
  	 generic (N : integer:=8);
 	  port(
			input : in std_logic_vector(N-1 downto 0);
			save : in std_logic;
			output : out std_logic_vector(N-1 downto 0));
			
 	  end component;


	signal Dstart:		std_logic; -- equalL avvia D counter		AVVIO IL CIRCUITO ATTIVO BASSO
	signal Lstart:		std_logic; -- equalD avvia L counter

	signal Dsave: 		std_logic;
	signal Lsave: 		std_logic;

	signal regL2gen: 	std_logic_vector(N-1 downto 0);
	signal regD2gen: 	std_logic_vector(N-1 downto 0);

	signal regL2reg: 	std_logic_vector(N-1 downto 0);
	signal regD2reg: 	std_logic_vector(N-1 downto 0);

	signal sumD:		std_logic_vector(N-1 downto 0);
	signal sumL:		std_logic_vector(N-1 downto 0);

	begin
	i_counterD: counter
	port map(start => Dstart, clock => clock, reset => reset, sum => sumD);

	i_counterL: counter
	port map(start => Lstart, clock => clock, reset => reset, sum => sumL);

	i_regL: reg
	port map(input => Data, Load => LoadLength, reset => reset, output => regL2reg);

	i_regD: reg
	port map(input => Data, Load => LoadDelay, reset => reset, output => regD2reg);

	i_sregL: sreg
	port map(input => regL2reg, save => Lsave, output => regL2gen);

	i_sregD: sreg
	port map(input => regD2reg, save => Dsave, output => regD2gen);

	i_gen_pulse: gen_pulse
	port map (L => sumL, D => sumD, WDelay => regD2gen, WLength => regL2gen, reset => reset, clock => clock, Dstart => Dstart, Lstart => Lstart, Dsave => Dsave, Lsave => Lsave, wave => pulse);

end structural;



















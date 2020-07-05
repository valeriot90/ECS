-------------------------------------------------------------------------------
-- (Structural)
--
-- File name : creg.vhd
-- Purpose   : Counter register
--           :
-- Library   : IEEE
-- Author(s) : Valerio Tanferna
-------------------------------------------------------------------------------
--
-- Al reset o quando il segnale di start e' a 0, genera un output con valore 0
-- Quando start e' attivo alto manda in uscita il valore in ingresso
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity creg is
	generic (N: integer:=8);
		port(
			input : in std_logic_vector(N-1 downto 0);	-- Segnale di ingresso incrementato, ricevuto dall'adder
			start : in std_logic;				-- Segnale start attivo alto
			clock : in std_logic;				-- Segnale di clock
			reset : in std_logic;				-- Segnale di reset, attivo basso, l'output generato sara' 0
			output : out std_logic_vector(N-1 downto 0);	-- Segnale di output mandato al generatore di impulsi, collegato all'uscita del counter
			somma : out std_logic_vector(N-1 downto 0) );	-- Segnale di output inviato all'adder per incrementarlo, collegato all'adder
end creg;

architecture behavioural of creg is

begin
    creg:process(clock, start, reset)
     begin
	if(start = '0' or reset ='0')then	-- Se start o il reset e' attivo basso, in uscita il valore sara' 0
		output <= "00000000";
		somma <= "00000000";
	elsif(clock'event and clock ='1')then	-- Al clock il valore di uscita prendera' il valore di ingresso
		output <= input;
		somma <= input;
	end if;
     end process creg;

end behavioural;
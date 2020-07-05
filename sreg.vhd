-------------------------------------------------------------------------------
-- (Structural)
--
-- File name : sreg.vhd
-- Purpose   : Generatore di impulsi programmabile
--           :
-- Library   : IEEE
-- Author(s) : Valerio Tanferna
-------------------------------------------------------------------------------
--
-- Quando il valore save diventa attivo alto, il valore di uscita prende il valore
-- Di ingresso, ma, se quest'ultimo e' zero viene posto ad 1
-- Questo affinche' tutto il circuito quando resettato possa generare
-- Un impulso di lunghezza 1 e ritardo 1
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity sreg is
	generic (N: integer:=8);
	port(
		input : in std_logic_vector(N-1 downto 0);	-- Valore di ingresso, proveniente dal reg
		save : in std_logic;				-- Segnale attivo alto, proveniente dal gen_pulse
		output : out std_logic_vector(N-1 downto 0));	-- Valore di uscita
end sreg;

architecture behavioural of sreg is
begin
    sreg:process(save)--clock, save)
     begin
	if(save'event and save='1')then		-- L'uscita prende l'ingresso quando il segnale save diventa 1
		if(input = "00000000")then	-- Se zero, l'uscita prende 1
			output <= "00000001";
		elsif(input /= "00000000") then -- Se diverso da 0, l'uscita prende l'ingresso
			output <= input;
		end if;
	end if;
     end process sreg;

end behavioural;
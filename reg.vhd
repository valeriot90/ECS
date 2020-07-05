-------------------------------------------------------------------------------
-- (Structural)
--
-- File name : reg.vhd
-- Purpose   : Generatore di impulsi casuali
--           :
-- Library   : IEEE
-- Author(s) : Valerio Tanferna
-------------------------------------------------------------------------------
--
-- Quando il reset e' attivo basso, il registro memorizza 0
-- Altrimenti, se il segnale Load e' attivo basso memorizza il dato in gresso
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity reg is
	generic (N : integer:=8);
   port( input          : in  std_logic_vector(N-1 downto 0);  -- Dato di ingresso, provenniente dal bus dati
         Load 	        : in  std_logic; 			-- Segnale Load attivo basso: l'uscita prende l'ingresso
         reset	    	: in  std_logic; 			-- Reset attivo basso
	 output 	: out std_logic_vector(N-1 downto 0));  -- Dato di uscita del registro, lo invia al sreg
end reg;

architecture behavioural of reg is
begin
    reg:process(Load, reset)
     begin
	if (reset = '0') then		     -- Reset attivo basso, l'uscita prende 0
		output <= "00000000";
	elsif (Load'event and Load='0') then -- Load 0
		for i in N-1 downto 0 loop
			output(i) <= input(i); -- L'uscita prende l'ingresso
		end loop;
      end if;
     end process reg;

end behavioural;
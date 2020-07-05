-------------------------------------------------------------------------------
-- (Structural)
--
-- File name : gen_pulse.vhd
-- Purpose   : Generatore di impulsi casuali
--           :
-- Library   : IEEE
-- Author(s) : Valerio Tanferna
-------------------------------------------------------------------------------
--	     XOR  XNOR
--	00    0    1
--	01    1    0
--	10    1    0
--	11    0    1
--
-------------------------------------------------------------------------------
--
-- Genera l'impulso che sara' in uscita dal circuito
-- Al reset avvia il counter per il Delay e manda in uscita un segnale basso
-- Per avviare un contatore manda attivo alto il segnale save per salvare
-- Il nuovo dato ingresso al registro, sara' il valore di permanenza  del segnale
-- In quello stato (alto o basso) e terra' attivo alto il segnale start
-- Affinche' il counter non generera' un valore uguale a quello ricevuto dal registro
-- Quando tale valore sara' uguale (confronto con una porta XOR), bisognera'
-- Eseguire lo switch del segnale, da attivo alto a basso (o viceversa)
-- Mettera' lo start relativo al contatore che attualmente sta eseguendo a 0 
-- Ed alto lo start per l'altro contatore. Save sara' alto per un ciclo di
-- Clock affinche' l'altro registro possa salvare il nuovo dato.
-- Ripetutamente viene eseguito questo ciclo.
--
-- Necessario mantenere stato del segnale in una variabile "up" perche'
-- In caso di reset parto con Delay, ma se sono in stato di Delay
-- Il circuito non e' sensibile e continua a contare all'infinito
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity gen_pulse is
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
end gen_pulse;

architecture behavioural of gen_pulse is

begin
gen:process(clock, reset)
	
	variable xorD: std_logic_vector(N-1 downto 0); 	-- Variabile di appoggio per risultato dello XOR per il Delay
	variable xorL: std_logic_vector(N-1 downto 0);  -- Variabile di appoggio per risultato dello XOR per il Length
	variable Dsavev: std_logic;			-- Variabile di appoggio per cambiare lo stato del segnale Save per il Delay
	variable Lsavev: std_logic;			-- Variabile di appoggio per cambiare lo stato del segnale Save per il Length
	variable up: std_logic :='0'; 			-- Variabile di appoggio che indica lo stato del segnale di uscita: alto (1) o basso (0)

	begin
		if(reset = '0') then 			-- Al reset inizio con segnale di uscita basso
			if(up ='1')then			-- Se lo stato e' alto
				Dstart <= '1';		-- Avvio contatore per segnale Delay (basso)
				Lstart <= '0';		-- E disattivo quello per lo stato Length (alto)
			elsif(up ='0')then		-- Se lo stato e' basso
				Dstart <= '0';		-- Disattivo il segnale Delay (basso)
				Lstart <= '1';		-- E avvio contatore per segnale Length (alto)
			end if;

			Dsavev :='1';
			Lsavev :='1';
			if(reset = '0') then 		-- PER RITARDO non sto programmando: manda tutto contemporaneamente
				Dsave <= Dsavev;
				Lsave <= Lsavev;
				wave <='0';		-- L'impulso di uscita sara' 0
			end if;

		elsif(clock'event and clock='0') then 

			Dsavev :='0';			-- Metto a 0 i segnali si Save il i registri sreg, basta un impulso di un ciclo di clock
			Lsavev :='0';			-- Ad indicare che il registro deve salvare un nuovo valore
			if(Dsavev ='0' and Lsavev ='0')then -- PER RITARDO non sto programmando: manda tutto contemporaneamente
				Dsave <= Dsavev;
				Lsave <= Lsavev;
			end if;

			xorD := WDelay xor D;		-- Confronto dei risultati per il Delay
			xorL := WLength xor L;		-- COnfronto dei risultati per il Length
			if(xorD = "00000000")then 	-- Se uguali, ha raggiunto il tempo, avvio l'altro contatore
				Dstart <= '0';
				Lstart <= '1';		-- Delay terminato, avvio Length
				Lsavev := '1';
				if(xorD = "00000000")then -- PER RITARDOnon sto programmando: manda tutto contemporaneamente
					Lsave <= Lsavev;	-- segnale
				end if;
				wave <= '1';		-- Segnale di uscita alto
				up := '1';		-- Cambio stato
			elsif(xorL = "00000000")then	-- Se uguali, ha raggiunto il tempo, avvio l'altro contatore
				Dstart <= '1';		-- Length terminato, avvio Delay
				Lstart <= '0';
				Dsavev := '1';	
				if(xorL = "00000000")then -- PER RITARDOnon sto programmando: manda tutto contemporaneamente
					Dsave <= Dsavev;	-- segnale
				end if;
				wave <= '0';		-- Segnale di uscita basso
				up := '0';		-- Cambio stato
			end if;
		end if;
	end process gen;

end behavioural;





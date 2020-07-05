-------------------------------------------------------------------------------
-- (Structural)
--
-- File name : adder.vhd
-- Purpose   : Counter register
--           :
-- Library   : IEEE
-- Author(s) : Valerio Tanferna
-------------------------------------------------------------------------------
--
-- Incrementa di 1 il valore b dato in ingresso e lo manda in output s
-- ogni ciclo di clock finche' start e' attivo alto
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity adder is

   generic (N : integer:=8);
   port(
         b          : in  std_logic_vector (N-1 downto 0);	-- Segnale dato in ingresso da incrementare, proveniente dal registro creg
         start	    : in  std_logic;				-- Segnale attivo alto, finche' e' alto, incrementa il valore ogni ciclo di clock
	 clock	    : in  std_logic;
         s          : out std_logic_vector (N-1 downto 0));	-- Il valore di uscita incrementato, collegata alla porta di input del creg
end adder;

architecture behavioural of adder is

begin

    inc:process(start, clock, b) 
      variable C:std_logic;				-- variabile di appoggio per il carry
      variable a:std_logic_vector(N-1 downto 0);	-- variabile di appoggio
       variable ss:std_logic_vector(N-1 downto 0);
     begin
		C:='0';					-- carry inizializzato ad 1
		a:="00000001";				-- Incremento sempre il valore di ingresso di 1
	if(start = '0')then				-- Quando start e' basso il valore di uscita e' 0
		s<="00000000";
	elsif(clock='0')then				-- Se il clock e' 0 fai la somma (incrementa di 1)
		for i in 0 to N-1 loop
		         -- Calculate bit sum using carry from previous step, then carry out
		         s(i)<= a(i) xor b(i) xor C;
		         C:= (a(i) and b(i)) or (a(i) and C) or (b(i) and C);
	         end loop;
	end if;
	
      end  process inc;

end behavioural;

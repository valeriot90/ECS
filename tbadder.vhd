-------------------------------------------------------------------------------
-- (Structural)
--
-- File name : tbadder.vhd
-- Purpose   : Counter register
--           :
-- Library   : IEEE
-- Author(s) : Valerio Tanferna
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tbadder is

end tbadder;

architecture adder_test of tbadder is

   component adder

   generic (N : integer:=8);
   port(
         b          : in  std_logic_vector (N-1 downto 0);	-- Segnale dato in ingresso da incrementare, proveniente dal registro creg
         start	    : in  std_logic;				-- Segnale attivo alto, finche' e' alto, incrementa il valore ogni ciclo di clock
	 clock	    : in  std_logic;
         s          : out std_logic_vector (N-1 downto 0));	-- Il valore di uscita incrementato, collegata alla porta di input del creg
   end component;

   ----------------------------------------------------------------------------
   constant N       :  integer  := 8;       -- Bus Width
   constant MckPer  :  time     := 200 ns;  -- Master Clk period
   constant TestLen :  integer  := 24;      -- No. of Count (MckPer/2) for test

---------------initial value----------------------
-- I N P U T     S I G N A L S

   signal   clk  : std_logic := '0';
   signal   b    : std_logic_VECTOR (N-1 downto 0):="00000000";
   signal start : std_logic :='0';
   signal clock : std_logic :='0';

-- O U T P U T     S I G N A L S

   signal   s    : std_logic_vector (N-1 downto 0);

   signal clk_cycle : integer;
   signal Testing: Boolean := True;

begin

   i_adder : adder generic map(N=>8)
             port map(b, start, clock, s);

   ----------------------------------------------------------------------------

   -- Generates clk

      clk     <= not clk after MckPer/2 when Testing else '0';

   -- Runs simulation for TestLen cycles;

   Test_Proc: process(clk)
      variable count: integer:= 0;
   begin
     clk_cycle <= (count+1)/2;

     case count is
	  when 2 => start <= '1';	-- Avvio, il valore verra' incrementato
	  when 4 => start <= '0';
          when 6  =>  b <= "00000010";  -- Nuovo valore
	  when 10 => start <='1';	-- Avvio, il valore verra' incrementato
	  when 14 => start <='0';

          when (TestLen - 1) =>   Testing <= False;
          when others => null;
     end case;

     count:= count + 1;
   end process Test_Proc;

END adder_test;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Maquina_Expendedora is
port(
CLK : in std_logic; --Clock
RESET: in std_logic;
RESET_STOCK: in std_logic;
COIN_IN in std_logic_vector( 2 downto 0); --3 bits porque maximo entra 6 (101)
COIN_OUT: out std_logic_vector( 2 downto 0);  --3 bits porque maximo sale 4 de cambio si el cliente mete 1 y luego 5 (100)
LATA: out std_logic;
EMPTY: out std_logic --lo metemos como salida porque queremos usarlo como un led que avise del stock
);
end Maquina_Expendedora;

architecture Behavioral of Maquina_Expendedora is
  type estados is (s0,s1,s2);
  signal estado, estado_siguiente : estados; 
	signal count : UNSIGNED(width-1 DOWNTO 0);--2 bits porque va de 0 a 3
  

begin

 process (CLK,RESET,RESET_STOCK) begin
   if(RESET_STOCK = '1') then
     EMPTY <= '0';
     count <= "00";--el stock se rellena a 3
   end if;
    if(RESET='1') then
      estado <= s0;
      COIN_IN <= "000" ; --se devolverá todo lo metido
    elsif rising_edge(CLK) then
      estado <= estado_siguiente; 
    end if;
  end process;

 process(COIN_IN,COIN_OUT, count, LATA, EMPTY, estado, estado_siguiente) begin
   if (count = "11")--si el stock llega al tope
     EMPTY <= '1';
   end if;
    if(EMPTY = '1') 
      COIN_OUT <= COIN_IN; --si el usuario mete dinero sin stock se le devuelve automaticamente
    else --si hay stock la maquina funciona con normalidad
      case (estado) is
          when s0 =>
             if(COIN_IN <= "001") then estado_siguiente <= s1; --1€ metido va al s1 a la espera de más dinero
               else if (COIN_IN != "001") then estado_siguiente <= s2;--Cualquier cantidad distinta a 1€ lleva al estado 2, donde dependiendo de la cantidad se verá                
              end if;
          when s1 =>   
             if(COIN_IN <= "001") then COIN_IN <= "010" & estado_siguiente <= s2;--si se mete otro 1€ el total son 2€
               else if(COIN_IN <= "010") then COIN_IN <= "011" & estado_siguiente <= s2; --si se mete otro 2€ el total son 3€
                 else if(COIN_IN <= "101") then COIN_IN <= "110" & estado_siguiente <= s2;--si se mete otro 5€ el total son 6€ 
                   else if (RESET <= '1') then COIN_OUT <= "001" & estado_siguiente <= s0;;--si se anula se devuelve 1€
                   end if;
                 end if;
                end if;
          when s2 =>
             if(COIN_IN <= "010") then COIN_OUT <= "000";  --Si lo introducido es justo se devuelven 0€
               else if(COIN_IN <= "011")then COIN_OUT <= "001";  --Si lo introducido es 3€ se devuelven 1€
                 else if(COIN_IN <= "101")then COIN_OUT <= "011";--Si lo introducido es 5€ se devuelven 3€
                  else if(COIN_IN <= "110")then COIN_OUT <= "100";--Si lo introducido es 6€ se devuelven 4€
                  end if;
                 end if;   
               end if;
             end if;    
             LATA <= '1';--Se activa y recibe la lata
             count <= count + 1;--se actualiza el stock
             RESET <= '1';--para que la maquina vuelva al estado inicial
          when others => null;--para casos excepcionales
      end case;
      end if;
 end process;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Maquina_Expendedora is
port(
CLK : in std_logic; --Clock
RESET: in std_logic;
COIN_IN in std_logic_vector( 2 downto 0); --3 bits porque maximo entra 6 (101)
COIN_OUT: out std_logic_vector( 2 downto 0);  --3 bits porque maximo sale 4 de cambio si el cliente mete 1 y luego 5 (100)
LATA: out std_logic
);
end Maquina_Expendedora;

architecture Behavioral of Maquina_Expendedora is
  type estados is (s0,s1,s2);
  signal estado, estado_siguiente : estados; 

begin

 process (CLK) begin
    if(RESET='1') then
      estado <= s0;
    elsif rising_edge(CLK) then
      estado <= estado_siguiente; 
    end if;
  end process;

 process(COIN_IN,COIN_OUT,LATA, estado, estado_siguiente) begin
      case (estado) is
          when s0 =>
             if(COIN_IN = "001") then estado_siguiente <= s1; --1€ metido va al s1 a la espera de más dinero
               else if (COIN_IN != "001") then estado_siguiente <= s2;--Cualquier cantidad distinta a 1€ lleva al estado 2, donde dependiendo de la cantidad se verá                
              end if;
          when s1 =>   
             if(COIN_IN = "001") then estado_siguiente <= s2;--si se mete otro 1€ el total son 2€
               else if(COIN_IN = "010") then COIN_IN <= "011" & estado_siguiente <= s2; --si se mete otro 2€ el total son 3€
                 else if(COIN_IN = "101") then COIN_IN <= "110" & estado_siguiente <= s2;--si se mete otro 5€ el total son 6€ 
                   else if (RESET = '1') then COIN_OUT <= "001" & estado_siguiente <= s0;;--si se anula se devuelve 1€
                   end if;
                 end if;
                end if;
          when s2 =>
             if(COIN_IN = "010") then COIN_OUT <= "000";  --Si lo introducido es justo se devuelven 0€
               else if(COIN_IN = "011")then COIN_OUT <= "001";  --Si lo introducido es 3€ se devuelven 1€
                 else if(COIN_IN = "101")then COIN_OUT <= "011";--Si lo introducido es 5€ se devuelven 3€
                  else if(COIN_IN = "110")then COIN_OUT <= "100";--Si lo introducido es 6€ se devuelven 4€
                  end if;
                 end if;   
               end if;
             end if;    
             LATA <= '1';--Se activa y recibe la lata
          when others => null;--para casos excepcionales
      end case;
 end process;
end Behavioral;

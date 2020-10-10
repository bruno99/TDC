library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Maquina_Expendedora is
port(
CLK : in std_logic; --Clock
RESET: in std_logic;
COIN_IN in std_logic_vector( 2 downto 0); --3 bits porque maximo entra 5 (101)
COIN_OUT: out std_logic_vector( 1 downto 0);  --2 bits porque maximo sale 3 (11)
LATA: out std_logic
);
end Maquina_Expendedora;

architecture Behavioral of Maquina_Expendedora is
  type estados is (s0,s1,s2,s3,s4);
  signal estado, estado_siguiente : estados; 

begin

 process (CLK,RESET) begin
    if(RESET='1') then
      estado <= s0;
      COIN_IN <= "000" ; --se devolverá todo lo metido
    elsif rising_edge(CLK) then
      estado <= estado_siguiente; 
    end if;
  end process;

 process(COIN_IN,COIN_OUT,LATA, estado, estado_siguiente) begin
      case (estado) is
          when s0 =>
             if(COIN_IN <= "001") then estado_siguiente <= s1;
               else if (COIN_IN <= "010") then estado_siguiente <= s2;
                 else estado_siguiente <= s3;
               end if;
              end if;
          when s1 =>   
             if(COIN_IN <= "001") then COIN_IN <= "010" & estado_siguiente <= s2;
               else if (RESET <= '1') then COIN_OUT <= "01";
          when s2 =>
             COIN_OUT <= "00";
             LATA <= '1';
             RESET <= '1';--para que la maquina vuelva al estado inicial
          when s3 =>
             COIN_OUT <= "11";
             LATA <= '1';
             RESET <= '1';--para que la maquina vuelva al estado inicial  
          when others => null;
      end case;
 end process;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Maquina_Expendedora is
--nada porque es un tesbench
end tb_Maquina_Expendedora;

  architecture Behavior of tb_Maquina_Expendedora is
  
    --Definir componetes
    Component Maquina_Expendedora is
    port(
CLK : in std_logic; --Clock
RESET: in std_logic;
COIN_IN: in std_logic_vector( 2 downto 0); 
COIN_OUT: out std_logic_vector( 2 downto 0); 
LATA: out std_logic
);
    end component;
   
    -- Definir señales
    signal CLK, RESET: std_logic;
    signal COIN_IN:  std_logic_vector( 2 downto 0); 
    signal COIN_OUT:  std_logic_vector( 2 downto 0); 
    signal LATA:  std_logic;
    
  begin  
    -- Instanciamos tb_Maquina_Expendedora
    DUT:  Maquina_Expendedora port map(
        CLK   => CLK,
        RESET  => RESET,
        COIN_IN  => COIN_IN,
        COIN_OUT => COIN_OUT,
        LATA =>LATA
    );
   process begin
    CLK <= '0'; wait for 10ns;
    CLK <= '1'; wait for 15ns;
end process;
process begin 
    RESET <= '0'; wait;
end process;
     process  begin
  
     --PROBAMOS TODAS LAS POSIBILIDADES
     
    COIN_IN <= "001";   wait for 10 ns;    --LATA será 0 y COIN_OUT será 0 a la espera de más órdenes
    COIN_IN <= "010";   wait for 10 ns;    --LATA será 1 y COIN_OUT será 0
    COIN_IN <= "011";   wait for 10 ns;    --LATA será 1 y COIN_OUT será 1
    COIN_IN <= "100";   wait for 10 ns;    --LATA será 1 y COIN_OUT será 2
    COIN_IN <= "101";   wait for 10 ns;    --LATA será 1 y COIN_OUT será 3
    COIN_IN <= "110";   wait for 10 ns;    --LATA será 1 y COIN_OUT será 4

   
        end process;
 end Behavior;  

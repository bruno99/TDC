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
RESET_STOCK: in std_logic;
COIN_IN in std_logic_vector( 2 downto 0); 
COIN_OUT: out std_logic_vector( 2 downto 0); 
LATA: out std_logic;
EMPTY: out std_logic
COUNT: out std_logic_vector(width-1 DOWNTO 0);  
);
    end component;
   
    -- Definir señales
    signal CLK, RESET, RESET_STOCK: std_logic;
    signal COIN_IN in std_logic_vector( 2 downto 0); 
    signal COIN_OUT: out std_logic_vector( 2 downto 0); 
    signal LATA: out std_logic;
    signal EMPTY: out std_logic;
    signal COUNT: out std_logic_vector(width-1 DOWNTO 0);  
    
    -- Instanciamos tb_Maquina_Expendedora
    DUT : tb_Maquina_Expendedora port map(
        CLK   => CLK,
        RESET  => RESET,
        RESET_STOCK => RESET_STOCK,
        COIN_IN  => COIN_IN,
        COIN_OUT => COIN_OUT,
        LATA =>LATA,
        EMPTY => EMPTY,
        COUNT => COUNT
       
    );
   
begin
  process begin 
    RESET <= '0'; wait;
end process;
      process begin 
    RESET_STOCK <= '0'; wait;
end process;     
        
     process(CLK)
   begin
     --PROBAMOS TODAS LAS POSIBILIDADES
    
    --El contador saldría con el stock restante
    COIN_IN <= "001";  wait 10 ns;    --LATA será 0 y COIN_OUT será 0 a la espera de más órdenes
    COIN_IN <= "010";  wait 10 ns;    --LATA será 1 y COIN_OUT será 0
    COIN_IN <= "011";  wait 10 ns;    --LATA será 1 y COIN_OUT será 1
    COIN_IN <= "100";  wait 10 ns;    --LATA será 1 y COIN_OUT será 2
    RESET_STOCK <='1'; -- Reseteamos el stock para que se puedan vender mas latas
    COIN_IN <= "101";  wait 10 ns;    --LATA será 1 y COIN_OUT será 3
    COIN_IN <= "110";  wait 10 ns;    --LATA será 1 y COIN_OUT será 4

   
        end process;
 end Behavior;
      

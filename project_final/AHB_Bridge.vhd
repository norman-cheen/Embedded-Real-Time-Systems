library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library gaisler;
use gaisler.misc.all;
library UNISIM;
use UNISIM.VComponents.all;

entity AHB_bridge is
 port(
 -- Clock and Reset -----------------
 clkm : in std_logic;
 rstn : in std_logic;
 -- AHB Master records --------------
 ahbmi : in ahb_mst_in_type;
 ahbmo : out ahb_mst_out_type;
 -- ARM Cortex-M0 AHB-Lite signals -- 
 HADDR : in std_logic_vector (31 downto 0); -- AHB transaction address
 HSIZE : in std_logic_vector (2 downto 0); -- AHB size: byte, half-word or word
 HTRANS : in std_logic_vector (1 downto 0); -- AHB transfer: non-sequential only
 HWDATA : in std_logic_vector (31 downto 0); -- AHB write-data
 HWRITE : in std_logic; -- AHB write control
 HRDATA : out std_logic_vector (31 downto 0); -- AHB read-data
 HREADY : out std_logic -- AHB stall signal
 );
end;
architecture structural of AHB_bridge is
--declare a component for state_machine
 
--declare a component for ahbmst 
 component ahbmst is 
  generic (
    hindex  : integer := 0;
    hirq    : integer := 0;
    venid   : integer := VENDOR_GAISLER;
    devid   : integer := 0;
    version : integer := 0;
    chprot  : integer := 3;
    incaddr : integer := 0); 
  port (
      rst  : in  std_ulogic;
      clk  : in  std_ulogic;
      dmai : in ahb_dma_in_type;
      dmao : out ahb_dma_out_type;
      ahbi : in  ahb_mst_in_type;
      ahbo : out ahb_mst_out_type 
      );
  end component; 
--declare a component for data_swapper 
  component data_swapper is
   port(
     dmao:in  ahb_dma_out_type;
     HRDATA:out std_logic_vector (31 downto 0)); 
   end component; 
 
signal dmai : ahb_dma_in_type;
signal dmao : ahb_dma_out_type;
begin
 
--instantiate state_machine component and make the connections
--instantiate the ahbmst component and make the connections 
  
 ahbmst_comp: ahbmst port map(rstn,clkm,dmai,dmao,ahbmi,ahbmo);
   
--instantiate the data_swapper component and make the connections

 data_swapper_comp: data_swapper port map(dmao,HRDATA);

end structural;
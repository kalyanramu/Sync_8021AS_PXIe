-------------------------------------------------------------------------------
--
-- File: OneGbEClip.vhd
-- Author: National Instruments
-- Original Project: NI 793xR 10 Gigabit Ethernet Example
-- Date: 11/18/2015
--
-------------------------------------------------------------------------------
-- (c) 2015 Copyright National Instruments Corporation
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--
-- This is the top level VHDL file for the CLIP that provides diagrammatic
-- passthru of the single ended GPIOs and other signals and also hooks up the
-- PCS/PMA IP from Xilinx to the OpenCores.org XGE MAC
--
-- When configuring the LabVIEW FPGA Target, this CLIP requires the following
--
-- MGT_RefClk0: Enabled, 156.25 MHz
-- PORT 0, PORT 1: Enabled, TX and RX
--
-- Changes to the Clocking & Routing property section that differ from this
-- default will require changes to the CLIP for successful compiles.
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;

--synthesis translate_off
library unisim;
  use unisim.vcomponents.all;
--synthesis translate_on

entity OneGbEClip is
  port(
    -------------------------------------------------------------------------------------
    -- Front-panel facing signals and Required signals
    -------------------------------------------------------------------------------------
    
    -- IO Socket I/O (Single-ended GPIO connector interface signals)
    PFI0_GPIO_In                   : in    std_logic;
    PFI0_GPIO_Out                  : out   std_logic;
    PFI0_GPIO_OutEnable_n          : out   std_logic;
    PFI1_GPIO_In                   : in    std_logic;
    PFI1_GPIO_Out                  : out   std_logic;
    PFI1_GPIO_OutEnable_n          : out   std_logic;
    PFI2_GPIO_In                   : in    std_logic;
    PFI2_GPIO_Out                  : out   std_logic;
    PFI2_GPIO_OutEnable_n          : out   std_logic;
    PFI3_GPIO_In                   : in    std_logic;
    PFI3_GPIO_Out                  : out   std_logic;
    PFI3_GPIO_OutEnable_n          : out   std_logic;

    -------------------------------------------------------------------------------------
    -- Socketed CLIP Signals
    -------------------------------------------------------------------------------------
    Port0_RX_n                     : in    std_logic;
    Port0_RX_p                     : in    std_logic;
    Port0_TX_n                     : out   std_logic;
    Port0_TX_p                     : out   std_logic;
    Port0_Mod_Abs                  : in    std_logic; --aka MODDEF0, represents GND, grounded by the module to indicate module present
    Port0_RS0                      : out   std_logic; --RX Rate Select, default 1 for rates greater than 4.25 Gbps
    Port0_RS1                      : out   std_logic; --TX Rate Select, default 1 for rates greater than 4.25 Gbps
    Port0_Rx_LOS                   : in    std_logic; --Loss of signal, when high indicates received optical power below worst-case
    Port0_Tx_Disable               : out   std_logic; --Optical output disabled when high
    Port0_Tx_Fault                 : in    std_logic; --TX fault indicator, unconnected in 10GbE IP core
    Port0_SCL                      : inout std_logic; --aka MODDEF1, clock line of serial interface
    Port0_SDA                      : inout std_logic; --aka MODDEF2, data line of serial interface
    
    Port1_RX_n                     : in    std_logic;
    Port1_RX_p                     : in    std_logic;
    Port1_TX_n                     : out   std_logic;
    Port1_TX_p                     : out   std_logic;
    Port1_Mod_Abs                  : in    std_logic;
    Port1_RS0                      : out   std_logic;
    Port1_RS1                      : out   std_logic;
    Port1_Rx_LOS                   : in    std_logic;
    Port1_Tx_Disable               : out   std_logic;
    Port1_Tx_Fault                 : in    std_logic;
    Port1_SCL                      : inout std_logic;
    Port1_SDA                      : inout std_logic;   
    
    Port2_RX_n                     : in    std_logic;
    Port2_RX_p                     : in    std_logic;
    Port2_TX_n                     : out   std_logic;
    Port2_TX_p                     : out   std_logic;
    Port2_Mod_Abs                  : in    std_logic;
    Port2_RS0                      : out   std_logic;
    Port2_RS1                      : out   std_logic;
    Port2_Rx_LOS                   : in    std_logic;
    Port2_Tx_Disable               : out   std_logic;
    Port2_Tx_Fault                 : in    std_logic;
    Port2_SCL                      : inout std_logic;
    Port2_SDA                      : inout std_logic;
    
    Port3_RX_n                     : in    std_logic;
    Port3_RX_p                     : in    std_logic;
    Port3_TX_n                     : out   std_logic;
    Port3_TX_p                     : out   std_logic;   
    Port3_Mod_Abs                  : in    std_logic;
    Port3_RS0                      : out   std_logic;
    Port3_RS1                      : out   std_logic;
    Port3_Rx_LOS                   : in    std_logic;
    Port3_Tx_Disable               : out   std_logic;
    Port3_Tx_Fault                 : in    std_logic;
    Port3_SCL                      : inout std_logic;
    Port3_SDA                      : inout std_logic;       
    
    -- These signals enable/disable the cable power supply for the front
    -- panel connectors and report the status of this supply
    sPort0_EnablePower             : out   std_logic; --3.3V power applied
    sPort0_PowerGood               : in    std_logic; --Recevier, transmitter power supply is on (VR ON, VT ON)
    sPort1_EnablePower             : out   std_logic;
    sPort1_PowerGood               : in    std_logic;
    sPort2_EnablePower             : out   std_logic;
    sPort2_PowerGood               : in    std_logic;
    sPort3_EnablePower             : out   std_logic;
    sPort3_PowerGood               : in    std_logic;   
    
    -- IO Socket I/O (MGT reference clock differential pair pads)
    MGT_RefClk0_p                  : in    std_logic;
    MGT_RefClk0_n                  : in    std_logic;
    MGT_RefClk1_p                  : in    std_logic;
    MGT_RefClk1_n                  : in    std_logic;
    MGT_RefClk2_p                  : in    std_logic;
    MGT_RefClk2_n                  : in    std_logic;

    -- These two signals indicate the health of the clocks that are generated for use
    -- at the MgtRefClkX clocks above.  There is one PLL that recovers a clock that feeds
    -- both of these clocks.  The Valid signal includes additional logic from
    -- configuration of the FPGA Target and Si5368 outputs. @ToDo more docs.
    MGT_RefClks_ExtPllLocked       : in    std_logic;
    MGT_RefClks_Valid              : in    std_logic;   
    
    -- The CLIP may recover a clock and export it to the onboard clock routing circuitry.
    ExportedUserReferenceClk       : out   std_logic;

    -- These are outputs that the CLIP may assert to drive the Active and Access LEDs
    -- on the front panel.  The fixed logic may pre-empt the CLIP's access to these LEDs
    -- to show general purpose error conditions, temperature faults, etc...
    -- (clk156 domain)
    LED_ActiveRed                  : out   std_logic;
    LED_ActiveGreen                : out   std_logic;

    -- 40 MHz clock for the socket
    SocketClk40                    : in    std_logic;
    
    -- These clocks can be provided by the CLIP that the Fixed Logic may monitor them
    -- via frequency counters, etc... and provide status to the host methods
    DebugClks                      : out   std_logic_vector(3 downto 0);

    -- The fixed logic has a POSC (power on self configuration) state machine that
    -- configures various subsystems on the board.  This line will assert high
    -- when the fixed logic is done configuring the various chips, etc...
    sFrontEndConfigurationDone     : in    std_logic;
    
    -- These signals provide a handshaking mechanism for triggering a
    -- reconfiguration of the board while powered on.
    -- Prepare tells the CLIP to shut down, and when it is fully shut down it sends Ready.
    -- This is unused but required in the design.
    sFrontEndConfigurationPrepare  : in    std_logic;
    sFrontEndConfigurationReady    : out   std_logic;    
    ---------------------------------------------------------------------------
    -- LVFPGA signals
    ---------------------------------------------------------------------------
    -- This is the collection of signals that appear in LabVIEW FPGA.
    -- LabVIEW FPGA signals must use one of the following signal directions:  {in, out}
    -- LabVIEW FPGA signals must use one of the following data types:
    --          std_logic
    --          std_logic_vector(7 downto 0)
    --          std_logic_vector(15 downto 0)
    --          std_logic_vector(31 downto 0)
    ---------------------------------------------------------------------------
    -- Asynchronous reset signal from the LabVIEW FPGA environment.
    -- This signal *must* be present in the port interface for all IO Socket CLIPs.
    -- You should reset your CLIP logic whenever this signal is logic high.
    aResetSl             : in  std_logic;
    ---------------------------------------------------------------------------
    -- Dynamic GPIO Lines
    PFI0_In              : out std_logic;
    PFI0_Out             : in  std_logic;
    PFI0_OutEnable       : in  std_logic;
    PFI1_In              : out std_logic;
    PFI1_Out             : in  std_logic;
    PFI1_OutEnable       : in  std_logic;
    PFI2_In              : out std_logic;
    PFI2_Out             : in  std_logic;
    PFI2_OutEnable       : in  std_logic;
    PFI3_In              : out std_logic;
    PFI3_Out             : in  std_logic;
    PFI3_OutEnable       : in  std_logic;
    -- MAC Interface
    --s_axi_aclk           : in  std_logic;
    --rx_statistics_vector : out std_logic_vector(27 downto 0);
    --rx_statistics_valid  : out std_logic;
    rx_mac_aclk          : out std_logic;
    --rx_reset             : out std_logic;
    --rx_axis_filter_tuser : out std_logic_vector(4 downto 0);
    --rx_axis_mac_tdata    : out std_logic_vector(7 downto 0);
    --rx_axis_mac_tvalid   : out std_logic;
    --rx_axis_mac_tlast    : out std_logic;
    --rx_axis_mac_tuser    : out std_logic;
    --tx_ifg_delay         : in  std_logic_vector(7 downto 0);
    --tx_statistics_vector : out std_logic_vector(31 downto 0);
    --tx_statistics_valid  : out std_logic;
    tx_mac_aclk          : out std_logic;
    --tx_reset             : out std_logic;
    tx_axis_mac_tdata    : in  std_logic_vector(7 downto 0);
    tx_axis_mac_tvalid   : in  std_logic;
    tx_axis_mac_tlast    : in  std_logic;
    tx_axis_mac_tuser    : in  std_logic_vector(0 downto 0);
    tx_axis_mac_tready   : out std_logic;
    --pause_req            : in  std_logic;
    --pause_val            : in  std_logic_vector(15 downto 0);
    --speedis100           : out std_logic;
    --speedis10100         : out std_logic;
    --s_axi_awaddr         : in  std_logic_vector(11 downto 0);
    --s_axi_awvalid        : in  std_logic;
    --s_axi_awready        : out std_logic;
    --s_axi_wdata          : in  std_logic_vector(31 downto 0);
    --s_axi_wvalid         : in  std_logic;
    --s_axi_wready         : out std_logic;
    --s_axi_bresp          : out std_logic_vector(1 downto 0);
    --s_axi_bvalid         : out std_logic;
    --s_axi_bready         : in  std_logic;
    --s_axi_araddr         : in  std_logic_vector(11 downto 0);
    --s_axi_arvalid        : in  std_logic;
    --s_axi_arready        : out std_logic;
    --s_axi_rdata          : out std_logic_vector(31 downto 0);
    --s_axi_rresp          : out std_logic_vector(1 downto 0);
    --s_axi_rvalid         : out std_logic;
    --s_axi_rready         : in  std_logic;
    mac_irq           : out std_logic;
    -- MB Interface
    reset_rtl         : in  std_logic;
    mb_clk            : in  std_logic;
    gpi0              : in  std_logic_vector (31 downto 0);
    gpo0              : out std_logic_vector (31 downto 0);
    gpi1              : in  std_logic_vector (31 downto 0);
    gpo1              : out std_logic_vector (31 downto 0);
    --
    M1_MB_AXIS_tdata  : out std_logic_vector (31 downto 0);
    M1_MB_AXIS_tlast  : out std_logic;
    M1_MB_AXIS_tready : in  std_logic;
    M1_MB_AXIS_tvalid : out std_logic;
    S1_MB_AXIS_tdata  : in  std_logic_vector (31 downto 0);
    S1_MB_AXIS_tlast  : in  std_logic;
    S1_MB_AXIS_tready : out std_logic;
    S1_MB_AXIS_tvalid : in  std_logic;
    --
    BRAM_PORTB_addr   : in  std_logic_vector (31 downto 0);
    --BRAM_PORTB_clk  : in  std_logic;
    BRAM_PORTB_din    : in  std_logic_vector (31 downto 0);
    BRAM_PORTB_dout   : out std_logic_vector (31 downto 0);
    BRAM_PORTB_en     : in  std_logic;
    BRAM_PORTB_rst    : in  std_logic;
    BRAM_PORTB_we     : in  std_logic_vector (3 downto 0);
    --
    -- Required Clock
    -- This signal is present to facilitate requiring a clock to be a specific
    -- clock from the LabVIEW environment. SocketClk40 is the same signal as
    -- 40 MHz Onboard Clock, but we need to have this metadata available in the
    -- CLIP XML to force this signal to be in this particular clock domain.
    OnboardClk40ToClip   : in  std_logic;
    -- need 200 MHz clock for IDELAYs
    independent_clock    : in  std_logic;
    -- ClockFrm CLIP to recv data
    --gmii_rx_clk        : out std_logic;
    --gmii_tx_clk        : in std_logic;
--    tx_mac_aclk          : out std_logic;
--    rx_mac_aclk          : out std_logic;
    --
    -- Mgt RefClk status signals
    MgtRefClks_Locked    : out std_logic;
    MgtRefClks_Valid     : out std_logic;
    -- PLL lock signal to let management interface know when to begin
    PllLocked            : out std_logic
    );
    
end OneGbEClip;

architecture rtl of OneGbEClip is
  component IBUF
    port(i : in  std_logic;
         o : out std_logic);
  end component;



  signal aReset : std_logic;
  signal aReset_n : std_logic;
  signal gt0_eyescanreset     : std_logic := '0';
  signal gt0_eyescantrigger   : std_logic := '0';
  signal gt0_rxcdrhold        : std_logic := '0';
  signal gt0_txprbsforceerr   : std_logic := '0';
  signal gt0_txpolarity       : std_logic := '0';
  signal gt0_rxpolarity       : std_logic := '1'; -- inverted in layout
  signal gt0_rxrate           : std_logic_vector(2 downto 0) := "000";
  signal gt0_txprecursor      : std_logic_vector(4 downto 0) := "00000";
  signal gt0_txpostcursor     : std_logic_vector(4 downto 0) := "00000";
  signal gt0_txdiffctrl       : std_logic_vector(3 downto 0) := "1110";
  signal gt0_eyescandataerror : std_logic;
  signal gt0_txbufstatus      : std_logic_vector(1 downto 0);
  signal gt0_rxbufstatus      : std_logic_vector(2 downto 0);
  signal gt0_txpmareset       : std_logic := '0';
  signal gt0_rxpmareset       : std_logic := '0';
  signal gt0_rxpmaresetdone   : std_logic;
  signal gt0_rxdfelpmreset    : std_logic := '0';
  signal gt0_rxlpmen          : std_logic := '0';
  signal gt0_rxprbserr        : std_logic;
  signal gt0_dmonitorout      : std_logic_vector(7 downto 0);

  signal signal_detect_Port0_i : std_logic;
  signal gtx_clk : std_logic;
  signal tx_mac_aclk_int, rx_mac_aclk_int : std_logic;
  -- GMII interface
  signal gmii_txd   : std_logic_vector(7 downto 0);
  signal gmii_tx_en : std_logic;
  signal gmii_tx_er : std_logic;
  signal gmii_rxd   : std_logic_vector(7 downto 0);
  signal gmii_rx_dv : std_logic;
  signal gmii_rx_er : std_logic;
  -- MDIO Support to PCS
  signal to_phy_mdc, to_phy_mdio_i, from_phy_mdio_o : std_logic;
  signal mgt_clk_clk_n     :  std_logic;
  signal mgt_clk_clk_p     :  std_logic;
  
begin
  
  tx_axis_mac_tready <= '0';

  aReset <= aResetSl;
  aReset_n <= not aReset;

  LED_ActiveGreen <= '1';
  LED_ActiveRed   <= '1';
  OneGbEStatus : block
    --signal signal_detect_ms : std_logic_vector(1 downto 0);
    signal PowerGood_ms     : std_logic_vector(1 downto 0);
    signal BlockLock_ms     : std_logic_vector(1 downto 0);
    -- 659x unique signals
    signal MGT_RefClks_Valid_ms        : std_logic;
    signal MGT_RefClks_ExtPllLocked_ms : std_logic;
  begin
    ni659xStatusSynchronizer: process (OnboardClk40ToClip, aReset) is
    begin  -- process ni659xStatusSynchronizer
      if aReset = '1' then              -- asynchronous reset (active high)
        MGT_RefClks_ExtPllLocked_ms <= '0';
        MGT_RefClks_Valid_ms        <= '0';
        MgtRefClks_Valid            <= '0';
        MgtRefClks_Locked           <= '0';
        PllLocked                   <= '0';
      elsif rising_edge(OnboardClk40ToClip) then  -- rising clock edge
        ------------------------------------------------------------
        -- synchronize MGT_RefClks_* internal signals to Clk40
        MGT_RefClks_Valid_ms        <= MGT_RefClks_Valid;
        MGT_RefClks_ExtPllLocked_ms <= MGT_RefClks_ExtPllLocked;
        -- Clock Status Signals
        MgtRefClks_Locked <= MGT_RefClks_ExtPllLocked_ms;
        MgtRefClks_Valid  <= MGT_RefClks_Valid_ms;
        -- The si5368 must indicated that it is locked and the fixed logic must
        -- indicate that the reference clock is established
        PllLocked <= MGT_RefClks_ExtPllLocked_ms and MGT_RefClks_Valid_ms;  
      end if;
    end process ni659xStatusSynchronizer;
  end block; 
  -- Enable power on all ports, SFP+ standard does not require the power line to be disabled when no module is present.
  sPort0_EnablePower <= '1';
  sPort1_EnablePower <= '1';
  -------------------------------------------------------------------------------------
  -- Unused ports
  -------------------------------------------------------------------------------------
  Port1_RS0          <= '1';
  Port1_RS1          <= '1';
  Port2_RS0          <= '1';
  Port2_RS1          <= '1';
  Port3_RS0          <= '1';
  Port3_RS1          <= '1';
  Port2_Tx_Disable   <= '0';
  Port3_Tx_Disable   <= '0';
  sPort2_EnablePower <= '0';  --Powered down since unused in this example
  sPort3_EnablePower <= '0';
  Port2_TX_n         <= '0';          --TX tied to 0 on unused ports
  Port2_TX_p         <= '0';          --TX tied to 0 on unused ports
  Port3_TX_n         <= '0';          --TX tied to 0 on unused ports
  Port3_TX_p         <= '0';          --TX tied to 0 on unused ports
  ---------------------------------------------------------------------------------------
  -- General Purpose I/O
  --
  -- For the GPIO, there are a lot of signal assignments that need to happen that
  -- are pass-through.  We use look-up tables and generate statements to do this mapping
  -- of the I/O to the correct pins.  The look-up table includes the aUserGpio pin number
  -- and a selection of whether it is the positive or negative terminal.

  GeneralPurposeIO: block
  begin  -- block GeneralPurposeIO

    PFI0_GPIO_Out <= PFI0_Out;
    PFI0_GPIO_OutEnable_n <= NOT PFI0_OutEnable;

    PFI1_GPIO_Out <= PFI1_Out;
    PFI1_GPIO_OutEnable_n <= NOT PFI1_OutEnable;

    PFI2_GPIO_Out <= PFI2_Out;
    PFI2_GPIO_OutEnable_n <= NOT PFI2_OutEnable;

    PFI3_GPIO_Out <= PFI3_Out;
    PFI3_GPIO_OutEnable_n <= NOT PFI3_OutEnable;

    PFI0_In <= PFI0_GPIO_In;
    PFI1_In <= PFI1_GPIO_In;
    PFI2_In <= PFI2_GPIO_In;
    PFI3_In <= PFI3_GPIO_In;
  end block GeneralPurposeIO;

  signal_detect_Port0_i <= Port0_Mod_ABS nor Port0_Rx_LOS;
  
  MgtRefClkP : component IBUF
    port map (
      i => MGT_RefClk0_p,
      o => mgt_clk_clk_p);

  MgtRefClkN : component IBUF
    port map (
      i => MGT_RefClk0_n,
      o => mgt_clk_clk_n);
  
block_diagram_i: entity work.block_diagram_wrapper
  port map (
    BRAM_PORTB_addr   => BRAM_PORTB_addr,
    BRAM_PORTB_clk    => mb_clk,
    BRAM_PORTB_din    => BRAM_PORTB_din,
    BRAM_PORTB_dout   => BRAM_PORTB_dout,
    BRAM_PORTB_en     => BRAM_PORTB_en,
    BRAM_PORTB_rst    => aReset,
    BRAM_PORTB_we     => BRAM_PORTB_we,
    Clk               => mb_clk,
    M1_MB_AXIS_tdata  => M1_MB_AXIS_tdata,
    M1_MB_AXIS_tlast  => M1_MB_AXIS_tlast,
    M1_MB_AXIS_tready => M1_MB_AXIS_tready,
    M1_MB_AXIS_tvalid => M1_MB_AXIS_tvalid,
    S1_MB_AXIS_tdata  => S1_MB_AXIS_tdata,
    S1_MB_AXIS_tlast  => S1_MB_AXIS_tlast,
    S1_MB_AXIS_tready => S1_MB_AXIS_tready,
    S1_MB_AXIS_tvalid => S1_MB_AXIS_tvalid,
    gpi0              => gpi0,
    gpi1              => gpi1,
    gpo0              => gpo0,
    gpo1              => gpo1,
    gtref_clk_out     => open,          -- gtref_clk_out,
    independent_clock => independent_clock,
    mac_irq           => mac_irq,
    mgt_clk_clk_n     => mgt_clk_clk_n,
    mgt_clk_clk_p     => mgt_clk_clk_p,
    mmcm_locked_out   => open,          -- mmcm_locked_out,
    pma_reset_out     => open,          -- pma_reset_out,
    reset_rtl         => reset_rtl,
    reset_rtl_0       => open,          -- reset_rtl_0,
    rx_mac_aclk       => rx_mac_aclk,
    rxuserclk2_out    => open,          --rxuserclk2_out,
    rxuserclk_out     => open,          --rxuserclk_out,
    sfp_rxn           => Port0_RX_n,
    sfp_rxp           => Port0_RX_p,
    sfp_txn           => Port0_TX_n,
    sfp_txp           => Port0_TX_p,
    signal_detect     => signal_detect_Port0_i,
    tx_mac_aclk       => tx_mac_aclk,
    userclk2_out      => open,          --userclk2_out,
    userclk_out       => open);         -- userclk_out);

  
  
end rtl;

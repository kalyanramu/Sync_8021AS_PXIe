--Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2016.1 (win64) Build 1538259 Fri Apr  8 15:45:27 MDT 2016
--Date        : Thu Jul 21 14:10:47 2016
--Host        : kalyan-NI running 64-bit Service Pack 1  (build 7601)
--Command     : generate_target block_diagram_wrapper.bd
--Design      : block_diagram_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity block_diagram_wrapper is
  port (
    BRAM_PORTB_addr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTB_clk : in STD_LOGIC;
    BRAM_PORTB_din : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTB_dout : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTB_en : in STD_LOGIC;
    BRAM_PORTB_rst : in STD_LOGIC;
    BRAM_PORTB_we : in STD_LOGIC_VECTOR ( 3 downto 0 );
    Clk : in STD_LOGIC;
    M1_MB_AXIS_tdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M1_MB_AXIS_tlast : out STD_LOGIC;
    M1_MB_AXIS_tready : in STD_LOGIC;
    M1_MB_AXIS_tvalid : out STD_LOGIC;
    S1_MB_AXIS_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S1_MB_AXIS_tlast : in STD_LOGIC;
    S1_MB_AXIS_tready : out STD_LOGIC;
    S1_MB_AXIS_tvalid : in STD_LOGIC;
    gpi0 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    gpi1 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    gpo0 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    gpo1 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    gtref_clk_out : out STD_LOGIC;
    independent_clock : in STD_LOGIC;
    mac_irq : out STD_LOGIC;
    mgt_clk_clk_n : in STD_LOGIC;
    mgt_clk_clk_p : in STD_LOGIC;
    mmcm_locked_out : out STD_LOGIC;
    pma_reset_out : out STD_LOGIC;
    reset_rtl : in STD_LOGIC;
    reset_rtl_0 : out STD_LOGIC;
    rx_mac_aclk : out STD_LOGIC;
    rxuserclk2_out : out STD_LOGIC;
    rxuserclk_out : out STD_LOGIC;
    sfp_rxn : in STD_LOGIC;
    sfp_rxp : in STD_LOGIC;
    sfp_txn : out STD_LOGIC;
    sfp_txp : out STD_LOGIC;
    signal_detect : in STD_LOGIC;
    tx_mac_aclk : out STD_LOGIC;
    userclk2_out : out STD_LOGIC;
    userclk_out : out STD_LOGIC
  );
end block_diagram_wrapper;

architecture STRUCTURE of block_diagram_wrapper is
  component block_diagram is
  port (
    S1_MB_AXIS_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S1_MB_AXIS_tlast : in STD_LOGIC;
    S1_MB_AXIS_tready : out STD_LOGIC;
    S1_MB_AXIS_tvalid : in STD_LOGIC;
    M1_MB_AXIS_tdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M1_MB_AXIS_tlast : out STD_LOGIC;
    M1_MB_AXIS_tready : in STD_LOGIC;
    M1_MB_AXIS_tvalid : out STD_LOGIC;
    reset_rtl_0 : out STD_LOGIC;
    reset_rtl : in STD_LOGIC;
    mac_irq : out STD_LOGIC;
    gtref_clk_out : out STD_LOGIC;
    pma_reset_out : out STD_LOGIC;
    rxuserclk2_out : out STD_LOGIC;
    rxuserclk_out : out STD_LOGIC;
    userclk_out : out STD_LOGIC;
    independent_clock : in STD_LOGIC;
    signal_detect : in STD_LOGIC;
    mmcm_locked_out : out STD_LOGIC;
    Clk : in STD_LOGIC;
    rx_mac_aclk : out STD_LOGIC;
    tx_mac_aclk : out STD_LOGIC;
    userclk2_out : out STD_LOGIC;
    sfp_rxn : in STD_LOGIC;
    sfp_rxp : in STD_LOGIC;
    sfp_txn : out STD_LOGIC;
    sfp_txp : out STD_LOGIC;
    mgt_clk_clk_n : in STD_LOGIC;
    mgt_clk_clk_p : in STD_LOGIC;
    gpi0 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    gpo0 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    gpi1 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    gpo1 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTB_addr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTB_clk : in STD_LOGIC;
    BRAM_PORTB_din : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTB_dout : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTB_en : in STD_LOGIC;
    BRAM_PORTB_rst : in STD_LOGIC;
    BRAM_PORTB_we : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
  end component block_diagram;
begin
block_diagram_i: component block_diagram
     port map (
      BRAM_PORTB_addr(31 downto 0) => BRAM_PORTB_addr(31 downto 0),
      BRAM_PORTB_clk => BRAM_PORTB_clk,
      BRAM_PORTB_din(31 downto 0) => BRAM_PORTB_din(31 downto 0),
      BRAM_PORTB_dout(31 downto 0) => BRAM_PORTB_dout(31 downto 0),
      BRAM_PORTB_en => BRAM_PORTB_en,
      BRAM_PORTB_rst => BRAM_PORTB_rst,
      BRAM_PORTB_we(3 downto 0) => BRAM_PORTB_we(3 downto 0),
      Clk => Clk,
      M1_MB_AXIS_tdata(31 downto 0) => M1_MB_AXIS_tdata(31 downto 0),
      M1_MB_AXIS_tlast => M1_MB_AXIS_tlast,
      M1_MB_AXIS_tready => M1_MB_AXIS_tready,
      M1_MB_AXIS_tvalid => M1_MB_AXIS_tvalid,
      S1_MB_AXIS_tdata(31 downto 0) => S1_MB_AXIS_tdata(31 downto 0),
      S1_MB_AXIS_tlast => S1_MB_AXIS_tlast,
      S1_MB_AXIS_tready => S1_MB_AXIS_tready,
      S1_MB_AXIS_tvalid => S1_MB_AXIS_tvalid,
      gpi0(31 downto 0) => gpi0(31 downto 0),
      gpi1(31 downto 0) => gpi1(31 downto 0),
      gpo0(31 downto 0) => gpo0(31 downto 0),
      gpo1(31 downto 0) => gpo1(31 downto 0),
      gtref_clk_out => gtref_clk_out,
      independent_clock => independent_clock,
      mac_irq => mac_irq,
      mgt_clk_clk_n => mgt_clk_clk_n,
      mgt_clk_clk_p => mgt_clk_clk_p,
      mmcm_locked_out => mmcm_locked_out,
      pma_reset_out => pma_reset_out,
      reset_rtl => reset_rtl,
      reset_rtl_0 => reset_rtl_0,
      rx_mac_aclk => rx_mac_aclk,
      rxuserclk2_out => rxuserclk2_out,
      rxuserclk_out => rxuserclk_out,
      sfp_rxn => sfp_rxn,
      sfp_rxp => sfp_rxp,
      sfp_txn => sfp_txn,
      sfp_txp => sfp_txp,
      signal_detect => signal_detect,
      tx_mac_aclk => tx_mac_aclk,
      userclk2_out => userclk2_out,
      userclk_out => userclk_out
    );
end STRUCTURE;

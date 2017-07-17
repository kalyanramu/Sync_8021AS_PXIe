set_false_path -to [get_pins -of_objects [get_cells {*OneGbEStatus*ms_reg}] -filter { NAME =~ */D}]

####################################################################################
# Constraints from file : 'block_diagram_eth_mac_0.xdc'
####################################################################################
set MY_MDC [get_pins {*block_diagram_i/ethernet_subsystem/ethernet_media/eth_mac/*/mdc}]
set MY_REG [get_cells *block_diagram_i/ethernet_subsystem/ethernet_media/eth_mac/*/block_diagram_eth_mac_0_core/*managen/mdio_enabled.miim_clk_int_reg]
set_multicycle_path -setup -from $MY_REG -through $MY_MDC 10
set_multicycle_path -hold  -from $MY_REG -through $MY_MDC 9

set_multicycle_path -setup -from [get_cells *block_diagram_i/ethernet_subsystem/ethernet_media/eth_mac/*/block_diagram_eth_mac_0_core/*managen/mdio_enabled.phy/enable_reg_reg] -through [get_pins {*block_diagram_i/ethernet_subsystem/ethernet_media/eth_mac/*/mdc}] 10
set_multicycle_path -hold -from [get_cells *block_diagram_i/ethernet_subsystem/ethernet_media/eth_mac/*/block_diagram_eth_mac_0_core/*managen/mdio_enabled.phy/enable_reg_reg] -through [get_pins {*block_diagram_i/ethernet_subsystem/ethernet_media/eth_mac/*/mdc}] 9
set_multicycle_path -setup -from [get_cells *block_diagram_i/ethernet_subsystem/ethernet_media/eth_mac/*/block_diagram_eth_mac_0_core/*managen/mdio_enabled.phy/mdio*reg] -through [get_pins {*block_diagram_i/ethernet_subsystem/ethernet_media/eth_mac/*/mdio_o}] 10
set_multicycle_path -hold -from [get_cells *block_diagram_i/ethernet_subsystem/ethernet_media/eth_mac/*/block_diagram_eth_mac_0_core/*managen/mdio_enabled.phy/mdio*reg] -through [get_pins {*block_diagram_i/ethernet_subsystem/ethernet_media/eth_mac/*/mdio_o}] 9
set_multicycle_path -setup -from [get_cells *block_diagram_i/ethernet_subsystem/ethernet_media/eth_mac/*/block_diagram_eth_mac_0_core/*managen/mdio_enabled.phy/mdio*reg] -through [get_pins {*block_diagram_i/ethernet_subsystem/ethernet_media/eth_mac/*/mdio_t}] 10
set_multicycle_path -hold -from [get_cells *block_diagram_i/ethernet_subsystem/ethernet_media/eth_mac/*/block_diagram_eth_mac_0_core/*managen/mdio_enabled.phy/mdio*reg] -through [get_pins {*block_diagram_i/ethernet_subsystem/ethernet_media/eth_mac/*/mdio_t}] 9




####################################################################################
# Constraints from file : 'block_diagram_eth_mac_0_clocks.xdc'
####################################################################################
set MY_GTX_CLK [get_clocks -of_objects [get_pins *block_diagram_i/ethernet_subsystem/ethernet_media/pcs_pma/userclk2*]]
#set MY_GTX_CLK [get_clocks -of_objects [get_pins *block_diagram_i/pcs_pma/userclk2*]]
set_max_delay -datapath_only -from [get_cells {*block_diagram_i/ethernet_subsystem/ethernet_media/eth_mac/*/axi4_lite_ipif/axi_lite_top/*/bus2ip_addr_i_reg[*]}] -to $MY_GTX_CLK 6.000
set_false_path -from [get_cells {*block_diagram_i/ethernet_subsystem/ethernet_media/eth_mac/*/block_diagram_eth_mac_0_core/*managen/conf/int_*reg[*]}] -to $MY_GTX_CLK
set_false_path -from [get_cells *block_diagram_i/ethernet_subsystem/ethernet_media/eth_mac/*/block_diagram_eth_mac_0_core/*managen/conf/int_*reg] -to $MY_GTX_CLK
set_false_path -from [get_cells {*block_diagram_i/ethernet_subsystem/ethernet_media/eth_mac/*/block_diagram_eth_mac_0_core/*/bus2ip_addr_int_reg[*]}] -to $MY_GTX_CLK

# TODO: Consider moving MB into the userclk2 clock domain, thus making MB synchronous
# to ethernet, and making this all a lot less painful
# Constraints added to ignore clock crossing MB to/from ethernet.  This is carpet-bombing,
# but the normal "use clock groups" advice would apply.  I'm pretty sure this is all safe
set MY_MB_CLK [get_clocks -of_objects [get_pins {*block_diagram_i/*/microblaze_0/Clk}]]
set_false_path -from $MY_MB_CLK -to   $MY_GTX_CLK
set_false_path -to   $MY_MB_CLK -from $MY_GTX_CLK


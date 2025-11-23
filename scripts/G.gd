extends Node

const UNIQUE_EXPANSION_CARDS := 6

enum CARD { USB_C, USB_A, HDMI, ETHERNET, DISPLAY_PORT, MICRO_SD, SD, STORAGE }
enum SLOT { TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT }

var card_names := {
	CARD.USB_C: "UsbCExpansionCard",
	CARD.USB_A: "UsbA_HDMI_DP",
	CARD.HDMI: "UsbA_HDMI_DP",
	CARD.ETHERNET: "EthernetExpansionCard",
	CARD.DISPLAY_PORT: "UsbA_HDMI_DP",
	CARD.MICRO_SD: "MicroSDExpansionCard",
	CARD.SD: "SDExpansionCard",
	CARD.STORAGE: "StorageExpansionCard",
}

var cns := {
	CARD.USB_C: "USB-C",
	CARD.USB_A: "USB-A",
	CARD.HDMI: "HDMI",
	CARD.ETHERNET: "Ethernet",
	CARD.DISPLAY_PORT: "DP",
	CARD.MICRO_SD: "Micro SD",
	CARD.SD: "SD",
	CARD.STORAGE: "Storage",
}

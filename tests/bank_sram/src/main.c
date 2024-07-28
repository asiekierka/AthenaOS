// SPDX-License-Identifier: CC0-1.0
//
// SPDX-FileContributor: Adrian "asie" Siekierka, 2024

#include <stdbool.h>
#include <stdint.h>
#include <wonderful.h>
#include <sys/bios.h>

const uint8_t write_data[] = { 0xAA, 0x55 };

static uint16_t print_word_at_sram0(uint16_t current_sram_bank, uint16_t y) {
	uint16_t word_at_sram0 = bank_read_word(current_sram_bank, 0);
	text_put_string(0, y, "Word at SRAM 0 = ");
	text_put_numeric(17, y, 4, NUM_HEXA | NUM_PADZERO, word_at_sram0);
	return word_at_sram0;
}

void main(void) {
	text_screen_init();

	uint8_t byte_at_ffff0 = bank_read_byte(0xFFFF, 0xFFF0);
	text_put_string(0, 0, "Byte @ FFFF0 = ");
	text_put_numeric(15, 0, 2, NUM_HEXA | NUM_PADZERO, byte_at_ffff0);

	uint16_t current_sram_bank = bank_get_map(0) & 0x7FFF;
	text_put_string(0, 1, "Current SRAM bank = ");
	text_put_numeric(20, 1, 4, NUM_HEXA | NUM_PADZERO, current_sram_bank);

	uint16_t word_at_sram0 = print_word_at_sram0(current_sram_bank, 2);

	text_put_string(0, 3, "Writing word ^ 0xFFFF");
	bank_write_word(current_sram_bank, 0, word_at_sram0 ^ 0xFFFF);
	print_word_at_sram0(current_sram_bank, 4);

	text_put_string(0, 5, "Writing byte");
	bank_write_byte(current_sram_bank, 0, 0);
	print_word_at_sram0(current_sram_bank, 6);

	text_put_string(0, 7, "Writing block");
	bank_write_block(current_sram_bank, 0, write_data, sizeof(write_data));
	print_word_at_sram0(current_sram_bank, 8);

	text_put_string(0, 9, "Filling block");
	bank_fill_block(current_sram_bank, 0, 2, 0x11);
	print_word_at_sram0(current_sram_bank, 10);

	key_wait();
}

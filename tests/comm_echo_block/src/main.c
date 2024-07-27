// SPDX-License-Identifier: CC0-1.0
//
// SPDX-FileContributor: Adrian "asie" Siekierka, 2024

#include <stdbool.h>
#include <stdint.h>
#include <wonderful.h>
#include <sys/bios.h>

#define RECV_TIMEOUT_SECONDS 10
#define SEND_TIMEOUT_SECONDS 2
#define BUFFER_SIZE 16

uint8_t buffer[BUFFER_SIZE];
uint16_t bytes_received;

void main(void) {
	comm_set_timeout(75 * RECV_TIMEOUT_SECONDS, 75 * SEND_TIMEOUT_SECONDS);
	comm_set_cancel_key(KEY_B);

	comm_open();

	text_screen_init();
	text_put_string(1, 1, "UART echo, B to cancel");
	while (true) {
		uint16_t c = comm_receive_block(buffer, BUFFER_SIZE, &bytes_received);
		if (c & 0x8000) {
			text_put_string(1, 5, "Recv error 0x");
			text_put_numeric(14, 5, 4, NUM_HEXA | NUM_PADZERO, c);
			break;
		}

		text_put_substring(1, 3, buffer, BUFFER_SIZE);

		c = comm_send_block(buffer, BUFFER_SIZE);
		if (c & 0x8000) {
			text_put_string(1, 5, "Send error 0x");
			text_put_numeric(14, 5, 4, NUM_HEXA | NUM_PADZERO, c);
			break;
		}
	}

	comm_close();

	text_put_string(1, 6, "Press any key to exit...");
	while (key_press_check());
	key_wait();
	while (key_press_check());
}

// SPDX-License-Identifier: CC0-1.0
//
// SPDX-FileContributor: Adrian "asie" Siekierka, 2024

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <wonderful.h>
#include <sys/bios.h>

int do_alloc_test(int i, int alloc_size) {
	void __wf_iram *data = sys_alloc_iram(NULL, alloc_size);
	text_put_string(0, i, "Allocated IRAM @ ");
	text_put_numeric(17, i++, 4, NUM_HEXA | NUM_PADZERO, (uint16_t) data);

	void __wf_iram *my_data = sys_get_my_iram();
	text_put_string(0, i, "Got my IRAM @");
	text_put_numeric(14, i++, 4, NUM_HEXA | NUM_PADZERO, (uint16_t) my_data);

	sys_free_iram(data);
	text_put_string(0, i++, "Freed my IRAM");

	my_data = sys_get_my_iram();
	text_put_string(0, i, "Got my IRAM @");
	text_put_numeric(14, i++, 4, NUM_HEXA | NUM_PADZERO, (uint16_t) my_data);

	text_put_string(0, i, "Press any key...");
	while (key_hit_check());
	while (!key_hit_check());
	while (key_hit_check());

	return i;
}

void main(void) {
	int i = 0;
	text_screen_init();

	i = do_alloc_test(i, 128);
	i = do_alloc_test(i, 256);
	i = do_alloc_test(i, 64);
}

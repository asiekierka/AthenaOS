// SPDX-License-Identifier: CC0-1.0
//
// SPDX-FileContributor: Adrian "asie" Siekierka, 2024

#include <wonderful.h>
#include <sys/bios.h>

uint8_t i = 0;
ownerinfo_t owner_info;

const char *sex_string[] = {"?", "Male", "Female"};
const char *bloodtype_string[] = {"?", "A", "B", "AB", "0"};

void main(void) {
	sys_get_ownerinfo(sizeof(owner_info), &owner_info);

	text_screen_init();
	text_put_string(2, 1, "Owner information:");

	text_put_string(2, 3, "Name:");
        text_put_substring(8, 3, owner_info.name, 16);

	text_put_string(2, 4, "Birthday: ....-..-..");
	text_put_numeric(12, 4, 4, NUM_PADZERO, owner_info.birth_year);
	text_put_numeric(17, 4, 2, NUM_PADZERO, owner_info.birth_month);
	text_put_numeric(20, 4, 2, NUM_PADZERO, owner_info.birth_day);

	text_put_string(2, 5, "Gender:");
	text_put_string(10, 5, sex_string[owner_info.sex > 2 ? 0 : owner_info.sex]);

	text_put_string(2, 6, "Blood type:");
	text_put_string(14, 6, bloodtype_string[owner_info.bloodtype > 4 ? 0 : owner_info.bloodtype]);

	while(key_wait() != KEY_B);
}

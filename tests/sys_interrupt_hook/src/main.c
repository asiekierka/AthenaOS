// SPDX-License-Identifier: CC0-1.0
//
// SPDX-FileContributor: Adrian "asie" Siekierka, 2024

#include <wonderful.h>
#include <sys/bios.h>

uint8_t i = 0;

void hblank_timer_callback(void) __far {
	screen_set_scroll(1, i++, 0);
}

void main(void) {
	static intvector_t hook_old, hook_new;

	text_screen_init();
	text_put_string(2, 1, "sys_interrupt_hook test");

	hook_new.callback = FP_OFF(hblank_timer_callback);
	hook_new.cs = FP_SEG(hblank_timer_callback);
	hook_new.ds = _DS;

	sys_interrupt_set_hook(SYS_INT_TIMER_COUNTUP, &hook_new, &hook_old);
	timer_enable(TIMER_VBLANK, TIMER_AUTOPRESET, 2);

	while(key_wait() != KEY_B);

	sys_interrupt_reset_hook(SYS_INT_TIMER_COUNTUP, &hook_old);
}

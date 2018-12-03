all:
	true

install:
	mkdir -p $(DESTDIR)/usr/bin
	install --owner=0 --group=0 --mode=744 --preserve-timestamps scripts/exam-ufw-disable scripts/exam-ufw-enable $(DESTDIR)/usr/bin/
	mkdir -p $(DESTDIR)/lib/systemd/system
	install --owner=0 --group=0 --mode=644 --preserve-timestamps systemd/bacchus-exam-mode-enable.timer systemd/bacchus-exam-mode-disable.timer systemd/bacchus-exam-mode.service systemd/bacchus-normal-mode.service $(DESTDIR)/lib/systemd/system/
	mkdir -p $(DESTDIR)/lib/systemd/system-preset
	install --owner=0 --group=0 --mode=644 --preserve-timestamps system-preset/50-bacchus-exam-env.preset $(DESTDIR)/lib/systemd/system-preset/

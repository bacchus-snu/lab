all:
	true
install:
	mkdir -p $(DESTDIR)/usr/share
	mkdir -p $(DESTDIR)/etc/udev/rules.d
	mkdir -p $(DESTDIR)/lib/x86_64-linux-gnu
	cp /opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64/*.hex $(DESTDIR)/usr/share/
	cp /opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64/xusbdfwu.rules $(DESTDIR)/etc/udev/rules.d/
	cp -P libusb.so $(DESTDIR)/lib/x86_64-linux-gnu
	sed -i -e 's/TEMPNODE/tempnode/' -e 's/SYSFS/ATTRS/g' -e 's/BUS/SUBSYSTEMS/' $(DESTDIR)/etc/udev/rules.d/xusbdfwu.rules

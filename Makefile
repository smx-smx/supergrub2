OWNER=root
GROUP=root

GRUB_MKRESCUE="/usr/bin/grub-mkrescue"
PKGLIBDIR="/usr/lib/grub/i386-pc"
GRUB_MKIMAGE="/usr/bin/grub-mkimage"
OVERLAY_DIR=menus
GRUB_RESCUE_FLOPPY=sgd_floppy.img
GRUB_RESCUE_CDROM=sgd_cdrom.iso
IMAGESDIR=$(DESTDIR)/usr/lib/supergrub
INSTALL="/usr/bin/install"
TEMPORAL_OVERLAY_DIR=temporal_overlay
TEMPORAL_OVERLAY_FILES=$(TEMPORAL_OVERLAY_DIR)/boot/grub/grub.cfg
OVERLAY_FILES=$(OVERLAY_DIR)/grub.cfg
CLEANFILES += $(GRUB_RESCUE_FLOPPY) $(GRUB_RESCUE_CDROM)
DOCSDIR=$(DESTDIR)/usr/share/doc/supergrub

all: supergrub_floppy supergrub_cdrom
.PHONY:	all supergrub_floppy supergrub_cdrom install uninstall clean mostlyclean distclean
$(TEMPORAL_OVERLAY_FILES):	$(OVERLAY_FILES)
	test -d $(TEMPORAL_OVERLAY_DIR) || mkdir $(TEMPORAL_OVERLAY_DIR)
	mkdir -p $(TEMPORAL_OVERLAY_DIR)/boot/grub
	cp -r $(OVERLAY_DIR)/* $(TEMPORAL_OVERLAY_DIR)/boot/grub

supergrub_floppy: $(GRUB_RESCUE_FLOPPY)

$(GRUB_RESCUE_FLOPPY):	$(TEMPORAL_OVERLAY_FILES)
# It should depend on the files found at: $(PKGLIBDIR)/* $(GRUB_MKIMAGE) $(OVERLAY)/*
	$(GRUB_MKRESCUE) \
	--pkglibdir=$(PKGLIBDIR) \
	--grub-mkimage=$(GRUB_MKIMAGE) \
	 --overlay=$(TEMPORAL_OVERLAY_DIR) \
	 --image-type=floppy \
	$(GRUB_RESCUE_FLOPPY)

supergrub_cdrom : $(GRUB_RESCUE_CDROM)

$(GRUB_RESCUE_CDROM) : $(TEMPORAL_OVERLAY_FILES)
	$(GRUB_MKRESCUE) \
	--pkglibdir=$(PKGLIBDIR) \
	--grub-mkimage=$(GRUB_MKIMAGE) \
	--overlay=$(TEMPORAL_OVERLAY_DIR) \
	--image-type=cdrom \
	$(GRUB_RESCUE_CDROM)

install : all

	test -d "$(IMAGESDIR)" || mkdir -p "$(IMAGESDIR)"
	$(INSTALL) -c -o $(OWNER) -g $(GROUP) -m 644 $(GRUB_RESCUE_FLOPPY) $(IMAGESDIR)
	$(INSTALL) -c -o $(OWNER) -g $(GROUP) -m 644 $(GRUB_RESCUE_CDROM) $(IMAGESDIR)
	test -d "$(DOCSDIR)" || mkdir -p "$(DOCSDIR)"
	$(INSTALL) -c -o $(OWNER) -g $(GROUP) -m 644 AUTHORS $(DOCSDIR)
	$(INSTALL) -c -o $(OWNER) -g $(GROUP) -m 644 COPYING $(DOCSDIR)
	$(INSTALL) -c -o $(OWNER) -g $(GROUP) -m 644 INSTALL $(DOCSDIR)
	$(INSTALL) -c -o $(OWNER) -g $(GROUP) -m 644 NEWS $(DOCSDIR)
	$(INSTALL) -c -o $(OWNER) -g $(GROUP) -m 644 README $(DOCSDIR)
	$(INSTALL) -c -o $(OWNER) -g $(GROUP) -m 644 THANKS $(DOCSDIR)
	$(INSTALL) -c -o $(OWNER) -g $(GROUP) -m 644 TODO $(DOCSDIR)
	gzip -9 $(DOCSDIR)/NEWS

uninstall :
	-rm -f $(IMAGESDIR)/$(GRUB_RESCUE_FLOPPY)
	-rm -f $(IMAGESDIR)/$(GRUB_RESCUE_CDROM)
	-rmdir $(IMAGESDIR)	

	-rm -f $(DOCSDIR)/AUTHORS
	-rm -f $(DOCSDIR)/COPYING
	-rm -f $(DOCSDIR)/INSTALL
	-rm -f $(DOCSDIR)/NEWS.gz
	-rm -f $(DOCSDIR)/README
	-rm -f $(DOCSDIR)/THANKS
	-rm -f $(DOCSDIR)/TODO
	-rmdir $(DOCSDIR)/	

clean :

	-rm -f $(CLEANFILES)
	-rm -rf $(TEMPORAL_OVERLAY_DIR)

distclean : clean

mostlyclean : clean


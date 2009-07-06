# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{media_rocket}
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alexandre Girard"]
  s.date = %q{2009-06-15}
  s.description = %q{Merb Slice that provides a media server to upload and retrieve all kind of files}
  s.email = %q{alx.girard@gmail.com}
  s.extra_rdoc_files = ["README.textile", "LICENSE", "TODO"]
  s.files = ["LICENSE", "README.textile", "Rakefile", "TODO", "lib/media_rocket", "lib/media_rocket/helpers", "lib/media_rocket/helpers/assets.rb", "lib/media_rocket/helpers/content.rb", "lib/media_rocket/helpers/form.rb", "lib/media_rocket/helpers.rb", "lib/media_rocket/router.rb", "lib/media_rocket/tasks", "lib/media_rocket/tasks/merbtasks.rb", "lib/media_rocket/tasks/slicetasks.rb", "lib/media_rocket.rb", "spec/controllers", "spec/controllers/main_spec.rb", "spec/models", "spec/models/associatedfile_spec.rb", "spec/models/category_spec.rb", "spec/models/media_file_spec.rb", "spec/requests", "spec/requests/category_spec.rb", "spec/requests/media_spec.rb", "spec/requests/queue_spec.rb", "spec/resources", "spec/resources/image.png", "spec/slice.rb", "spec/spec_helper.rb", "app/controllers", "app/controllers/application.rb", "app/controllers/gallery.rb", "app/controllers/main.rb", "app/controllers/media.rb", "app/controllers/permission.rb", "app/helpers", "app/helpers/application_helper.rb", "app/models", "app/models/associated_file.rb", "app/models/gallery.rb", "app/models/gallery_permission.rb", "app/models/media_file.rb", "app/models/site.rb", "app/models/tag.rb", "app/models/widget.rb", "app/views", "app/views/galleries", "app/views/galleries/edit.html.erb", "app/views/galleries/gallery.html.erb", "app/views/galleries/gallery.xml.builder", "app/views/galleries/index.xml.builder", "app/views/layout", "app/views/layout/media_rocket.html.erb", "app/views/main", "app/views/main/admin.html.erb", "app/views/main/index.html.erb", "app/views/medias", "app/views/medias/edit.html.erb", "app/views/permissions", "app/views/permissions/index.html.erb", "app/views/queue", "public/flash", "public/flash/uploader.swf", "public/images", "public/images/cancel.png", "public/images/gallery_icon.png", "public/images/header.png", "public/images/header.psd", "public/images/icons", "public/images/icons/accept.png", "public/images/icons/add.png", "public/images/icons/arrow_refresh.png", "public/images/icons/bg-table-thead.png", "public/images/icons/delete.png", "public/images/icons/folder.png", "public/images/icons/folder_edit.png", "public/images/icons/image_edit.png", "public/images/icons/lock.png", "public/images/icons/mimetypes", "public/images/icons/mimetypes/applix.png", "public/images/icons/mimetypes/ascii.png", "public/images/icons/mimetypes/binary.png", "public/images/icons/mimetypes/cdbo_list.png", "public/images/icons/mimetypes/cdimage.png", "public/images/icons/mimetypes/cdtrack.png", "public/images/icons/mimetypes/colorscm.png", "public/images/icons/mimetypes/colorset.png", "public/images/icons/mimetypes/core.png", "public/images/icons/mimetypes/deb.png", "public/images/icons/mimetypes/doc.png", "public/images/icons/mimetypes/document.png", "public/images/icons/mimetypes/document2.png", "public/images/icons/mimetypes/dvi.png", "public/images/icons/mimetypes/empty.png", "public/images/icons/mimetypes/empty_ascii.png", "public/images/icons/mimetypes/encrypted.png", "public/images/icons/mimetypes/exec_wine.png", "public/images/icons/mimetypes/file_broken.png", "public/images/icons/mimetypes/file_locked.png", "public/images/icons/mimetypes/file_temporary.png", "public/images/icons/mimetypes/font.png", "public/images/icons/mimetypes/font_bitmap.png", "public/images/icons/mimetypes/font_truetype.png", "public/images/icons/mimetypes/font_type1 co\314\201pia.png", "public/images/icons/mimetypes/font_type1.png", "public/images/icons/mimetypes/fonts_bitmap.png", "public/images/icons/mimetypes/gettext.png", "public/images/icons/mimetypes/gf.png", "public/images/icons/mimetypes/gif.png", "public/images/icons/mimetypes/html.png", "public/images/icons/mimetypes/image.png", "public/images/icons/mimetypes/images.png", "public/images/icons/mimetypes/info.png", "public/images/icons/mimetypes/java_src.png", "public/images/icons/mimetypes/jpeg.png", "public/images/icons/mimetypes/jpg.png", "public/images/icons/mimetypes/karbon.png", "public/images/icons/mimetypes/karbon_karbon.png", "public/images/icons/mimetypes/kchart_chrt.png", "public/images/icons/mimetypes/kexi_kexi.png", "public/images/icons/mimetypes/kformula_kfo.png", "public/images/icons/mimetypes/kivio_flw.png", "public/images/icons/mimetypes/kmultiple.png", "public/images/icons/mimetypes/koffice.png", "public/images/icons/mimetypes/kpresenter_kpr.png", "public/images/icons/mimetypes/krita_kra.png", "public/images/icons/mimetypes/kspread_ksp.png", "public/images/icons/mimetypes/kugar_kud.png", "public/images/icons/mimetypes/kugardata.png", "public/images/icons/mimetypes/kword_kwd.png", "public/images/icons/mimetypes/log.png", "public/images/icons/mimetypes/make.png", "public/images/icons/mimetypes/man.png", "public/images/icons/mimetypes/message.png", "public/images/icons/mimetypes/metafont.png", "public/images/icons/mimetypes/midi.png", "public/images/icons/mimetypes/mime.png", "public/images/icons/mimetypes/mime_ascii.png", "public/images/icons/mimetypes/mime_cdr.png", "public/images/icons/mimetypes/mime_colorset.png", "public/images/icons/mimetypes/mime_empty.png", "public/images/icons/mimetypes/mime_koffice.png", "public/images/icons/mimetypes/mime_postscript.png", "public/images/icons/mimetypes/mime_resource.png", "public/images/icons/mimetypes/misc.png", "public/images/icons/mimetypes/misc_doc.png", "public/images/icons/mimetypes/moc_src.png", "public/images/icons/mimetypes/mozilla_doc.png", "public/images/icons/mimetypes/mp3.png", "public/images/icons/mimetypes/netscape.png", "public/images/icons/mimetypes/netscape_doc.png", "public/images/icons/mimetypes/news.png", "public/images/icons/mimetypes/pdf.png", "public/images/icons/mimetypes/pdf_document.png", "public/images/icons/mimetypes/php.png", "public/images/icons/mimetypes/pk.png", "public/images/icons/mimetypes/png.png", "public/images/icons/mimetypes/postscript.png", "public/images/icons/mimetypes/pps.png", "public/images/icons/mimetypes/ps.png", "public/images/icons/mimetypes/quicktime.png", "public/images/icons/mimetypes/readme.png", "public/images/icons/mimetypes/real.png", "public/images/icons/mimetypes/real_doc.png", "public/images/icons/mimetypes/recycled.png", "public/images/icons/mimetypes/resource.png", "public/images/icons/mimetypes/rpm.png", "public/images/icons/mimetypes/schedule.png", "public/images/icons/mimetypes/shell1.png", "public/images/icons/mimetypes/shellscript.png", "public/images/icons/mimetypes/soffice.png", "public/images/icons/mimetypes/sound.png", "public/images/icons/mimetypes/source.png", "public/images/icons/mimetypes/source_c.png", "public/images/icons/mimetypes/source_cpp.png", "public/images/icons/mimetypes/source_f.png", "public/images/icons/mimetypes/source_h.png", "public/images/icons/mimetypes/source_j.png", "public/images/icons/mimetypes/source_java.png", "public/images/icons/mimetypes/source_l.png", "public/images/icons/mimetypes/source_moc.png", "public/images/icons/mimetypes/source_o.png", "public/images/icons/mimetypes/source_p.png", "public/images/icons/mimetypes/source_php.png", "public/images/icons/mimetypes/source_pl.png", "public/images/icons/mimetypes/source_py.png", "public/images/icons/mimetypes/source_s.png", "public/images/icons/mimetypes/source_y.png", "public/images/icons/mimetypes/sownd.png", "public/images/icons/mimetypes/spreadsheet.png", "public/images/icons/mimetypes/spreadsheet_document.png", "public/images/icons/mimetypes/swf.png", "public/images/icons/mimetypes/tar.png", "public/images/icons/mimetypes/template_source.png", "public/images/icons/mimetypes/templates.png", "public/images/icons/mimetypes/tex.png", "public/images/icons/mimetypes/tgz.png", "public/images/icons/mimetypes/trash.png", "public/images/icons/mimetypes/txt.png", "public/images/icons/mimetypes/txt2.png", "public/images/icons/mimetypes/unknown.png", "public/images/icons/mimetypes/vcalendar.png", "public/images/icons/mimetypes/vcard.png", "public/images/icons/mimetypes/vectorgfx.png", "public/images/icons/mimetypes/video.png", "public/images/icons/mimetypes/widget_doc.png", "public/images/icons/mimetypes/wordprocessing.png", "public/images/icons/mimetypes/xcf.png", "public/images/icons/mimetypes/zip.png", "public/images/icons/page_white_text.png", "public/images/icons/stop.png", "public/images/icons/text_linespacing.png", "public/images/icons/toggle-collapse-dark.png", "public/images/icons/toggle-collapse-light.png", "public/images/icons/toggle-expand-dark.png", "public/images/icons/toggle-expand-light.png", "public/images/icons/updown.gif", "public/images/icons/zoom.png", "public/images/macFFBgHack.png", "public/images/media_icon.png", "public/images/rocket.png", "public/images/rocket_small.png", "public/javascripts", "public/javascripts/jquery", "public/javascripts/jquery/jquery.alerts.js", "public/javascripts/jquery/jquery.base64.js", "public/javascripts/jquery/jquery.confirm.js", "public/javascripts/jquery/jquery.form.js", "public/javascripts/jquery/jquery.js", "public/javascripts/jquery/jquery.livequery.js", "public/javascripts/jquery/jquery.treetable.js", "public/javascripts/jquery/jquery.ui.js", "public/javascripts/jquery/jquery.uploadify.js", "public/javascripts/jquery/jquery.validate.js", "public/javascripts/jquery/thickbox.js", "public/javascripts/jquery-full", "public/javascripts/jquery-full/jquery.confirm.js", "public/javascripts/jquery-full/jquery.form.js", "public/javascripts/jquery-full/jquery.js", "public/javascripts/jquery-full/jquery.treetable.js", "public/javascripts/jquery-full/jquery.ui.js", "public/javascripts/jquery-full/jquery.uploadify.js", "public/javascripts/jquery-full/thickbox.js", "public/javascripts/jquery-pack", "public/javascripts/jquery-pack/jquery.confirm.js", "public/javascripts/jquery-pack/jquery.form.js", "public/javascripts/jquery-pack/jquery.js", "public/javascripts/jquery-pack/jquery.treetable.js", "public/javascripts/jquery-pack/jquery.ui.js", "public/javascripts/jquery-pack/jquery.validate.js", "public/javascripts/jquery-pack/thickbox.js", "public/javascripts/json2.js", "public/javascripts/master.js", "public/javascripts/permissions.js", "public/stylesheets", "public/stylesheets/forms.css", "public/stylesheets/ie.css", "public/stylesheets/images", "public/stylesheets/images/help.gif", "public/stylesheets/images/important.gif", "public/stylesheets/images/info.gif", "public/stylesheets/images/loadingAnimation.gif", "public/stylesheets/images/title.gif", "public/stylesheets/images/ui-bg_flat_0_aaaaaa_40x100.png", "public/stylesheets/images/ui-bg_flat_75_ffffff_40x100.png", "public/stylesheets/images/ui-bg_glass_55_fbf9ee_1x400.png", "public/stylesheets/images/ui-bg_glass_65_ffffff_1x400.png", "public/stylesheets/images/ui-bg_glass_75_dadada_1x400.png", "public/stylesheets/images/ui-bg_glass_75_e6e6e6_1x400.png", "public/stylesheets/images/ui-bg_glass_95_fef1ec_1x400.png", "public/stylesheets/images/ui-bg_highlight-soft_75_cccccc_1x100.png", "public/stylesheets/images/ui-icons_222222_256x240.png", "public/stylesheets/images/ui-icons_2e83ff_256x240.png", "public/stylesheets/images/ui-icons_454545_256x240.png", "public/stylesheets/images/ui-icons_888888_256x240.png", "public/stylesheets/images/ui-icons_cd0a0a_256x240.png", "public/stylesheets/jquery-ui-1.7.1.custom.css", "public/stylesheets/jquery.alerts.css", "public/stylesheets/jquery.treetable.css", "public/stylesheets/master.css", "public/stylesheets/plugins", "public/stylesheets/plugins/buttons", "public/stylesheets/plugins/buttons/icons", "public/stylesheets/plugins/buttons/icons/cross.png", "public/stylesheets/plugins/buttons/icons/key.png", "public/stylesheets/plugins/buttons/icons/tick.png", "public/stylesheets/plugins/buttons/readme.txt", "public/stylesheets/plugins/buttons/screen.css", "public/stylesheets/plugins/fancy-type", "public/stylesheets/plugins/fancy-type/readme.txt", "public/stylesheets/plugins/fancy-type/screen.css", "public/stylesheets/plugins/link-icons", "public/stylesheets/plugins/link-icons/icons", "public/stylesheets/plugins/link-icons/icons/doc.png", "public/stylesheets/plugins/link-icons/icons/email.png", "public/stylesheets/plugins/link-icons/icons/external.png", "public/stylesheets/plugins/link-icons/icons/feed.png", "public/stylesheets/plugins/link-icons/icons/im.png", "public/stylesheets/plugins/link-icons/icons/pdf.png", "public/stylesheets/plugins/link-icons/icons/visited.png", "public/stylesheets/plugins/link-icons/icons/xls.png", "public/stylesheets/plugins/link-icons/readme.txt", "public/stylesheets/plugins/link-icons/screen.css", "public/stylesheets/plugins/rtl", "public/stylesheets/plugins/rtl/readme.txt", "public/stylesheets/plugins/rtl/screen.css", "public/stylesheets/print.css", "public/stylesheets/screen.css", "public/stylesheets/thickbox.css", "public/stylesheets/uploadify.css", "public/uploads", "public/uploads/2009", "public/uploads/2009/01", "public/uploads/2009/01/27", "public/uploads/2009/01/27/0d048331b0a3457210aeaad6c3f37144.jpg", "public/uploads/2009/01/27/18467aa23204bf413a5da518cba5429b.jpg", "public/uploads/2009/01/27/259a90b584a62a01ab54b7d7648e3aa4.jpg", "public/uploads/2009/01/27/7c4cae617c93aedd5e4713c7f39b50a2.jpg", "public/uploads/2009/01/27/8b52a37ff25f2a1b633bc3bffc79d308.jpg", "public/uploads/2009/01/27/b67362f222740f7b7e627c3cae155e6d.jpg", "public/uploads/2009/01/27/e5ac84839d419633a2a45ab119beb8ce.jpg", "public/uploads/2009/01/27/e78590f2185d15b96b35acc646b3c025.jpg", "public/uploads/2009/01/27/f4e1c065805028728218cab74b6d9cda.jpg", "public/uploads/2009/02", "public/uploads/2009/02/17", "public/uploads/2009/02/17/23d06962c46f35251ea29a93e5d11efa.swf", "public/uploads/2009/02/17/3935c1be31b17ec33517c0d2bb941f1e.png", "public/uploads/2009/02/17/a3268ee7a7e71f30019142c7d79193dd.png", "public/uploads/2009/02/17/d2b5ca33bd970f64a6301fa75ae2eb22.png", "public/uploads/2009/02/17/d4dbb1eee79a803ec3bcf9652f9ac4ea.PNG", "public/uploads/2009/02/27", "public/uploads/2009/02/27/0d048331b0a3457210aeaad6c3f37144.jpg", "public/uploads/2009/02/27/259a90b584a62a01ab54b7d7648e3aa4.jpg", "public/uploads/2009/02/27/7c4cae617c93aedd5e4713c7f39b50a2.jpg", "public/uploads/2009/02/27/8b52a37ff25f2a1b633bc3bffc79d308.jpg", "public/uploads/2009/02/27/b67362f222740f7b7e627c3cae155e6d.jpg", "public/uploads/2009/02/27/e78590f2185d15b96b35acc646b3c025.jpg", "public/uploads/2009/03", "public/uploads/2009/03/19", "public/uploads/2009/03/19/168d90531c1ed73a8c98126aa31fd8ad.jpg", "public/uploads/2009/03/19/a13c8eb436e4152c63054f620a670549.jpg", "public/uploads/2009/03/19/ac8ded3fd6eb0648d8e2f6bb58d88a6e.jpg", "public/uploads/2009/04", "public/uploads/2009/04/18", "public/uploads/2009/04/18/168d90531c1ed73a8c98126aa31fd8ad.jpg", "public/uploads/2009/04/18/a13c8eb436e4152c63054f620a670549.jpg", "public/uploads/2009/04/18/ac8ded3fd6eb0648d8e2f6bb58d88a6e.jpg", "public/uploads/2009/04/22", "public/uploads/2009/04/22/21fb3491c2484cfa45edf7e78d7b51bf.JPG", "public/uploads/2009/04/22/33281295ff44d37a8bf9c46f31a604f0.JPG", "public/uploads/2009/04/22/6186fa2b6c97f41c05b5238573ccedd2.JPG", "public/uploads/2009/04/23", "public/uploads/2009/04/23/3935c1be31b17ec33517c0d2bb941f1e.png", "public/uploads/2009/04/23/a3268ee7a7e71f30019142c7d79193dd.png", "public/uploads/2009/04/23/d2b5ca33bd970f64a6301fa75ae2eb22.png", "public/uploads/2009/05", "public/uploads/2009/05/18", "public/uploads/2009/05/18/168d90531c1ed73a8c98126aa31fd8ad.jpg", "public/uploads/2009/05/18/a13c8eb436e4152c63054f620a670549.jpg", "public/uploads/2009/05/18/ac8ded3fd6eb0648d8e2f6bb58d88a6e.jpg", "public/uploads/2009/05/22", "public/uploads/2009/05/22/0d7d330d319d8da3f4944fd77750a1a7.jpg", "public/uploads/2009/05/22/64b8299d1597b8a5c7b9cb9c88642f6c.jpg", "public/uploads/2009/05/22/f1bee81adb556c0a0d3ef482749b3ae7.jpg", "public/uploads/2009/05/27", "public/uploads/2009/05/27/03f1e0e2abe5f50b89422540e1ffe462.jpg", "public/uploads/2009/05/27/07eac70741e7532f1ba2e31ba4eb4c89.jpg", "public/uploads/2009/05/27/0d048331b0a3457210aeaad6c3f37144.jpg", "public/uploads/2009/05/27/14ce3fdd400acc399934396b399db183.jpg", "public/uploads/2009/05/27/18467aa23204bf413a5da518cba5429b.jpg", "public/uploads/2009/05/27/3653c29a066a80d84b863aca03ba30bb.jpg", "public/uploads/2009/05/27/7c4cae617c93aedd5e4713c7f39b50a2.jpg", "public/uploads/2009/05/27/8b52a37ff25f2a1b633bc3bffc79d308.jpg", "public/uploads/2009/05/27/baa37cb16f06a069e49cb10288fc981b.jpg", "public/uploads/2009/05/27/beac1653dc5629d339ec27df06d81d8e.jpg", "public/uploads/2009/05/27/e5ac84839d419633a2a45ab119beb8ce.jpg", "public/uploads/2009/05/27/f4e1c065805028728218cab74b6d9cda.jpg", "public/uploads/2009/06", "public/uploads/2009/06/18", "public/uploads/2009/06/18/168d90531c1ed73a8c98126aa31fd8ad.jpg", "public/uploads/2009/06/18/a13c8eb436e4152c63054f620a670549.jpg", "public/uploads/2009/06/18/ac8ded3fd6eb0648d8e2f6bb58d88a6e.jpg", "public/uploads/2009/06/22", "public/uploads/2009/06/22/0d7d330d319d8da3f4944fd77750a1a7.jpg", "public/uploads/2009/06/22/64b8299d1597b8a5c7b9cb9c88642f6c.jpg", "public/uploads/2009/06/22/f1bee81adb556c0a0d3ef482749b3ae7.jpg", "public/uploads/2009/06/27", "public/uploads/2009/06/27/07eac70741e7532f1ba2e31ba4eb4c89.jpg", "public/uploads/2009/06/27/0d048331b0a3457210aeaad6c3f37144.jpg", "public/uploads/2009/06/27/18467aa23204bf413a5da518cba5429b.jpg", "public/uploads/2009/06/27/3653c29a066a80d84b863aca03ba30bb.jpg", "public/uploads/2009/06/27/7c4cae617c93aedd5e4713c7f39b50a2.jpg", "public/uploads/2009/06/27/8b52a37ff25f2a1b633bc3bffc79d308.jpg", "public/uploads/2009/06/27/baa37cb16f06a069e49cb10288fc981b.jpg", "public/uploads/2009/06/27/e5ac84839d419633a2a45ab119beb8ce.jpg", "public/uploads/2009/06/27/f4e1c065805028728218cab74b6d9cda.jpg", "public/uploads/2009/09", "public/uploads/2009/09/22", "public/uploads/2009/09/22/0d7d330d319d8da3f4944fd77750a1a7.jpg", "public/uploads/2009/09/22/64b8299d1597b8a5c7b9cb9c88642f6c.jpg", "public/uploads/2009/09/22/f1bee81adb556c0a0d3ef482749b3ae7.jpg", "public/uploads/2009/10", "public/uploads/2009/10/22", "public/uploads/2009/10/22/0d7d330d319d8da3f4944fd77750a1a7.jpg", "public/uploads/2009/10/22/64b8299d1597b8a5c7b9cb9c88642f6c.jpg", "public/uploads/2009/10/22/f1bee81adb556c0a0d3ef482749b3ae7.jpg", "public/uploads/2009/10/23", "public/uploads/2009/10/23/0d7d330d319d8da3f4944fd77750a1a7.jpg", "public/uploads/2009/10/23/64b8299d1597b8a5c7b9cb9c88642f6c.jpg", "public/uploads/2009/10/23/f1bee81adb556c0a0d3ef482749b3ae7.jpg", "public/uploads/2009/11", "public/uploads/2009/11/22", "public/uploads/2009/11/22/0d7d330d319d8da3f4944fd77750a1a7.jpg", "public/uploads/2009/11/22/64b8299d1597b8a5c7b9cb9c88642f6c.jpg", "public/uploads/2009/11/22/f1bee81adb556c0a0d3ef482749b3ae7.jpg", "public/uploads/domain.com", "public/uploads/domain.com/2009", "public/uploads/domain.com/2009/02", "public/uploads/domain.com/2009/02/27", "public/uploads/domain.com/2009/03", "public/uploads/domain.com/2009/03/20", "public/uploads/domain.com/2009/03/20/05a4aff60618204c6b29831ce9ce8d45.png", "public/uploads/domain.com/2009/03/20/157247e313d42f31e8e543c4751a3a87.png", "public/uploads/domain.com/2009/03/20/168d90531c1ed73a8c98126aa31fd8ad.jpg", "public/uploads/domain.com/2009/03/20/2219a6b83e4c197a3b9a99a225419cb9.jpg", "public/uploads/domain.com/2009/03/20/2ec5bbbe61ff0379ec9c9e87e7efcc5d.jpg", "public/uploads/domain.com/2009/03/20/63ea97ba992107efc4d8d4feee1de0b2.jpg", "public/uploads/domain.com/2009/03/20/7817cfa2b3662ceec25a477cc4b6066c.png", "public/uploads/domain.com/2009/03/20/a13c8eb436e4152c63054f620a670549.jpg", "public/uploads/domain.com/2009/03/20/ac8ded3fd6eb0648d8e2f6bb58d88a6e.jpg", "public/uploads/domain.com/2009/04", "public/uploads/domain.com/2009/04/20", "public/uploads/domain.com/2009/04/20/168d90531c1ed73a8c98126aa31fd8ad.jpg", "public/uploads/domain.com/2009/04/20/a13c8eb436e4152c63054f620a670549.jpg", "public/uploads/domain.com/2009/04/20/ac8ded3fd6eb0648d8e2f6bb58d88a6e.jpg", "public/uploads/MediaRocket", "public/uploads/MediaRocket/2009", "public/uploads/MediaRocket/2009/05", "public/uploads/MediaRocket/2009/05/25", "public/uploads/MediaRocket/2009/06", "public/uploads/MediaRocket/2009/06/25", "public/uploads/MediaRocket/2009/10", "public/uploads/MediaRocket/2009/10/26", "public/uploads/MediaRocket/2009/10/26/168d90531c1ed73a8c98126aa31fd8ad.jpg", "public/uploads/MediaRocket/2009/10/26/a13c8eb436e4152c63054f620a670549.jpg", "public/uploads/MediaRocket/2009/10/26/ac8ded3fd6eb0648d8e2f6bb58d88a6e.jpg", "public/uploads/pop", "public/uploads/pop/2009", "public/uploads/pop/2009/09", "public/uploads/pop/2009/09/17", "public/uploads/pop/2009/09/17/afb40c3221e4d8bc7d1e55dee5192256.pdf", "public/uploads/pop/2009/12", "public/uploads/pop/2009/12/26", "public/uploads/pop/2009/12/26/8dfd3d65f330d4c14ef813193995b785.jpg", "public/uploads/pop/2009/12/26/e8a36e4ec567f5157d962e85a96c69dc.jpg", "public/uploads/pop/2009/12/26/fb0089ce7e7864e356985c82503f06f3.jpg", "public/uploads/site_name", "public/uploads/site_name/2009", "public/uploads/site_name/2009/02", "public/uploads/site_name/2009/02/17", "public/uploads/site_name/2009/02/17/d2b5ca33bd970f64a6301fa75ae2eb22.png", "stubs/app", "stubs/app/controllers", "stubs/app/controllers/application.rb", "stubs/app/controllers/main.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/alx/media-rocket}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{merb}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Merb Slice that provides a media server to upload and retrieve all kind of files}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<merb-slices>, [">= 1.0.4"])
      s.add_runtime_dependency(%q<rmagick>, [">= 2.9.2"])
    else
      s.add_dependency(%q<merb-slices>, [">= 1.0.4"])
      s.add_dependency(%q<rmagick>, [">= 2.9.2"])
    end
  else
    s.add_dependency(%q<merb-slices>, [">= 1.0.4"])
    s.add_dependency(%q<rmagick>, [">= 2.9.2"])
  end
end

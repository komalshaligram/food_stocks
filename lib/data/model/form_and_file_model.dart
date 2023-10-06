class FormAndFileModel {
  String? id;
  String? name;
  String? url;
  String? localUrl;
  bool? isForm;
  bool? isDownloadable;

  FormAndFileModel({
    this.id,
    this.name,
    this.url = '',
    this.localUrl = '',
    this.isForm = false,
    this.isDownloadable = false,
  });
}

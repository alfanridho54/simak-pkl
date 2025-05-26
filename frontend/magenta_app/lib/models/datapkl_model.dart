class DataPkl {
  String? company_name;
  String? company_address;
  String? contact_person;
  int? dosen_pembimbing;
  int? users_id;

  DataPkl({
    this.company_name,
    this.company_address,
    this.contact_person,
    this.dosen_pembimbing,
    this.users_id,
  });

  factory DataPkl.fromJson(Map<String, dynamic> json) {
    return DataPkl(
      company_name: json['company_name'],
      company_address: json['company_address'],
      contact_person: json['contact_person'],
      dosen_pembimbing: json['dosen_pembimbing'],
      users_id: json['users_id'],
    );
  }
}
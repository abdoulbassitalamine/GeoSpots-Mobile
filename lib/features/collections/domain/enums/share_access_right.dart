enum ShareAccessRight {
  read('READ', 'Lecture'),
  write('WRITE', 'Lecture / Ecriture');

  const ShareAccessRight(this.value, this.label);

  final String value;
  final String label;
}

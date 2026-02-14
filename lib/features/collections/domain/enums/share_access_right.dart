enum ShareAccessRight {
  read('read', 'Lecture'),
  write('write', 'Lecture / Ecriture');

  const ShareAccessRight(this.value, this.label);

  final String value;
  final String label;
}

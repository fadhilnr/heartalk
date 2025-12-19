class DeepTalkQuestions {
  static const Map<String, List<String>> questions = {
    'Pasangan': [
      'Apa momen paling berkesan yang pernah kita lalui bersama?',
      'Bagaimana menurutmu kita bisa lebih saling memahami?',
      'Apa yang paling kamu hargai dari hubungan kita?',
      'Kalau kamu bisa mengubah satu hal tentang kita, apa itu?',
      'Bagaimana cara terbaik aku menunjukkan cinta kepadamu?',
      'Apa ketakutan terbesarmu dalam hubungan ini?',
      'Seperti apa masa depan yang kamu bayangkan untuk kita?',
      'Hal apa yang ingin kamu pelajari lebih jauh tentang diriku?',
      'Bagaimana kita bisa lebih saling mendukung satu sama lain?',
      'Apa yang membuatmu merasa paling dicintai olehku?',
    ],
    'Teman': [
      'Apa yang paling kamu hargai dari persahabatan kita?',
      'Moment apa yang paling berkesan dalam persahabatan kita?',
      'Bagaimana aku bisa menjadi teman yang lebih baik untukmu?',
      'Apa hal yang belum pernah kamu ceritakan kepadaku?',
      'Seperti apa menurutmu persahabatan kita 10 tahun dari sekarang?',
      'Apa yang paling kamu butuhkan dari teman dekatmu?',
      'Hal apa yang membuatmu merasa paling nyaman bersamaku?',
      'Bagaimana kita bisa lebih saling mendukung dalam hidup?',
      'Apa mimpi terbesarmu yang belum pernah kamu ceritakan?',
      'Kapan kamu merasa paling bangga menjadi temanku?',
    ],
    'Keluarga': [
      'Apa kenangan masa kecil yang paling berkesan bagimu?',
      'Bagaimana aku bisa lebih memahami perspektifmu?',
      'Apa yang paling kamu hargai dari keluarga kita?',
      'Hal apa yang ingin kamu ubah dalam keluarga kita?',
      'Seperti apa keluarga idealmu?',
      'Apa pelajaran hidup terpenting yang kamu terima dari keluarga?',
      'Bagaimana kita bisa lebih sering berkomunikasi dengan baik?',
      'Apa harapan terbesarmu untuk keluarga kita?',
      'Moment apa yang membuatmu merasa paling dekat dengan keluarga?',
      'Bagaimana aku bisa lebih mendukungmu sebagai keluarga?',
    ],
  };

  static List<String> getQuestions(String category) {
    return questions[category] ?? questions['Pasangan']!;
  }
}

class CompatibilityQuestions {
  static const List<String> questions = [
    'Apakah kamu percaya pada cinta pada pandangan pertama?',
    'Apakah kamu lebih suka menghabiskan waktu di rumah daripada keluar?',
    'Apakah kamu memprioritaskan karir di atas hubungan?',
    'Apakah kamu terbuka tentang perasaan dan emosimu?',
    'Apakah kamu percaya komunikasi adalah kunci hubungan?',
    'Apakah kamu menyukai kejutan romantis?',
    'Apakah kamu mudah memaafkan kesalahan pasangan?',
    'Apakah kamu percaya pasangan harus punya hobi bersama?',
    'Apakah kamu suka merencanakan masa depan bersama?',
    'Apakah kamu merasa nyaman dengan waktu sendiri dalam hubungan?',
    'Apakah kamu percaya kepercayaan lebih penting dari apapun?',
    'Apakah kamu suka mengekspresikan cinta lewat kata-kata?',
    'Apakah kamu lebih suka konflik diselesaikan dengan tenang?',
    'Apakah kamu percaya pasangan harus punya visi hidup yang sama?',
    'Apakah kamu merasa penting untuk saling mendukung impian?',
  ];
}
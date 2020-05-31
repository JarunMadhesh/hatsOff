class AppreciationProvider {
  static List<String> _appreciations = [
    "You have started to do something new!",
    "Just pick urself up and carry on.",
    "Cheer up! You are just two days away from treating yourself with ice cream.",
    "Do it now because sometimes later never comes. ",
    "Its time to treat yourself with ice cream.",
    "Its a slow process, but quitting won't speed it up. Hence keep this going. ",
    "Keep it up, Don't give up, Cheer up.",
    "Shout out! You are just two days away from treating yourself with ice cream.",
    "Don't stop when you're tired; stop when you're done.",
    "Its time to treat yourself with ice cream.",
    "Don't stop until you're proud.",
    "Good things take time, don't give up!",
    "Brighten up! You are just two days away from treating yourself with ice cream.",
    "Don't limit your challenges. Challenge your limits.",
    "Its time to treat yourself with ice cream.",
    "Push yourself because no one else is going to do it for you.",
    "Dream it. Wish it. Do it.",
    "Gear up! You are just two days away from treating yourself with ice cream.",
    "The harder you work for something, the higher you'll feel when you achieve it .",
    "Its time to treat yourself with ice cream.",
    "Winners are not people who never fail, but people who never quit.",
    "Stay positive, work hard, and make it happen.",
    "Come on! You are just two days away from treating yourself with ice cream.",
    "The pain you feel today will be the strength you feel tomorrow .",
    "Its time to treat yourself with ice cream.",
    "Each new day is a new opportunity to improve yourself, take it, and make the most of it.",
    "The key to success is to focus on goals but not on obstacles.",
    "Keep going! You are just two days away from treating yourself with ice cream.",
    "Today's accomplishments were yesterday's impossibilities.",
    "Its time to treat yourself with ice cream.",
  ];

  String getAppreciation(int streek, String treat) {
    if(_appreciations[streek].contains('ice cream')) {
      return _appreciations[streek].replaceAll('ice cream', 'a ${treat.toLowerCase()}');
    }
    if (streek <= 29) return _appreciations[streek];
    while (streek >= 30) {
      streek = streek ~/ 30;
    }
    if (streek == 1) streek++;
    if(_appreciations[streek].contains('ice cream')) {
      return _appreciations[streek].replaceAll('ice cream', 'a ${treat.toLowerCase()}');
    }
    return _appreciations[streek];
  }
}

enum cardRoles {
  empty,
  rifleman,
  specialist,
  sniper,
  medic,
  newCard,
  deleteAll
}

class loadoutInfo {
  String name = "";
  String primary = "";
  String secondary = "";
  String otherEquipment = "";
  cardRoles role = cardRoles.rifleman;
}

extension rolesFunctions on cardRoles {
  String get name {
    switch (this) {
      case cardRoles.medic:
        return 'Medic';
      case cardRoles.rifleman:
        return 'Rifleman';
      case cardRoles.sniper:
        return 'Sniper';
      case cardRoles.specialist:
        return 'Specialist';
      case cardRoles.empty:
        return 'Empty';
      case cardRoles.newCard:
        return 'New Card';
      case cardRoles.deleteAll:
        return 'Delete All';
      default:
        return '';
    }
  }
}
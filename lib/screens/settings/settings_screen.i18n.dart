import 'package:i18n_extension/i18n_extension.dart';

extension SettingsLocalization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "personal_details": "Personal Details",
          "open_dkt": "Open DKT",
          "edit_nickname": "Edit Nickname",
          "edit_profile_picture": "Edit Profile Picture",
          "remove_profile_picture": "Remove Profile Picture",
          "light": "Light",
          "dark": "Dark",
          "system": "System",
          "add_user": "Add User",
          "log_out": "Log Out",
          "update_available": "Update Available",
          "general": "General",
          "language": "Language",
          "startpage": "Startpage",
          "rounding": "Rounding",
          "appearance": "Appearance",
          "theme": "Theme",
          "color": "Color",
          "grade_colors": "Grade Colors",
          "notifications": "Notifications",
          "news": "News",
          "about": "About",
          "supporters": "Supporters",
          "privacy": "Privacy Policy",
          "licenses": "Licenses",
          "done": "Done",
          "reset": "Reset",
          "open": "Open",
        },
        "hu_hu": {
          "personal_details": "Személyes információk",
          "open_dkt": "DKT megnyitása",
          "edit_nickname": "Becenév szerkesztése",
          "edit_profile_picture": "Profil-kép szerkesztése",
          "remove_profile_picture": "Profil-kép törlése",
          "light": "Világos",
          "dark": "Sötét",
          "system": "Rendszer",
          "add_user": "Felhasználó hozzáadása",
          "log_out": "Kijelentkezés",
          "update_available": "Frissítés elérhető",
          "general": "Általános",
          "language": "Nyelv",
          "startpage": "Kezdőlap",
          "rounding": "Kerekítés",
          "appearance": "Kinézet",
          "theme": "Téma",
          "color": "Színek",
          "grade_colors": "Jegyek színei",
          "notifications": "Értesítések",
          "news": "Hírek",
          "about": "Névjegy",
          "supporters": "Támogatók",
          "privacy": "Adatvédelmi irányelvek",
          "licenses": "Licenszek",
          "done": "Kész",
          "reset": "Visszaállítás",
          "open": "Megnyitás",
        },
        "de_de": {
          "personal_details": "Persönliche Angaben",
          "open_dkt": "Öffnen DKT",
          "edit_nickname": "Spitznamen bearbeiten",
          "edit_profile_picture": "Profilbild bearbeiten",
          "remove_profile_picture": "Profilbild entfernen",
          "light": "Licht",
          "dark": "Dunkel",
          "system": "System",
          "add_user": "Benutzer hinzufügen",
          "log_out": "Abmelden",
          "update_available": "Update verfügbar",
          "general": "Allgemein",
          "language": "Sprache",
          "startpage": "Startseite",
          "rounding": "Rundung",
          "appearance": "Erscheinungsbild",
          "theme": "Thema",
          "color": "Farbe",
          "grade_colors": "Grad Farben",
          "notifications": "Benachrichtigungen",
          "news": "Nachrichten",
          "about": "Informationen",
          "supporters": "Unterstützer",
          "privacy": "Datenschutzbestimmungen",
          "licenses": "Lizenzen",
          "done": "Fertig",
          "reset": "Zurücksetzen",
          "open": "Öffnen",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}

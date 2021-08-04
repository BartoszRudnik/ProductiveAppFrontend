class ConstValues {
  static const sortingModes = [
    'end Date ascending',
    'end Date descending',
    'start Date ascending',
    'start Date descending',
    'priority descending',
    'priority ascending',
    'custom',
  ];

  static const defaultMapTemplate = "https://tile.openstreetmap.org/{z}/{x}/{y}.png";

  static const lightMapTemplate = "https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png";
  static const darkMapTemplate = "https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png";

  static const mapSubdomains = ['a', 'b', 'c'];
}

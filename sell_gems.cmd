start:
  put open my pouch
  pause 0.5
  goto sell_gems

sell_gems:
  matchre sell_gem ((agate|amber|andalusite|aquamarine|\bberyl|bloodstone|carnelian|chalcedony|chrysoberyl|chrysoprase|citrine|coral|crystal|diopside|emerald|garnet|hematite|iolite|ivory|jade|kunzite|lazuli|moonstone|morganite|ruby|sapphire|stones|sunstone|tanzanite|topaz|tourmaline|tsavorite|turquoise|onyx|opal|peridot|quartz|spinel|zircon)(\.|,))
  matchre finished there is nothing in there
  pause 0.75
  put rummage my pouch
  matchwait 5
  goto finished

sell_gem:
  pause 0.75
  put get $1 from my pouch
  pause 0.75
  put sell $1
  goto sell_gems

finished:
  pause 0.5
  put close my pouch
  echo *** sold all gems ***

# Block Venture (Godot 4 Verzió)

A teljes **Block Venture / Block Blaster** játék natív Godot 4 (GDScript) átirata.

## 🚀 Hogyan nyitható meg Godot-ban?

1. Nyisd meg a **Godot 4.x** (pl. Godot 4.2 / 4.3) szerkesztőt.
2. Kattints az **Import** gombra a Projektkezelőben.
3. Válaszd ki ezt a mappát: `/Users/kulovanyikornel/Downloads/Block buster/Godot/project.godot`.
4. Kattints a **"Futtatás" (F5 vagy Play gomb jobb fent)** gombra!

---

## 📁 Felépítés

- `project.godot`: 540x960 Portrait mobil felbontás és globális AutoLoad egykék (`GameManager`, `SaveManager`, `SoundManager`).
- `scenes/`:
  - `Main.tscn`: Fő képernyő és alsó/felső navigációs sávok.
  - `screens/`: Lobby, Game, Shop (IAP + Reklám), Upgrades, Codex (Könyvolvasó), Achievements (XP Mester rang), Leaderboard.
  - `components/`: 8x8 Tábla (`Board`), Rácsmezők (`Cell`), Alakzatok (`Piece`), Dokkoló (`Dock`).
  - `modals/`: Game Over és Beállítások ablakok.
  - `vfx/`: Lebegő pontszám és effekt szövegek.
- `scripts/`: Teljes GDScript logikai architektúra.

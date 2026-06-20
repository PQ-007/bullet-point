# Bullet point

A small top-down survivor-style shooter built with **Godot 4.5** (GL Compatibility renderer).
You play a lone hero on a ruined island, fending off waves of guards that spawn around you.

## Controls

| Action | Input |
| ------ | ----- |
| Move   | `W` `A` `S` `D` |
| Aim    | Mouse |
| Shoot  | Left mouse button / `Space` |

The gun rotates to follow the mouse and bullets leave the barrel toward the
cursor. Enemies chase you and attack in melee range, each showing a health bar
when hurt. When your own health reaches zero a **YOU DIED** screen appears and
the run restarts automatically.

## Features

- Mouse-aimed gun: the weapon points at the cursor and fires from the muzzle.
- Two enemy types spawned at random — a **Warrior** and a faster, weaker **Archer**.
- Floating health bars over damaged enemies and a HUD health bar for the hero.
- Death screen + automatic restart, so it loops as a complete play session.

## Project layout

```
bullet-point/
├── project.godot              # engine config + input map
├── scenes/
│   ├── level.tscn / level.gd      # main scene; restarts on death
│   ├── spawner.gd                 # spawns random enemies around the hero (concurrent cap)
│   ├── heroes/   hero.tscn / hero.gd       # player: movement, mouse-aim, shooting, health
│   ├── enemies/
│   │   ├── guard.gd                    # shared chase/attack/hit/die controller
│   │   ├── guard.tscn                  # Warrior enemy
│   │   └── archer.tscn                 # Archer enemy (faster, weaker)
│   ├── projectiles/ bullet.tscn / bullet.gd # straight-line projectile
│   └── ui/
│       ├── health_bar.gd               # reusable world-space health bar
│       └── hud.tscn / hud.gd           # hero health bar + "YOU DIED" overlay
└── assets/                    # sprites & tileset (see assets/read me - license.txt)
```

## Collision layers

| Layer | Used by |
| ----- | ------- |
| 1 | Hero |
| 2 | Enemies |
| 3 | Player bullets |

Bullets only mask layer 2 (enemies), so the hero can't shoot itself.

## Running

Open the `bullet-point/` folder in the Godot 4.5 editor and press **F5**, or from
the command line:

```sh
godot --path bullet-point
```

## Credits

Art assets are third-party; see [`assets/read me - license.txt`](assets/read%20me%20-%20license.txt)
for licensing details.

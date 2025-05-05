# Task Board - A Project Zomboid Mod

A simple and immersive **Kanban-style task board** for Project Zomboid. Organize your survival priorities with categorized tasks: **To Do**, **In Progress**, and **Done** — all available from your chosen board furniture.

---

## Features

- Create, update and delete tasks for easier management.
- **Compatible with Multiplayer!**
- Assign an office board furniture as a task board to start.
- Multiple boards are supported with their own task boards.
- **Synchronizes properly through other players in real-time.**

---

## How to Install (Local Mod)

### 1. Locate the Zomboid Mods Folder

- **Windows**:  
  `C:\Users\<YourUsername>\Zomboid\mods\`

- **macOS**:  
  `~/Zomboid/mods/`

- **Linux**:  
  `~/.zomboid/mods/`

Replace `<YourUsername>` with your actual system username.

### 2. Install the Mod

- Copy this mod folder (`TaskBoard`) into your `mods` directory.
- Do not rename the folder.

### 3. Enable the Mod

1. Launch **Project Zomboid**
2. Go to **Mods** from the main menu
3. Find **Kanban Board**, click **Enable**
4. Click **Back** and restart the game

---

## How to Use

1. Enter a game world (new or existing).
2. Find a supported furniture (see below; more boards will be supported in the future).
3. Pick it up and bring it to your base.
4. Place the Cork Noteboard somewhere.
5. Right-click the placed furniture and click Make Task Board.
6. Start creating tasks!
7. Open it up again by right clicking the furniture.

---

## Technical Notes

- Built using Lua and the native UI API.
- Data is stored with `ModData` per furniture.
- Old version where the task board is global has a migration option to move their currennt tasks to a supported furniture.
- Supported Furnitures:
  - **Office Whiteboard** (All segments)
  - **Cork Noteboard**
  - **Big Cork Noteboard** (left & right)
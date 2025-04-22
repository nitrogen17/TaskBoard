# Kanban Board - A Project Zomboid Mod

A simple and immersive **Kanban-style task board** for Project Zomboid. Organize your survival priorities with categorized tasks: **Requested**, **In Progress**, and **Done** — all from a custom button in your in-game toolbar.

---

## Features

- Add, edit, and delete tasks
- Drag and drop tasks between three columns
- Helps manage goals like base building, crafting, or roleplay quests
- Opens via a **toolbar icon** below the map

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

- Copy this mod folder (`KanbanBoard`) into your `mods` directory.
- Do not rename the folder.

### 3. Enable the Mod

1. Launch **Project Zomboid**
2. Go to **Mods** from the main menu
3. Find **Kanban Board**, click **Enable**
4. Click **Back** and restart the game

---

## How to Use

1. Enter a game world (new or existing)
2. Click the **note icon** on the left toolbar (below the map)
3. Create new tasks in the **Requested** column
4. Drag tasks to **In Progress** or **Done** as needed
5. Tasks are saved and persist between sessions

---

## Technical Notes

- Built using Lua and the native UI API
- Data is stored with `ModData` per-player
- All logic runs client-side
- Multiplayer compatibility in development

---

## mod.info

```ini
name=Kanban Board
id=KanbanBoard
description=A simple kanban-style task organizer for Project Zomboid survivors.
version=1.0.0

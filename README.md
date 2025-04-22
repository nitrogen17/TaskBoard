# Task Board - A Project Zomboid Mod

A simple and immersive **Kanban-style task board** for Project Zomboid. Organize your survival priorities with categorized tasks: **To Do**, **In Progress**, and **Done** — all from a custom button in your in-game toolbar.

---

## Features

- Add, edit, and delete tasks
- Drag and drop tasks between three columns
- Opens via a **toolbar icon** besides the map

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

1. Enter a game world (new or existing)
2. Click the **note icon** on the left toolbar (below the map)
3. Create new tasks in the **To do** column
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
name=TaskBoard
id=TaskBoard
description=The Task Board is an in-game task management system that redefines how you handle objectives in Project Zomboid. It seamlessly introduces a sleek, intuitive, and immersive Kanban-style board into your UI — positioned exactly where team members expect to find and complete tasks related to safehouse operations. Inspired by modern productivity platforms like Trello, Asana, and Jira, the Task Board brings the structure and efficiency of real-world task management into your survival experience. It allows you to create tasks, organize objectives, plan your actions, and maintain focus — all directly within the game, without disrupting immersion or relying on external tools or notes.
version=1.0.0
```
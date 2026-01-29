# why-pip-why

A brutally efficient Python uninstaller for Windows, born from the ashes of a dev session ruined by broken `pip`, ghosted `pyinstaller`, and the **eldritch** horror that is Windows PATH management.

This script doesn’t try to fix your Python install. It doesn't gently repair. It doesn't whisper soothing Stack Overflow threads into your ear. It **eradicates**. It will find every Python version installed across your system, every trace left in AppData, every leftover virtualenv hiding in the corner, and wipe it out.

## What It Does

- Uninstalls **every** Python version it finds, even the cursed half-dead ones
- Deletes:
  - `C:\Program Files\Python*`
  - `AppData\Roaming\Python`
  - `AppData\Local\Programs\Python`
  - `site-packages`, `.virtualenvs`, `pip` caches — *everything*
- Removes Python and pip from your system and user PATHs
- Leaves your system cleaner than the day it was born

## When to Use This

- When `pip install` says it's done but `python -m` swears it’s not there  
- When PyInstaller has installed but “doesn’t exist”  
- When your terminal and Windows are gaslighting you in sync  
- When you've uninstalled Python five times and it still shows up like your ex in your task manager

## Warning

This script is not careful. It does not ask for confirmation. It assumes you're done with diplomacy. **Use it only if you're ready to burn everything and start fresh.**

---

> “Sometimes the only way forward is a clean slate and a bottle of whiskey.”

## Next Steps

After using this script, reboot your machine and head to:  
[https://www.python.org/downloads/](https://www.python.org/downloads/)

- Select “Install for all users”
- Check “Add Python to PATH”
- Install it somewhere sane like `C:\Python311`, far away from Windows permission hell

---

Contributions welcome. Just don’t suggest a gentler approach.

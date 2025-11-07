# RTA Timer
This mod adds an RTA (real-time) timer below the IGT timer. It has multi-run support and can be shown or hidden.

**This is not [leaderboard](https://speedrun.com/hades) legal, and any runs found to be using this mod _will_ be rejected** 

# Installation
To install the RTA Timer, go to the [Releases](https://github.com/Museus/RtaTimer/releases) tab and download the latest .zip file. This will include the following files:

-   Mods/
    - RtaTimer/
    - PrintUtil/
    - ModUtil/
-   modimporter.py

[A video tutorial on how to install mods is available from PonyWarrior here](https://www.youtube.com/watch?v=YF0ij7MgOrI)

If you prefer text instructions, follow these steps:

If you don't already have Python installed, download it from [python.org](https://www.python.org/downloads/) and install it.

Once you have downloaded the `RtaTimer.zip` file, open up your Hades game directory. You can find this by launching Hades, then opening Task Manager, finding the Hades process, right-clicking on it, and selecting Open File Location.

Unzip the files into the `.../Hades/Content` folder. You should now have the standard folders such as `Scripts` and `Game` plus a new folder called `Mods` and the `modimporter.py` script.

Run the `modimporter.py` script to install the mods, then load into your game. Whenever you want to uninstall the mods, delete the `Mods` folder's contents, and run the `modimporter.py` script again.

# Configuration

The RTA Timer can be shown or hidden, and multi-run support can be enabled or disabled. To change these options, you have two options:

  1) Install [ModConfigMenu made by ParadigmSort](https://github.com/parasHadesMods/ModConfigMenu)
    
  2) Open the `.../Hades/Content/Mods/RtaTimer` folder then open `RtaTimer.lua` in Notepad. There will be a block at the top with `local config = {` followed by the options that can be changed.

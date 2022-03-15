# Shader-Stacker
The GPU accelerated version of Sprite Stacking. ~~A top-down 2.5D trick for the Godot Engine.~~
Now in full 3D!

# Why 3D? Why not make it *real* 2.5D in 2D
No matter how you slice it, implenting performant sprite stacking in 2D Godot Engine always results
in reimplementing features that come for free in the 3D Engine. Besides, all code is "3D" code,
it just comes down to whether you want to implement feature compete 3d in Godot Script, or enable
orthoganol in the Camera3D and call it a day

If you aren't convinced, you're more than welcome to pick up the work where it was left off.
Fork off fork off f797d0d1b2d98f96b148f06f11e227c6a4b2f64f and try to write a solution for #1 #6 
and #7.

# Documentation
Is found [on the github pages for this repo](https://ka.rlphilli.ps/Shader-Stacker/).

# Your License Scares Me!
Don't worry. It should be clear by reading it but just in case it's unclear for any reason:

* If you improve the code in any way, please open-source it and make a pull request.
* If you make a game with this, license it however you please. Just include a copy of the MPL.
   * Ex: Chuck a copy of the license with the name "Shader-Stacker" in a "Licenses" folder.
* You can do whatever you want with the sample assets.
* A link back to the repo as attribution would be nice but not strictly neccesary.

# Shader-Stacker
The GPU accelerated version of Sprite Stacking. ~~A top-down 2.5D trick for the Godot Engine.~~
Now in full 3D!

# FAQ
## Documentation
Is found [on the github pages for this repo](https://ka.rlphilli.ps/Shader-Stacker/).

## Your License Scares Me!
Don't worry. It should be clear by reading it but just in case it's unclear for any reason:

* If you improve the code in any way, please open-source it and make a pull request.
* If you make a game with this, license it however you please. Just include a copy of the MPL.
   * Ex: Chuck a copy of the license with the name "Shader-Stacker" in a "Licenses" folder.
* You can do whatever you want with the sample assets.
* A link back to the repo as attribution would be nice but not strictly neccesary.

## Why 3D? Why not make it *real* 2.5D in 2D
To me, there's 2 compelling things about sprite stacking.

The first is the moddability. My theory is if you made a compelling enough sandbox on top of sprite stacking, you could potentially release a game with really sweet modding support. Most games require modders to know existing 3D tooling (blender, 3dsmax, or worse, something proprietary). On top of that, there's the question of rigging and skeletons, it's all a big barrier for people to get into. With sprite stacking, you could potentially make a game where this barrier is much lower. An aspiring modder just needs to know what sprite stacking is and how to use an image editor.

The second is how interesting it looks. The edges are oddly jagged, gaps appear and disappear between "lines" as the model rotates. Models are constantly in a state of discomfort over what pixel they should exist in. And it's all wrapped up into a ~30 degree perspective. Its an art style that has "rules" much like how an NES looking game would limit itself to the original pallet size, or a PS looking game would have limit on polygons per model. It feels nostalgic because of it, but at the same time, fresh because of how there never was a "sprite stacking" generation of graphics. It's really unique.

![Nium](https://user-images.githubusercontent.com/10494276/158463488-9fc9cd78-c839-48aa-a181-b960ce2f7be6.gif)

That being said, the reason for 3D is to address 3 problems. Which, the word problem is used subjectively, because they're behaviors of the original effect which I personally have decided are undesirable.

#1
Adding a performant way to lower the camera angle (which is crucial to achieving the [Nium](https://www.youtube.com/watch?v=_BztMPC5Kk4) art style). Once the camera is set to orthogonal, the image and sprites are being transformed the same. The difference now being unintuitive values aren't baked into the engine frontend. Every billboard needed it's height doubled. All stacks needed to render each layer twice, making code confusing. All just to result in all the data being dropped at runtime in a nearest neighbor compression squishing the 8:9 (16:18) resolution into a 16:9 frame. And don't get me started on how this resulted in needing to fight the automatic offscreen culling in the 2D engine. 

Now with the new code, the values in the inspector all make sense and no unnecessary calculations are made. The look is also the same due to being able to adjust camera3D from perspective into orthogonal rendering
![perspective vs orthogonal](https://user-images.githubusercontent.com/10494276/158466088-a5125e09-fa04-494a-a413-25d130529b54.png)

 #6 
Fixing unexpected z sorting due to only the center point being considered. Gif is of the bug. Due to Real 3D™ magic, this is fixed in the new implementation

![z-fighting in tradition sprite stacking center base sorting](https://user-images.githubusercontent.com/10494276/158458310-da608f57-d918-488e-b8cb-b848fcd3ccff.gif)

#7
Related to #1, now the camera can support all 3D operations, or hook seamlessly into any existing camera 3D libraries.

The thing in common with all the above problems, is there are no tricks. The only way to solve them is to write the existing code in the 3D engine, but slower due to godot lang overhead. The goal isn't to make feature complete 3D, but is to make something *performant* that *looks and acts* like sprite stacking, and hooks into as many existing godot systems as possible to keep the developer experience in the editor enjoyable.

That being said, there's still some work to be done to hone in the effect, but it's not like any data has been lost or rasterized. It will be tuned up as the project progresses.

![Shader stack in Godot 3D looks nearly identical once rendered in game](https://user-images.githubusercontent.com/10494276/158462796-e0bd0eb0-0278-4c2c-9a93-1f74a861352f.png)

If you aren't convinced, you're more than welcome to pick up the work where it was left off.
Fork off fork off [feat/1/cam-pitch-rework](https://github.com/KarlTheCool/Shader-Stacker/tree/feat/1/cam-pitch-rework) and try to write a 2D solution for #1 #6 
and #7.

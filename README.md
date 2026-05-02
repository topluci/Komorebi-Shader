# Komorebi Shaders
Cel-shaded anime-style Minecraft shader inspired by Neverness to Everness and contemporary illustrators.

Komorebi turns Minecraft into a warmer, flatter, more illustrated scene: quantised light bands, violet-tinted shadows, saturated colour, rim highlights, and ink-like screen-space outlines.

## Features
- Cel shading with configurable 3-5 brightness bands
- Screen-space ink outlines for blocks, terrain silhouettes, mobs, and hard colour/depth edges
- 25% default saturation boost with warm golden-hour grading
- Rim lighting for character and object separation
- Colored shadows instead of pure black
- Configurable outline width, outline strength, saturation, warmth, cel bands, shadow depth, and rim strength
- Conservative #version 120 GLSL for broad Iris/OptiFine compatibility

## Requirements
- Version 1.19+
- Iris Shaders on Fabric, or OptiFine
- Recommended: a flat-colour or minimalist resource pack

## Installation
1. Zip this folder, or use the included komorebi-shader-pack.zip if present.
2. Put the zip or folder into .minecraft/shaderpacks/.
3. Launch Minecraft.
4. Open Options > Video Settings > Shader Packs and select Komorebi Shaders.

## Options
The shader options menu exposes:

- SATURATION: colour vibrancy
- WARMTH: golden-hour grade strength
- CEL_BANDS: number of cel-lighting bands
- SHADOW_DEPTH: how heavily violet shadows tint lighting
- RIM_STRENGTH: edge light intensity on geometry
- OUTLINE_WIDTH: screen-space ink thickness
- OUTLINE_STRENGTH: ink darkness/opacity
- EDGE_DEPTH_SENSITIVITY: how aggressively depth discontinuities become outlines
- Profiles are included for LOW, MEDIUM, and HIGH.

## Technical Notes
The original concept mentions inverted hull outlines. A universal inverted-hull pass is not available in a standard OptiFine/Iris shader pack without building on a larger multi-pass base shader. This pack instead uses a practical screen-space outline pass that detects depth and colour discontinuities in composite.fsh. That is more compatible and still gives the intended anime ink-line read.

The ramp texture in shaders/textures/colormap.png matches the proposed dark-violet, warm-orange, pale-yellow palette. The live shader uses an equivalent procedural ramp, so it does not depend on fragile custom texture bindings.

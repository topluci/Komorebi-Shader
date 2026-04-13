# Komorebi Shader

Komorebi Shader is an Iris-compatible Minecraft shaderpack focused on a soft,
dreamy anime-inspired look while preserving gameplay readability and the core
Minecraft feel.

## About

Komorebi is built from a deferred shader pipeline and tuned for:
- Warm soft sunlight
- Gentle contrast and lifted shadows
- Atmospheric bloom diffusion
- Dreamy distance fog
- Smooth stylized sky gradients
- Calm cinematic color response

Visual inspiration includes anime illustration lighting and nostalgic outdoor
cinematic mood.

## Features

- Iris-compatible shaderpack structure
- Stylized post-processing in composite/final passes
- Warmth and pastel balance controls
- Soft bloom scaling and final gamma control
- Fog and atmosphere controls for dreamy depth
- Komorebi style menu with `LIGHTING`, `ATMOSPHERE`, `COLOUR`, `BLOOM`
- Komorebi presets: `LOW`, `MEDIUM`, `HIGH`, `CINEMATIC`
- Profile-based quality/performance options

## Main Shader Areas

Core stylization work is concentrated in:
- `shaders/program/composite*.glsl`
- `shaders/program/final.glsl`
- `shaders/lib/komorebi/*.glsl`
- `shaders/lib/colors/*.glsl`
- `shaders/lib/atmospherics/*.glsl`
- `shaders/shaders.properties`
- `shaders/lang/en_US.lang`


## Compatibility

- Minecraft Java Edition
- Iris Shaders loader

## Included Files

- `shaders/`
- `LICENSE`
- `README.md`

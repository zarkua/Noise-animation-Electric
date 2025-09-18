# Noise Animation Electric — Defold Shader

A lightweight shader effect for the **Defold** game engine, ported from
[ShaderToy: ldlXRS](https://www.shadertoy.com/view/ldlXRS) and adapted for Defold by **zarkua**.

This repo contains two parts:
- **`/shader`** — reusable library files (material + programs) exposed via `library.include_dirs`.
- **`/example`** — a minimal scene showing how to use the shader.

> If you clone this repository for your own shader, please keep the Attribution/Credits section.

---

## Use as library

Add this asset as a library dependency in your Defold project:

- **Stable (recommended):** use a tagged release ZIP  
  `https://github.com/zarkua/Noise-animation-Electric/releases`
- **Latest (for evaluation):** main-branch archive ZIP  
  `https://github.com/zarkua/Noise-animation-Electric/archive/refs/heads/main.zip`

Then open **game.project** in your project and add the dependency URL under **Project ▸ Dependencies**, click **Fetch Libraries**.

This library exposes the **`/shader`** folder via `library.include_dirs` in `game.project`.

---

## Demo

An HTML5 demo is automatically built and deployed to GitHub Pages via GitHub Actions.

- **Live demo:** `https://zarkua.github.io/Noise-animation-Electric/`

---

## Quick start (Example project)

1. Open this repository as a Defold project.
2. Run the app — the example scene in **`/example`** will render with this shader.
3. To use in your project, assign the material from **`/shader`** to a sprite/model and set uniforms as needed.

---

## Uniforms

Depending on your setup, you will typically expose:
- `iTime` — seconds since start (vec4, using `.x`)
- `iResolution` — viewport size in pixels (vec4, using `.xy`)
- `iChannel0` *(optional)* — sampler2D noise/mask if used

> Ensure your script updates the time uniform each frame and sets resolution on init / resize.

---

## Credits

- Original shader idea/code: **ShaderToy – ldlXRS**: https://www.shadertoy.com/view/ldlXRS  
- Defold port and packaging: **zarkua** — https://github.com/zarkua/Noise-animation-Electric

---

## License

This project is released under **CC0 1.0 Universal (Public Domain)** — see `LICENSE`.
You can copy, modify, and use it for any purpose without asking permission.

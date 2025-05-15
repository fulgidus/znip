# Cross-platform Clipboard Manager in Zig

This application, written in Zig, allows you to manage clipboard history on Windows, Linux, and macOS.

## Main Features
- Automatic saving of copied clipboard entries
- Fast search and selection from history
- Cross-platform support (Windows, Linux, macOS)

## Dipendenze

### Windows
- Nessuna dipendenza esterna: il programma usa le API di sistema tramite `powershell`.

### Linux (X11)
- **libX11** (libreria di sviluppo X11): necessaria per accedere alla clipboard tramite chiamate FFI.
    - Su Ubuntu/Kubuntu/Debian: installa con `sudo apt-get install libx11-dev`
- **Nota:** Su Wayland la clipboard NON è supportata (verrà restituito un errore).

### macOS
- **pbpaste**: comando di sistema già presente su tutte le installazioni macOS moderne.

## Build

### Con Zig build system
Assicurati di avere le dipendenze installate, poi:

```sh
zig build
```
L'eseguibile sarà in `zig-out/bin/`.

### Build manuale (solo per sviluppo)
```sh
zig build-exe zig-app/main.zig -lX11
```

## Note
- In futuro sarà possibile includere le dipendenze in un installer.
- Su Linux, senza `libX11` **non è possibile** accedere alla clipboard.
- Su Wayland, la clipboard non è ancora supportata.
- Su macOS, il programma si appoggia a `pbpaste` (di sistema, non di terze parti).

## TODO
- Supporto clipboard su Wayland (wl-clipboard, FFI, o tool di sistema)
- Installer automatico con gestione dipendenze
- UI migliorata

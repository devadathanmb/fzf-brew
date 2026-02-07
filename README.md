# fzf-brew (fish)

A [fish](https://fishshell.com)-native rewrite of the [fzf-brew](https://github.com/thirteen37/fzf-brew) Zsh plugin. It provides fast, fuzzy install/uninstall helpers for Homebrew formulae and casks, with previews and a homepage opener.

## Screenshots
<img width="3024" height="1964" alt="image" src="https://github.com/user-attachments/assets/8ff2b837-760a-4536-b2b5-201c3f3e7aa7" />
<img width="3024" height="1964" alt="image" src="https://github.com/user-attachments/assets/aa89de95-2d6f-4016-9c83-6a08f0e9768d" />
<img width="3024" height="1964" alt="image" src="https://github.com/user-attachments/assets/f1f52d7c-af9b-4524-9ccb-1fa3c42c61a1" />


## Requirements

* fish 3.0+
* Homebrew (`brew`)
* fzf (`fzf`)

## Install

* With [fisher](https://github.com/jorgebucaran/fisher):

```fish
fisher install devadathanmb/fzf-brew
```

* With [oh-my-fish](https://github.com/oh-my-fish/oh-my-fish):

```fish
omf install https://github.com/devadathanmb/fzf-brew
```

## Usage

Commands match the original aliases:

* `fbi` — fuzzy install formulae
* `fbui` — fuzzy uninstall formulae
* `fci` — fuzzy install casks
* `fcui` — fuzzy uninstall casks

You can pass an initial query string:

```fish
fbi rip
```

During selection:

* `shift-tab` toggles multi-select (fzf default)
* `ctrl-o` opens the homepage for the highlighted item

## Configuration

`fzf-brew` exposes a small set of variables under the `FZF_BREW_` prefix. These control behavior specific to this plugin.

* `FZF_BREW_HOME_BIND`
  Key binding used to open the homepage of the highlighted item
  *(default: `ctrl-o`)*

All other UI and interaction details—such as layout, height, preview window behavior, colors, and key bindings—are provided directly by **fzf itself**.

You can customize those using standard `fzf` mechanisms, for example:

* `FZF_DEFAULT_OPTS`
* `fzf` command-line options
* Environment variables or shell configuration

This plugin simply forwards those options to `fzf` without redefining them.

## Tests

To run the test suite:

```fish
fish tests/run.fish
```

## License

[GPL v3](./LICENSE)

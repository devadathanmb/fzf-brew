# fzf-brew (fish)

A [fish](https://fishshell.com)-native rewrite of the [`fzf-brew`](https://github.com/thirteen37/fzf-brew) Zsh plugin. It provides fast, fuzzy install/uninstall helpers for Homebrew formulae and casks, with previews and a homepage opener.

## Requirements

- fish 3.0+
- Homebrew (`brew`)
- fzf (`fzf`)

## Install

With [fisher](https://github.com/jorgebucaran/fisher):

```fish
fisher install devadathanmb/fzf-brew
```

With [oh-my-fish](https://github.com/oh-my-fish/oh-my-fish):

```fish
omf install https://github.com/devadathanmb/fzf-brew
```

## Usage

Commands match the original aliases:

- `fbi` — fuzzy install formulae
- `fbui` — fuzzy uninstall formulae
- `fci` — fuzzy install casks
- `fcui` — fuzzy uninstall casks

You can pass an initial query string:

```fish
fbi rip
```

During selection:

- `shift-tab` toggles multi-select (fzf default)
- `ctrl-o` opens the homepage for the highlighted item

## Configuration

You can customize the fzf UI with variables:

- `FZF_BREW_PREVIEW_WINDOW` (default: `right:60%:wrap`)
- `FZF_BREW_HEIGHT` (default: `40%`)
- `FZF_BREW_HOME_BIND` (default: `ctrl-o`) — key to open homepage (e.g. `ctrl-space`)
- `FZF_BREW_FZF_OPTS` (additional fzf options)

## Tests

A self-contained test runner is included (no external test deps):

```fish
fish tests/run.fish
```

## License

[GPL v3](./LICENSE)

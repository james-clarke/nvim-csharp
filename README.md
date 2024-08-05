# A C-Sharp Neovim Configuration for Full-Stack Development
**Important note**: This repo is a *work in progress*, and still requires a lot of configuration. There's a long list of features I want to make available inside this neovim setup, so the following list has been made to keep track of my progress. If you have any questions, or wish to make suggestions for what needs to be added to the configuration, please contact me through the [Support](#Support) section at the bottom of this file.

## Features
The following a list of features I want to add to the configuration. Features with a ~slash~ through them have been set up.
- ~Color theming~
- ~Fuzzy finding~
- ~Syntax highlighting~
- ~File/solution explorer~
- ~Status line~
- ~Language server protocol~
- Autocompletion
- Formatting and linting
- Git intergrations
- Intergrated terminal
- Debugger adapter protocol

## Get Started
To begin, we need to make sure Neovim, Node.js and Python3 are installed.
```bash
nvim -v                             # must be >= 0.9.2
node -v                             # must be >= v22.x.x
python3 -V                          # must be >= 3.12.x
```

Now that we has the basics, lets install some dependencies...
```bash
brew install git
brew install curl
brew install fd
brew install grep
brew install ripgrep
brew install gnu-tar
brew install unzip
brew install gzip
```

To use OmniSharp (.NET dev platform for project dependencies and C# language services), as well as TSServer for JavaScript + TypeScript + Angular development, you need to install the following language servers. The Lua language server will also be installed to help debug the config file, if needed.
```bash
brew install lua-language-server

brew tap omnisharp/omnisharp-roslyn
brew install omnisharp-mono

npm install -g typescript typescript-language-server
npm install -g @angular/language-server
npm install -g vscode-langservers-extracted
```

Back up your original config and clone the repo using the following commands:
```bash
mv ~/.config/nvim ~/.config/nvim.bak

mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak

git clone --depth 1 https://github.com/james-clarke/nvim-csharp.git ~/.config/nvim
rm -rf ~/.config/nvim/.git
nvim
```

## Support
For support, please email jclarkie23@icloud.com. Make sure to attach **GitHub - Nvim Config - Name** in the header of the email, and allow 72 hours for a response.

# Tool Installation and Output

The following table documents installation methods, notable configuration files or flags, and links to sample output for each analysis or instrumentation utility.

| Tool | Install | Configuration | Sample Output |
|------|---------|---------------|---------------|
| cloc | `sudo apt install -y cloc` | Optional `--exclude-dir` to skip paths | [cloc](analysis/cloc.md) |
| lizard | `sudo pip install lizard --break-system-packages` | `-l c` to limit languages | [lizard](analysis/lizard.md) |
| cppcheck | `sudo apt install -y cppcheck` | `.cppcheck` suppresses known issues | [cppcheck](analysis/cppcheck.md) |
| sloccount | `sudo apt install -y sloccount` | Supports `--duplicates` flag | [sloccount](analysis/sloccount.md) |
| flawfinder | `sudo apt install -y flawfinder` | `--minlevel` tunes severity | [flawfinder](analysis/flawfinder.md) |
| cscope | `sudo apt install -y cscope` | `cscope.out` database via `cscope -R` | [cscope](analysis/cscope.md) |
| diffoscope | `sudo pip install diffoscope --break-system-packages` | Requires `libmagic1` for file type detection | [diffoscope](analysis/diffoscope.md) |
| gdb | `sudo apt install -y gdb` | `.gdbinit` for session defaults | [gdb](analysis/gdb.md) |
| valgrind | `sudo apt install -y valgrind` | `--tool=memcheck` by default | [valgrind](analysis/valgrind.md) |
| semgrep | `sudo pip install semgrep --break-system-packages` | `--config auto` for heuristics | [semgrep](analysis/semgrep.md) |
| eslint | `sudo npm install -g eslint` | `eslint.config.js` for rules | [eslint](analysis/eslint.md) |
| jshint | `sudo npm install -g jshint` | `.jshintrc` for rules | [jshint](analysis/jshint.md) |
| jscpd | `sudo npm install -g jscpd` | `--min-lines` adjusts clone size | [jscpd](analysis/jscpd.md) |
| nyc | `sudo npm install -g nyc` | `.nycrc` controls coverage behavior | [nyc](analysis/nyc.md) |
| pylint | `sudo pip install pylint --break-system-packages` | `pyproject.toml` with `[tool.pylint]` | [pylint](analysis/pylint.md) |
| flake8 | `sudo pip install flake8 --break-system-packages` | `.flake8` for rule tweaks | [flake8](analysis/flake8.md) |
| mypy | `sudo pip install mypy --break-system-packages` | `mypy.ini` or `pyproject.toml` | [mypy](analysis/mypy.md) |
| dtrace | source build from <https://github.com/dtrace4linux/linux.git> | kernel headers and build tools required | [dtrace](analysis/dtrace.md) |

Each linked report captures the first few lines of the tool's output when invoked against the source tree.

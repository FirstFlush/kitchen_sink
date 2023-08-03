# Kitchen Sink - Wordlist Aggregation and Hash Cracking

Kitchen Sink is a Bash script that automates the process of grabbing every wordlist in a directory, feeding them to "John the Ripper" for hash cracking, and recursively gathering wordlists from subdirectories. It is designed primarily for use with the "seclists" wordlists, but it can work with other wordlist directories too.

## Prerequisites

To use Kitchen Sink, you need to have the following software installed on your system:

- John the Ripper: The popular password-cracking tool. You can find more information about John the Ripper at: https://www.openwall.com/john/

## Usage

1. Clone the repository or download the "kitchen_sink.sh" script.

2. Navigate to the directory containing your wordlists. For example, if you are using "seclists," you can go to "/usr/share/seclists" directory:

   ```bash
   cd /usr/share/seclists
   chmod +x kitchen_sink.sh
   ./kitchen_sink.sh -d <dir> -f <JtR format> -H <file containing hash>

## Warning

Please use this script responsibly and only on systems you have permission to test.

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvement, please feel free to open an issue or submit a pull request.


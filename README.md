```markdown
# 🎵 Audio Normalizer

A simple Perl script that normalizes audio levels in MP3 files using FFmpeg's loudnorm filter. Perfect for making a collection of MP3s play at consistent volume levels.

## 📋 What It Does

This tool helps you:

- Check the current audio levels of MP3 files
- Normalize MP3s to broadcast-standard loudness (EBU R128)
- Process single files or entire directories
- Keep originals safe while creating normalized versions

The script uses FFmpeg's loudnorm filter with professional settings: -16.5 LUFS integrated loudness, -1.5 dB true peak, and 11.0 LU loudness range. These settings work great for podcasts, music collections, and audiobooks.

## 🔧 Dependencies

**Required Perl Modules:**

- `Term::ANSIColor` - Creates the colored terminal output
- `FindBin` - Finds where the script lives on your system
- `Data::Dumper` - Used for debugging

**Required External Tools:**

- `ffmpeg` - Does all the heavy lifting for audio analysis and normalization

**Installing Dependencies:**

```bash
# Install Perl modules
cpan Term::ANSIColor FindBin

# Install FFmpeg on Debian/Ubuntu
sudo apt-get install ffmpeg

# Install FFmpeg on macOS
brew install ffmpeg
```

## 🚀 Usage

```bash
# Check levels of a single file
./audio_normalizer.pl /path/to/song.mp3

# Normalize a single file
./audio_normalizer.pl /path/to/song.mp3

# Process an entire directory
./audio_normalizer.pl /path/to/music/folder
```

The script creates a `normalized` subdirectory in the same location as the script and saves processed files there.

## 📄 License

MIT License - See LICENSE file for details.
```

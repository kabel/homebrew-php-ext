![](https://repository-images.githubusercontent.com/127686768/dc404b00-f5dd-11ea-95bd-7de02ed45411)

# kabel/php-ext
[![](https://img.shields.io/github/sponsors/kabel?style=social)](https://github.com/sponsors/kabel/)
[![](https://img.shields.io/azure-devops/build/kevinabel0613/kevinabel/2?style=social)](https://dev.azure.com/kevinabel0613/kevinabel/_build?definitionId=2)

Core PHP extension formulae for the Homebrew package manager. These extensions are not a part of [Homebrew/core](https://github.com/Homebrew/homebrew-core/) because they are either not popular enough or have known stability problems.

This tap includes one of the sources for the popular `imap` extension that isn't included in the core homebrew `php` formulae because of default system performance issues.

## What about other formulae (PECL)?
Users have previously asked about a tap that contains pre-built binary packages (bottles) of other PHP extensions, like `xdebug` and `imagick`. Initially I didn't want to try and support those and encouraged users to use the `pecl` installer. Now that the upstream PHP team is phasing out the PEAR/PECL tools in the newest releases, I've started a new tap that has some of the most popular extensions from the PECL registry.

See [kabel/pecl](https://github.com/kabel/homebrew-pecl). And consider tapping it too: `brew tap kabel/pecl`

## How do I install these formulae?

Run

```
brew tap kabel/php-ext
```

followed by

```
brew install <formula>
```

## Troubleshooting
First, please run `brew update` and `brew doctor`.

Second, read the [Troubleshooting Checklist](https://docs.brew.sh/Troubleshooting).

**If you don't read these it will take us far longer to help you with your problem.**

## License
Code is under the [BSD 2-clause "Simplified" License](https://github.com/Homebrew/homebrew-core/blob/master/LICENSE.txt).

# kabel/php-ext
Core PHP extension formulae for the Homebrew package manager. These extensions are not a part of [Homebrew/core](https://github.com/Homebrew/homebrew-core/) because they are either not popular enough or have known stability problems.

Other extensions that used to be available from, the now deprecated, [Homebrew/php](https://github.com/Homebrew/homebrew-php/) should be installed through [PECL](https://pecl.php.net/).

---

_Experimental_: I have a new tap for select pecl packages, as the `pecl` command is being phased out. See [kabel/pecl](https://github.com/kabel/homebrew-pecl).

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

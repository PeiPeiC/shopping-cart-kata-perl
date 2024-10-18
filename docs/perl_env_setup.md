
# Perl Project Setup Instructions

This document outlines the steps to install Perl modules in a local directory using `local::lib`, avoiding the need for system-wide installation, and ensuring your environment is configured correctly for future use.

## 1. Install Perl Modules Locally with `local::lib`

When working on a Perl project without system-wide access or to avoid interfering with the system's Perl installation, it's recommended to use `local::lib` to install Perl modules in your user directory.

### Step-by-step Instructions:

1. Run the following command to install `local::lib` and set up the environment for installing Perl modules to your local directory (`~/perl5`):

   ```bash
   cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
   ```

   This command does the following:
   - Installs `local::lib`, which allows Perl modules to be installed in `~/perl5`.
   - Configures your current shell session to recognize this local directory.

2. Confirm that `local::lib` was installed successfully and modules are placed in the local directory:

   ```bash
   ls ~/perl5/lib/perl5
   ```

   You should see directories corresponding to installed modules, such as `Test2` or `Test`.

3. To install additional Perl modules (e.g., `Test2::Suite`), use the following command:

   ```bash
   cpanm Test2::Suite
   ```

   This will install the module to `~/perl5`, avoiding the system-wide directories.

## 2. Verify Module Installation

After installing the necessary Perl modules, verify that they are properly installed and can be used in your project. Run this command to check if the module loads correctly:

```bash
perl -MTest2::V0 -e 'print "Test2::Suite loaded successfully\n";'
```

If the module is loaded successfully, the output will be:

```
Test2::Suite loaded successfully
```

## 3. Make the Local Installation Permanent

To ensure that your local Perl module directory (`~/perl5`) is used every time you open a new terminal session, you should add the following line to your shell configuration file (`.bashrc` or `.bash_profile`):

```bash
eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
```

### Steps:

1. Open `.bashrc` or `.bash_profile` (depending on your shell configuration) in a text editor:

   ```bash
   nano ~/.bashrc
   ```

2. Add the following line at the end of the file:

   ```bash
   eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
   ```

3. Save the file and reload the shell configuration:

   ```bash
   source ~/.bashrc
   ```

This will ensure that every time you open a new terminal session, Perl will automatically search your local module directory (`~/perl5`) for installed modules.

## 4. Summary

- Use `local::lib` to install Perl modules to your local directory (`~/perl5`).
- Ensure modules are loaded correctly by testing them with a simple Perl command.
- Permanently configure your shell to recognize the local module directory by adding the `eval` command to your shell configuration file.

With these steps, you can safely install and manage Perl modules without requiring system-wide access or interfering with the system's Perl installation.

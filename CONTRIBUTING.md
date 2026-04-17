# Contributing to Universal Disk Cleanup Tool

Thank you for your interest in contributing! This document explains the workflow and guidelines for contributing.

## Branch Structure

This repository uses a simple Git workflow:

- **`master`** - Stable production branch (contains released versions)
- **`dev`** - Development branch (contains latest features and fixes)

## Development Workflow

### For Contributors

1. **Fork the repository**
   ```bash
   # Fork on GitHub, then clone your fork
   git clone https://github.com/YOUR_USERNAME/UniversalDiskCleanupTool.git
   cd UniversalDiskCleanupTool
   ```

2. **Create a feature branch**
   ```bash
   git checkout dev
   git pull origin dev
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Write clean, documented code
   - Test on multiple platforms if possible
   - Update documentation as needed

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "Describe your changes"
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request**
   - Target the `dev` branch (NOT master)
   - Describe your changes clearly
   - Reference any related issues

### For Maintainers

#### Creating a Release

1. **Ensure dev is stable**
   ```bash
   git checkout dev
   git pull origin dev
   ```

2. **Test thoroughly on all platforms**

3. **Merge to master**
   ```bash
   git checkout master
   git merge dev
   git push origin master
   ```

4. **Create a version tag**
   ```bash
   git tag v5.2.5
   git push origin v5.2.5
   ```

   This automatically triggers the multi-OS release workflow!

#### Hotfix Workflow

For urgent fixes to production:

1. **Create hotfix branch from master**
   ```bash
   git checkout master
   git checkout -b hotfix/urgent-fix
   ```

2. **Make and test the fix**

3. **Merge to both branches**
   ```bash
   # Merge to master first
   git checkout master
   git merge hotfix/urgent-fix
   git push origin master

   # Then merge to dev
   git checkout dev
   git merge master
   git push origin dev
   ```

4. **Create release tag**
   ```bash
   git tag v5.2.5
   git push origin v5.2.5
   ```

## Coding Standards

### PowerShell

- Use `PSCore` (PowerShell 7+) for cross-platform compatibility
- Follow PowerShell best practices
- Use approved verbs for function names
- Add comment-based help for functions
- Handle errors gracefully with try/catch

### Shell Scripts

- Use POSIX-compliant bash
- Add shebang: `#!/bin/bash`
- Check for required dependencies
- Provide clear error messages

### General

- Keep code simple and readable
- Add comments for complex logic
- Test on Windows, macOS, and Linux when possible
- Update documentation for user-facing changes

## Platform-Specific Testing

### Windows
- Test on Windows 10/11
- Verify PowerShell 7+ compatibility
- Test GUI launcher (START.bat/launcher.ps1)

### macOS
- Test on macOS 10.14+
- Verify Homebrew PowerShell installation
- Test Unix launcher (start.sh)

### Linux
- Test on Ubuntu/Debian, Fedora, and Arch if possible
- Verify PowerShell installation via package managers
- Test Unix launcher (start.sh)

## Testing Before Submitting

1. **Syntax check**
   ```bash
   pwsh -NoProfile -NonInteractive -Command "Invoke-ScriptAnalyzer -Path cleanup.ps1"
   ```

2. **Dry run**
   ```bash
   pwsh -File cleanup.ps1 --DryRun --All
   ```

3. **Platform verification**
   - Check OS detection works correctly
   - Verify platform-specific paths
   - Test permission handling

## Release Process

When you push a version tag (e.g., `v5.2.5`):

1. GitHub Actions automatically builds releases for:
   - Windows (ZIP with GUI)
   - macOS (tar.gz)
   - Linux (tar.gz)

2. Release notes are auto-generated

3. Artifacts are published to GitHub Releases

## Questions?

- Open an issue for bugs or feature requests
- Check existing issues and PRs first
- Be respectful and constructive

Thank you for contributing! 🎉

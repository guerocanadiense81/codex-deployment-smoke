# Deployment smoke site

This repository is a minimal, dependency-free static site prepared for a controlled GitHub Pages deployment check.

## Local verification

Run in PowerShell 7:

```powershell
& '.\verify.ps1'
```

The verifier checks the required files, UTF-8 text, the HTML entry point, viewport metadata, title, and absence of workspace or credential material.

## Recommended first deployment

Use GitHub Pages with the repository's `main` branch and root folder as the publishing source. This requires no framework, package installation, build service, secret, or custom domain.

GitHub Pages is available from public repositories on GitHub Free. Private-repository Pages support depends on the account plan. Review the repository visibility before publishing.

Official documentation:

- [Creating a GitHub Pages site](https://docs.github.com/en/pages/getting-started-with-github-pages/creating-a-github-pages-site)
- [Configuring a publishing source](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site)

## Boundaries

- The repository contains no credentials, model files, private data, external analytics, or deployment tokens.
- Render and Vercel are alternative deployment targets. They are not required for this GitHub Pages check.
- Publishing, custom-domain setup, account connection, and remote repository creation are separate external actions.

# GitHub Actions for Persian LaTeX Report

This directory contains GitHub Actions workflows for automatically building and testing the Persian LaTeX report.

## Workflows

### 1. `build-pdf.yml` - Main Build Workflow

**Triggers:**

- ✅ New releases (when you publish a release)
- ✅ Push to main/master branch
- ✅ Manual trigger via GitHub UI
- ✅ Changes to `.tex`, `.bib`, or image files

**What it does:**

1. Builds the Docker image with Persian fonts
2. Compiles the LaTeX document (3 passes + BibTeX)
3. Uploads PDF as artifact (90 days retention)
4. **On releases**: Attaches PDF to the release as `persian-report-{version}.pdf`
5. **On failure**: Uploads compilation logs for debugging

### 2. `test-build.yml` - Test Workflow

**Triggers:**

- ✅ Pull requests to main/master
- ✅ Push to development branches
- ✅ Changes to LaTeX files or workflows

**What it does:**

1. Quick compilation test (single pass)
2. Validates LaTeX syntax
3. Uploads test PDF (7 days retention)
4. **On failure**: Uploads logs for debugging

## Usage

### Creating a Release

1. **Tag your version:**

   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. **Create release on GitHub:**

   - Go to your repository → Releases → "Create a new release"
   - Choose the tag you created
   - Add release notes
   - Click "Publish release"

3. **Automatic PDF generation:**
   - The workflow will automatically trigger
   - PDF will be compiled and attached to the release
   - File name: `persian-report-v1.0.0.pdf`

### Manual Build

You can manually trigger the build workflow:

1. Go to Actions tab in your repository
2. Select "Build Persian LaTeX Report"
3. Click "Run workflow"
4. Download the PDF from artifacts

### Monitoring Builds

- **View progress:** Actions tab → Select workflow run
- **Download artifacts:** Scroll down to "Artifacts" section
- **Check logs:** Click on job steps to see detailed logs

## Artifacts

### Build Artifacts (90 days)

- `persian-report-pdf` - The compiled PDF file

### Test Artifacts (7 days)

- `test-pdf-{commit}` - Quick test compilation
- `test-logs-{commit}` - Logs if test fails

### Error Artifacts (30 days)

- `latex-logs` - Compilation logs when build fails

## Requirements

### Repository Setup

1. **Dockerfile location:** The workflow expects the Dockerfile to be in the parent directory (`../Dockerfile`)

2. **Repository structure:**

   ```
   your-repo/
   ├── Dockerfile              # Persian LaTeX Docker image
   ├── persian-report/         # This directory
   │   ├── main.tex           # Main LaTeX file
   │   ├── config/            # LaTeX configuration
   │   ├── chapters/          # Report chapters
   │   ├── images/            # Images directory
   │   └── .github/workflows/ # GitHub Actions
   ```

3. **Permissions:** Repository needs `contents: write` permission for releases (usually enabled by default)

### Customization

#### Change PDF name pattern:

Edit `build-pdf.yml`, line with `asset_name`:

```yaml
asset_name: my-custom-name-${{ github.event.release.tag_name }}.pdf
```

#### Add more file types to trigger:

Edit the `paths` section in workflows:

```yaml
paths:
  - "**.tex"
  - "**.bib"
  - "**.cls" # Add custom class files
  - "**.sty" # Add style files
  - "images/**"
```

#### Change retention periods:

```yaml
retention-days: 30 # Change from 90 to 30 days
```

## Troubleshooting

### Common Issues

1. **Docker build fails:**

   - Check if Dockerfile exists in parent directory
   - Verify Docker syntax in Dockerfile

2. **LaTeX compilation fails:**

   - Check the logs in failed workflow
   - Test locally with `./compile.sh`
   - Look for missing packages or syntax errors

3. **PDF not attached to release:**

   - Ensure workflow triggered on release publish
   - Check if `GITHUB_TOKEN` has proper permissions
   - Verify the release was published (not just created as draft)

4. **Fonts missing:**
   - Ensure Docker image includes all required Persian fonts
   - Check font paths in `config/settings.tex`

### Debug Steps

1. **Check workflow logs:**

   - Actions tab → Failed workflow → Click on job steps

2. **Download compilation logs:**

   - Failed builds upload `latex-logs` artifact
   - Contains `.log`, `.aux`, `.out` files

3. **Test locally:**

   ```bash
   # Build Docker image
   docker build -t persian-latex .

   # Test compilation
   cd persian-report
   docker run --rm -v "$(pwd):/work" persian-latex xelatex main.tex
   ```

## Security Notes

- Workflows use official GitHub Actions (checkout@v4, upload-artifact@v4)
- No external dependencies or third-party actions
- Uses built-in `GITHUB_TOKEN` (no custom tokens needed)
- Docker builds are isolated and don't persist

## Performance

- **Build time:** ~3-5 minutes (depending on document complexity)
- **Docker image:** ~1.5GB (includes full TeX Live + Persian fonts)
- **Parallel jobs:** Test and build workflows can run simultaneously
- **Caching:** Docker layers are cached between runs for faster builds

## Support

If you encounter issues:

1. Check the workflow logs first
2. Test compilation locally
3. Review LaTeX syntax and file paths
4. Ensure all required files are committed to repository

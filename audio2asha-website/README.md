# Audio2ASHA website

A small documentation website for Audio2ASHA, built with [Zensical](https://zensical.org/)
and designed to publish on GitHub Pages.

## Pages

- `docs/index.md` — project overview, credits, and licensing notes.
- `docs/making-of.md` — photo-rich build log.

## Preview locally

Install Python if needed, then run:

```bash
python -m pip install zensical
zensical serve
```

Open the local address printed by Zensical (usually http://127.0.0.1:8000).

Build the static website with:

```bash
zensical build
```

## Publish with GitHub Pages

1. Create a GitHub repository for this website and upload these files.
2. In `zensical.toml`, set `site_url` to the final GitHub Pages URL. For a
   project repository this is usually `https://YOUR-USERNAME.github.io/YOUR-REPOSITORY/`.
3. In the repository settings, open **Pages** and set the source to **GitHub Actions**.
4. Push to the `main` branch. The included workflow builds the site and publishes it.
5. Replace the image placeholders on the Making of page with your own photos in
   `docs/images/`.

The workflow assumes the default branch is named `main`. If your default branch
has another name, edit `.github/workflows/deploy.yml`.

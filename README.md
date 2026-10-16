# jdsaa.com

Company website for JD Software Architecture Analytics AB. Source: https://github.com/jokkopucko/jdsaa-site. GitHub Pages serves the static HTML files on the default branch at https://jdsaa.com/.

## Pages

- `index.html`: company home page.
- `services.html`, `about.html`, `contact.html`: company information.
- `products.html`: Better QR overview and links.
- `better-qr-support.html`: https://jdsaa.com/better-qr-support.html.
- `better-qr-privacy.html`: https://jdsaa.com/better-qr-privacy.html.
- `style.css`: shared styles; there is no generator or dependency build.
- `CNAME`: custom domain, `jdsaa.com`.
- `.nojekyll`: serves these files without Jekyll processing.

The Better QR support and privacy URLs are configured in App Store Connect. Keep app-review contact details out of public website source.

## Preview and checks

Use an isolated worktree and a `jd-` branch under the current agent directions. From the site directory, run `bash check.sh .`. Preview with `python3 -m http.server 8765 --bind 127.0.0.1`, then open http://127.0.0.1:8765/. Check changed pages and navigation in a browser before landing.

## Deployment

Create a `jojo-review` bundle, obtain the required landing approval, and integrate through `jd-merge`. A push to the default branch triggers GitHub's Pages build and deployment. No separate asset build is needed.

Before a deployment, record the published commit. After the push, check the successful `pages build and deployment` run and confirm its `head_sha` matches the new merge commit. `gh api repos/jokkopucko/jdsaa-site/actions/runs` lists recent runs. Then verify the changed URLs over HTTPS and compare their content with the reviewed files. A successful push alone does not prove deployment; new paths can return 404 while Pages is building.

## DNS and original setup

The Obsidian vault note `projects/jdsaa/2026-08-29-jdsaa-website-design.md` records the original design, DNS changes, HTTPS setup and registrar access investigation. Recheck historical configuration before using it. Preserve mail DNS records when changing web hosting.

Routine content changes do not require DNS or certificate changes. HTTPS and deployment are handled by GitHub Pages. Recheck the repository's Pages settings before changing the domain or publishing source.

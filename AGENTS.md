# Instructions for AI agents

This is the website for Encore Projects (encoreprojects.co.uk), a small project
management consultancy. The site owner and the person who reviews changes are
not developers. Keep everything simple.

## The rules

1. **Always work on the `staging` branch, or a branch made from it.** Never push to `main`.
2. **Going live means a pull request from `staging` into `main`, merged by a human.** Never merge it yourself.
3. **Keep changes small.** One request, one small change. Do not tidy up or restructure things you were not asked to change.
4. **Describe the change plainly in the pull request**, for a non-technical reader:
   what a visitor will see differently, and on which part of the page. No jargon.
5. **Never invent facts about the business** (prices, phone numbers, client names, quotes, years of experience).
   If something is missing, leave a `TODO:` comment in the HTML and add it to `TODO.md`.
6. **No frameworks, no build step, no new dependencies, no tracking or analytics scripts.**
   The site is plain HTML, CSS and a little vanilla JavaScript on purpose.

## How publishing works

| Branch | Publishes to | How |
|--------|--------------|-----|
| `staging` | The preview site, `https://<org>.github.io/staging/` | `.github/workflows/deploy-staging.yml` runs on every push. It adds a "noindex" tag and a red STAGING banner, then pushes the files to the separate `<org>/staging` repository. |
| `main` | The live site, `https://encoreprojects.co.uk` | `.github/workflows/deploy-prod.yml` runs on every push (that is, when a human merges a pull request). |

Both workflows use `.github/scripts/build-site.sh` to decide which files are published.
Not published: `_wix-export/`, `.github/`, and all `.md` files. The staging site also leaves out `CNAME`, `robots.txt` and `sitemap.xml`.

Do not add the noindex tag or the STAGING banner to the HTML files yourself. The staging workflow adds them, and the production build fails if it finds them.

## Site structure

```
index.html            The whole site: one page with sections
privacy.html          Privacy policy (placeholder text for now)
assets/css/styles.css All styling
assets/js/main.js     Footer year + contact form sending. Nothing else.
assets/img/           Images used by the site (already resized and compressed)
assets/fonts/         The two fonts, self-hosted
favicon.ico           Browser tab icon
CNAME, robots.txt, sitemap.xml   Live-site settings
TODO.md               Open items and setup steps for the humans
_wix-export/          The original Wix site, kept for reference only. Never edit or publish it.
```

`index.html` has clearly marked sections, in this order:

| Section | Marker in the file | `id` |
|---------|--------------------|------|
| Header and navigation | `HEADER` | |
| Hero (headline, intro, "Book a Free Discovery Call" button) | `HERO` | `home` |
| About ("Who We Are") | `ABOUT` | `about` |
| Our Approach | `OUR APPROACH` | `approach` |
| Testimonials (currently hidden) | `TESTIMONIALS (HIDDEN)` | `testimonials` |
| Contact form | `CONTACT` | `contact` |
| Footer | `FOOTER` | |

Navigation links and the discovery-call button scroll to a section using its `id` (for example `href="#contact"`).

## Where things live

- **Text:** directly in `index.html` (or `privacy.html`). Find the section marker and edit the words between the tags.
- **Images:** in `assets/img/`. Original, full-size artwork is in `_wix-export/wix media files/`.
- **Colours, fonts and sizes:** the `:root` block at the top of `assets/css/styles.css`.
- **Contact form destination:** the `action` attribute of the `<form>` in the Contact section (Formspree).

## Common tasks

### Change some text
Edit the words in `index.html`. Keep the surrounding tags. `<strong>` is bold, `<em>` is italic, `<span class="medium">` is the slightly heavier weight used for emphasis.

### Add or replace an image
1. Resize it first: no wider than twice the width it is displayed at, and aim for under 100 KB. Use PNG for flat artwork and logos, JPG for photos.
2. Save it in `assets/img/` with a lowercase, descriptive, hyphenated name (for example `team-workshop-800.jpg`).
3. Reference it with a relative path, and always give `width`, `height` and a meaningful `alt` description:
   `<img src="assets/img/team-workshop-800.jpg" width="800" height="533" alt="Workshop with a client team around a whiteboard">`
4. Purely decorative images get `alt=""`.

### How to add a testimonial
Only add testimonials the owner has supplied. Never write or embellish one.

The Testimonials section in `index.html` is hidden inside an HTML comment until real ones exist.

- **First real testimonial:** in the `TESTIMONIALS (HIDDEN)` block, replace the `TODO` name and quote,
  then un-hide the section by deleting the whole line that contains `TESTIMONIALS-START`
  and the whole line that contains `TESTIMONIALS-END`. Also un-comment the Testimonials link in the header navigation,
  and remove the testimonials row from `TODO.md`.
- **Each further testimonial:** copy one whole block and paste it below the last one:

  ```html
  <li class="testimonial">
    <p class="testimonial-name">Client name</p>
    <blockquote>"What they said."</blockquote>
  </li>
  ```

### How to change pricing
There is **no pricing on the site at the moment** (the original site had none).

- If asked to *change* a price, first check `index.html`: if a pricing section has been added since, it will be marked `PRICING` and the prices are plain text inside it. Change only the numbers you were asked to change.
- If asked to *add* pricing, add a new `<section id="pricing" class="section section--cream">` between Our Approach and Contact, marked with a `PRICING` comment like the other sections, reusing existing styles (`h2`, `h3`, `p`). Use only the prices the owner gives you, written in pounds (for example `£450 per day`), and say in the pull request exactly which prices were added.

### Change the contact form
The fields are in the Contact section of `index.html`. Each field's `name` is the label shown in the email Formspree sends. Leave the hidden `_gotcha` field alone: it is the spam trap.

## Style conventions

- **Paths are always relative** (`assets/img/logo.png`, never `/assets/img/logo.png`). The site must work both at the domain root and under `/staging/`. The only absolute URLs are the `canonical` and Open Graph tags in `<head>`, which must point at the live domain.
- **HTML:** two-space indentation, semantic tags (`header`, `nav`, `main`, `section`, `footer`), one `<h1>` per page, headings in order. British English spelling ("organisations").
- **CSS:** mobile-first. Base rules are for phones; the single `@media (min-width: 48rem)` block at the bottom handles wider screens. Use the existing variables (`--lime`, `--cream`, `--navy`, `--sage`, `--text-body` and so on) instead of new hard-coded colours or sizes. Plain class names, no IDs for styling, no inline styles.
- **JavaScript:** avoid it. If it is truly needed, add it to `assets/js/main.js` in plain vanilla JS with a comment saying what it does.
- **Accessibility:** every image has `alt`, every form field has a `<label>`, links and buttons have a visible focus outline, and text must keep good contrast against its background (dark navy on lime or cream; lime on dark sage).
- **Placeholders:** marked `TODO:` in an HTML comment and listed in `TODO.md`. When you resolve one, remove it from both places.

## Checking your work

There is nothing to install. To preview, open `index.html` in a browser, or run `python3 -m http.server` in the repository folder and visit `http://localhost:8000`.

Before opening a pull request, check that:

- the page looks right at phone width (about 390px) and desktop width;
- the navigation links and the discovery-call button still scroll to the right sections;
- you have not added absolute paths, a noindex tag, or anything inside `_wix-export/`.

To see exactly what will be published: `.github/scripts/build-site.sh _site prod` (then delete the `_site` folder).

# TODO

Things a human needs to do or decide. Nothing here has been invented or guessed:
where the old Wix site had template placeholder text, the new site shows nothing
until the real information is supplied.

Search the code for `TODO:` to find each spot.

## Content to fill in

| # | What | Where | Current state |
|---|------|-------|---------------|
| 1 | Optional: a real portrait photo of Paul for the About Me section (never a stock or generated photo of a person) | `index.html`, About Me section | Illustration shown instead |
| 2 | Phone number, if one should be shown (Wix placeholder was 123-456-7890) | `index.html`, footer | Contact block is commented out |
| 3 | Email address, if one should be shown (Wix placeholder was info@mysite.com) | `index.html`, footer | Contact block is commented out |
| 4 | Postal address, if one should be shown (Wix placeholder was 500 Terry Francine St. San Francisco, CA 94158) | `index.html`, footer | Contact block is commented out |
| 5 | Real testimonials. The three on the Wix site (mentioning "A. Oliveira") were template filler and were not copied over | `index.html`, Testimonials section | Whole section is commented out. See "How to add a testimonial" in `AGENTS.md` |
| 6 | Social media links, if Encore Projects has its own accounts. The Wix site linked to Wix's own Facebook, Twitter and TikTok, so these were removed | `index.html`, footer | Removed |
| 7 | Privacy policy text | `privacy.html` | Placeholder outline only. Should be written before going live, because the form collects names and email addresses |

## Before going live

The contact form is the only way for a visitor to get in touch, so the site should not
replace the live one until item 7 is done and one real test message has been
sent and received by the owner.

Removed in the November 2026 rewrite (the first-person "Experience makes a difference." version):

- The "Plan, Deliver, Embed" graphic. The original file is still in `_wix-export/`.
- The optional Phone field on the contact form, replaced by an optional Business name field.
- The "Book a Free Discovery Call" button, because no free call has been confirmed.
- The old section addresses `#about` and `#approach` are now `#about-me` and `#my-approach`.
  A link to an old address still opens the site, at the top of the page.

Also removed from the Wix version, with no action needed unless you want them back:

- Terms & Conditions, Refund Policy and Accessibility Statement links (they pointed nowhere).
- The "Stay Tuned" newsletter signup.
- "Powered and secured by Wix".
- "© 2035": the footer now shows the current year automatically.

## Setup steps (one-off, done in GitHub and elsewhere)

- [ ] Create a public repository called `staging` in the same GitHub organisation.
- [ ] Create an SSH deploy key (`ssh-keygen -t ed25519 -f staging_deploy_key -N ""`).
      Add the **public** half to the `staging` repo (Settings → Deploy keys, tick "Allow write access").
      Add the **private** half to this repo as a secret named `STAGING_DEPLOY_KEY`
      (Settings → Secrets and variables → Actions). Then delete both local key files.
- [ ] Push to `staging` (or re-run the "Deploy staging" workflow) so the `staging` repo gets its first content.
- [ ] Enable Pages on the `staging` repo: Settings → Pages → Source = "Deploy from a branch", branch `main`, folder `/ (root)`.
      (That repo only receives finished files and has no workflow of its own, so "GitHub Actions" would publish nothing there.)
- [ ] Enable Pages on this repo: Settings → Pages → Source = "GitHub Actions".
- [ ] Add branch protection on `main` in this repo: require a pull request before merging.
- [ ] In that branch protection rule, also tick "Require status checks to pass" and choose the `check` job, so a pull request that breaks the rules in `AGENTS.md` cannot be merged.
- [ ] Recommended: make `staging` the default branch (Settings → General → Default branch). AI tools such as Codex start from the default branch and aim their pull requests at it, so this makes the safe route the automatic one. The live site still publishes from `main`.
- [ ] When merging `staging` into `main`, use "Create a merge commit" (not squash or rebase), so the two branches stay in step.
- [ ] Fill in the content TODOs above.
- [ ] **Only once the new site is approved** (this takes the Wix site offline):
  - [ ] In this repo, Settings → Pages → Custom domain = `encoreprojects.co.uk`.
  - [ ] DNS: four `A` records for `encoreprojects.co.uk` pointing at GitHub Pages:
        `185.199.108.153`, `185.199.109.153`, `185.199.110.153`, `185.199.111.153`.
  - [ ] DNS: a `CNAME` record for `www` pointing at `encore-project-management.github.io`.
  - [ ] When DNS has updated and GitHub shows the certificate is ready, tick "Enforce HTTPS" in Settings → Pages.

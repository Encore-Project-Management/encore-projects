# TODO

Things a human needs to do or decide. Nothing here has been invented or guessed:
where the old Wix site had template placeholder text, the new site shows nothing
until the real information is supplied.

Search the code for `TODO:` to find each spot.

## Content to fill in

| # | What | Where | Current state |
|---|------|-------|---------------|
| 1 | Years of experience and industries. The Wix text was: "Led by a seasoned project manager with over [X] years of experience across [industries/clients if relevant]" | `index.html`, About section | Sentence is commented out |
| 2 | Phone number (Wix placeholder was 123-456-7890) | `index.html`, footer | Contact block is commented out |
| 3 | Email address (Wix placeholder was info@mysite.com) | `index.html`, footer | Contact block is commented out |
| 4 | Postal address, if one should be shown (Wix placeholder was 500 Terry Francine St. San Francisco, CA 94158) | `index.html`, footer | Contact block is commented out |
| 5 | Real testimonials. The three on the Wix site (mentioning "A. Oliveira") were template filler and were not copied over | `index.html`, Testimonials section | Whole section is commented out. See "How to add a testimonial" in `AGENTS.md` |
| 6 | Social media links, if Encore Projects has its own accounts. The Wix site linked to Wix's own Facebook, Twitter and TikTok, so these were removed | `index.html`, footer | Removed |
| 7 | Privacy policy text | `privacy.html` | Placeholder outline only |
| 8 | Formspree form ID: replace `<FORM_ID>` in the form's `action` | `index.html`, Contact section | Form shows "not set up yet" when submitted |

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
- [ ] Create the Formspree form at https://formspree.io and put its ID in `index.html` (item 8 above).
- [ ] Fill in the content TODOs above.
- [ ] **Only once the new site is approved** (this takes the Wix site offline):
  - [ ] In this repo, Settings → Pages → Custom domain = `encoreprojects.co.uk`.
  - [ ] DNS: four `A` records for `encoreprojects.co.uk` pointing at GitHub Pages:
        `185.199.108.153`, `185.199.109.153`, `185.199.110.153`, `185.199.111.153`.
  - [ ] DNS: a `CNAME` record for `www` pointing at `<org>.github.io` (the organisation's GitHub Pages hostname).
  - [ ] When DNS has updated and GitHub shows the certificate is ready, tick "Enforce HTTPS" in Settings → Pages.
